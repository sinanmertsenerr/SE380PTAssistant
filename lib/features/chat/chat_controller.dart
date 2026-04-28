import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ai/ai_service.dart';
import '../../core/models/chat_message.dart';
import '../../core/providers/providers.dart';
import '../../l10n/app_localizations.dart';

class ChatController {
  ChatController(this._ref);

  final Ref _ref;

  Future<void> sendUserMessage({
    required String uid,
    required String text,
    required String locale,
    required AppLocalizations l10n,
  }) async {
    if (text.trim().isEmpty) return;
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
      final profile = await profileFuture;
      final activeProgram = await programFuture;
      final notes = await notesFuture;

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
      );

      if (_ref.read(currentUidProvider) != uid) {
        debugPrint(
          'sendUserMessage: user switched mid-conversation; '
          'abandoning model writes for $uid',
        );
        return;
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
        return;
      }

      for (final event in result.toolEvents) {
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
      }

      if (result.error != null || result.text.isEmpty) {
        await chatRepo.append(
          uid,
          ChatMessage(
            id: '',
            role: ChatRole.model,
            content: l10n.chat_errorGeneric,
          ),
        );
        return;
      }

      final body = result.disclaimerNeeded
          ? '${result.text}\n\n${l10n.chat_disclaimerInjury}'
          : result.text;

      await chatRepo.append(
        uid,
        ChatMessage(id: '', role: ChatRole.model, content: body),
      );
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
    }
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
