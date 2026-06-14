import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ai/ai_service.dart';
import '../../core/models/chat_message.dart';
import '../../core/providers/providers.dart';
import '../../core/repositories/chat_repository.dart';
import '../../l10n/app_localizations.dart';

/// In-flight assistant reply, streamed token-by-token. Null when idle;
/// empty while waiting for the first token of the current turn.
///
/// Incoming deltas land in a pending buffer and are revealed a few characters
/// per tick, so bursty network chunks read as a smooth typewriter flow. The
/// reveal rate scales with the backlog, keeping the bubble at most a few
/// hundred milliseconds behind the model.
class StreamingReplyNotifier extends Notifier<String?> {
  static const _tick = Duration(milliseconds: 30);

  Timer? _timer;
  String _pending = '';
  Completer<void>? _drained;

  @override
  String? build() {
    ref.onDispose(_reset);
    return null;
  }

  void start() {
    _reset();
    state = '';
  }

  void append(String delta) {
    _pending += delta;
    _timer ??= Timer.periodic(_tick, (_) => _reveal());
  }

  /// Completes once every buffered character has been revealed, so the final
  /// persisted message never visibly jumps ahead of the animation.
  Future<void> drain() {
    if (_pending.isEmpty && _timer == null) return Future.value();
    _drained ??= Completer<void>();
    return _drained!.future;
  }

  void clear() {
    _reset();
    state = null;
  }

  void _reveal() {
    if (_pending.isEmpty) {
      _stopTimer();
      return;
    }
    final take = math.min(
      _pending.length,
      math.max(2, _pending.length ~/ 12),
    );
    state = (state ?? '') + _pending.substring(0, take);
    _pending = _pending.substring(take);
  }

  void _reset() {
    _pending = '';
    _stopTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _drained?.complete();
    _drained = null;
  }
}

final streamingReplyProvider =
    NotifierProvider<StreamingReplyNotifier, String?>(
      StreamingReplyNotifier.new,
    );

class ChatController {
  ChatController(this._ref);

  final Ref _ref;

