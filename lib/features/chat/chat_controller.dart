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
    await chatRepo.ensureDefaultChat(uid);

    await chatRepo.append(
      uid,
      ChatMessage(
        id: '',
        role: ChatRole.user,
        content: text,
      ),
    );

    final history = await chatRepo.recentMessages(uid, limit: 20);
    final profile = await _ref.read(profileRepoProvider).get(uid);
    final activeProgram = await _ref.read(programsRepoProvider).getActive(uid);
    final notes = await _ref.read(notesRepoProvider).recent(uid, limit: 10);

    final ai = _ref.read(aiServiceProvider(uid));
    final result = await ai.sendMessage(
      userMessage: text,
      context: AiContext(
        profile: profile,
        activeProgram: activeProgram,
        recentNotes: notes,
        locale: locale,
      ),
      history: history.where((m) => m.id != history.last.id).toList(),
    );

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

    final body = result.disclaimerNeeded
        ? '${result.text}\n\n${l10n.chat_disclaimerInjury}'
        : result.text;

    await chatRepo.append(
      uid,
      ChatMessage(id: '', role: ChatRole.model, content: body),
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