  Future<Duration?> sendUserMessage({
    required String uid,
    required String text,
    required String locale,
    required AppLocalizations l10n,
  }) async {
    if (text.trim().isEmpty) return null;
    final chatRepo = _ref.read(chatRepoProvider);

    try {
      await chatRepo.ensureDefaultChat(uid);
      await chatRepo.append(
        uid,
        ChatMessage(id: '', role: ChatRole.user, content: text),
      );

      final ai = _ref.read(aiServiceProvider(uid));
      final historyFuture = chatRepo.recentMessages(uid, limit: 20);
      final profileFuture = _ref.read(profileRepoProvider).get(uid);
      final programFuture = _ref.read(programsRepoProvider).getActive(uid);
      final notesFuture = _ref.read(notesRepoProvider).recent(uid, limit: 10);

      final fetched = await historyFuture;
      final priorHistory =
          fetched.isNotEmpty &&
              fetched.last.role == ChatRole.user &&
              fetched.last.content == text
          ? fetched.sublist(0, fetched.length - 1)
          : fetched;

      final guard = await ai.classifyMessage(text, history: priorHistory);
      if (guard.retryAfter != null) {
        await _appendRateLimitMessage(chatRepo, uid, guard.retryAfter!, l10n);
        return guard.retryAfter;
      }

      final profile = await profileFuture;
      final activeProgram = await programFuture;
      final notes = await notesFuture;

      final streaming = _ref.read(streamingReplyProvider.notifier)..start();
      final result = await ai.sendMessage(
        userMessage: text,
        context: AiContext(
          profile: profile,
          activeProgram: activeProgram,
          recentNotes: notes,
          locale: locale,
        ),
        history: priorHistory,
        precomputedGuard: guard,
        onTextDelta: (delta) {
          if (_ref.read(currentUidProvider) != uid) return;
          streaming.append(delta);
        },
        onToolEvent: (event) async {
          if (_ref.read(currentUidProvider) != uid) return;
          // Tool cards land in Firestore before the final text, so the
          // streamed bubble resets and resumes below them.
          streaming.start();
          await chatRepo.append(
            uid,
            ChatMessage(
              id: '',
              role: ChatRole.tool,
              toolName: event.name,
              toolArgs: event.args,
              toolResult: event.result,
            ),
          );
        },
      );

      if (_ref.read(currentUidProvider) != uid) {
        debugPrint(
          'sendUserMessage: user switched mid-conversation; '
          'abandoning model writes for $uid',
        );
        return null;
      }

      if (result.text == '__OFF_TOPIC__') {
        await chatRepo.append(
          uid,
          ChatMessage(
            id: '',
            role: ChatRole.model,
            content: l10n.chat_offTopicReply,
          ),
        );
        return null;
      }

      if (result.retryAfter != null) {
        await _appendRateLimitMessage(chatRepo, uid, result.retryAfter!, l10n);
        return result.retryAfter;
      }

      final savedProgram = result.toolEvents.any(
        (e) =>
            (e.name == 'createProgram' || e.name == 'updateProgram') &&
            e.result['ok'] == true,
      );

      if (result.error != null || result.text.isEmpty) {
        // A program tool that actually succeeded must not read as a failure
        // just because the model returned no closing prose after the call.
        await chatRepo.append(
          uid,
          ChatMessage(
            id: '',
            role: ChatRole.model,
            content: savedProgram
                ? l10n.programs_addedFromChat
                : l10n.chat_errorGeneric,
          ),
        );
        return null;
      }

      final body = result.disclaimerNeeded
          ? '${result.text}\n\n${l10n.chat_disclaimerInjury}'
          : result.text;

      await streaming.drain();
      await chatRepo.append(
        uid,
        ChatMessage(id: '', role: ChatRole.model, content: body),
      );
      return null;
    } catch (e, st) {
      debugPrint('sendUserMessage failed: $e\n$st');
      try {
        await chatRepo.append(
          uid,
          ChatMessage(
            id: '',
            role: ChatRole.model,
            content: l10n.chat_errorGeneric,
          ),
        );
      } catch (e2, st2) {
        debugPrint('sendUserMessage: fallback persist failed: $e2\n$st2');
      }
      return null;
    } finally {
      _ref.read(streamingReplyProvider.notifier).clear();
    }
  }

  Future<void> _appendRateLimitMessage(
    ChatRepository chatRepo,
    String uid,
    Duration retryAfter,
    AppLocalizations l10n,
  ) async {
    final seconds = (retryAfter.inMilliseconds / 1000).ceil().clamp(1, 999);
    await chatRepo.append(
      uid,
      ChatMessage(
        id: '',
        role: ChatRole.model,
        content: l10n.chat_errorRateLimited(seconds),
      ),
    );
  }

  Future<void> clearAndOpen({
    required String uid,
    required String locale,
    required String openingInstruction,
  }) async {
    final chatRepo = _ref.read(chatRepoProvider);
    await chatRepo.clear(uid);

    final profile = await _ref.read(profileRepoProvider).get(uid);
    final activeProgram = await _ref.read(programsRepoProvider).getActive(uid);
    final notes = await _ref.read(notesRepoProvider).recent(uid, limit: 10);

    final ai = _ref.read(aiServiceProvider(uid));
    final summary = await ai.generateOpeningSummary(
      context: AiContext(
        profile: profile,
        activeProgram: activeProgram,
        recentNotes: notes,
        locale: locale,
      ),
      customInstruction: openingInstruction,
    );
    if (summary.isEmpty) return;
    await chatRepo.append(
      uid,
      ChatMessage(id: '', role: ChatRole.model, content: summary),
    );
  }
}

final chatControllerProvider = Provider<ChatController>(
  (ref) => ChatController(ref),
);
