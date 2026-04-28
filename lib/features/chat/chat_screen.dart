import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/chat_message.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'chat_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _busy = false;
  String? _lastShownToolMsgId;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String? _programIdFromTool(ChatMessage m) {
    final result = m.toolResult;
    if (result == null) return null;
    if (result['ok'] != true) return null;
    return switch (m.toolName) {
      'createProgram' || 'updateProgram' => result['id'] as String?,
      'setActiveProgram' => result['activated'] as String?,
      _ => null,
    };
  }

  void _maybeShowProgramSnackbar(List<ChatMessage> messages) {
    if (messages.isEmpty) return;
    final last = messages.last;
    if (last.role != ChatRole.tool) return;
    if (last.id == _lastShownToolMsgId) return;
    final programId = _programIdFromTool(last);
    if (programId == null) return;
    _lastShownToolMsgId = last.id;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.programs_addedFromChat),
        action: SnackBarAction(
          label: l10n.programs_openInPrograms,
          onPressed: () => context.go('/programs/$programId'),
        ),
      ),
    );
  }

  Future<void> _send([String? overrideText]) async {
    final text = (overrideText ?? _input.text).trim();
    if (text.isEmpty || _busy) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    setState(() => _busy = true);
    _input.clear();
    await HapticFeedback.selectionClick();
    try {
      await ref
          .read(chatControllerProvider)
          .sendUserMessage(uid: uid, text: text, locale: locale, l10n: l10n);
    } finally {
      if (mounted) setState(() => _busy = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncMessages = ref.watch(_messagesProvider(uid));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _ChatHeader(),
            Expanded(
              child: asyncMessages.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.errors_generic)),
                data: (messages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToEnd();
                    _maybeShowProgramSnackbar(messages);
                  });
                  if (messages.isEmpty) {
                    return _StarterPrompts(onSelect: _send);
                  }
                  return ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      final showAvatar =
                          m.role == ChatRole.model &&
                          (i == 0 || messages[i - 1].role != ChatRole.model);
                      return _MessageBubble(
                        message: m,
                        showAiAvatar: showAvatar,
                      );
                    },
                  );
                },
              ),
            ),
            if (_busy) _ThinkingIndicator(label: l10n.chat_thinking),
            _ComposerBar(
              controller: _input,
              busy: _busy,
              onSend: _send,
              hint: l10n.chat_inputHint,
              attachLabel: l10n.chat_attachLabel,
            ),
          ],
        ),
      ),
    );
  }
}

final _messagesProvider = StreamProvider.family.autoDispose((ref, String uid) {
  return ref.watch(chatRepoProvider).watchMessages(uid);
});

class _ChatHeader extends ConsumerWidget {
  const _ChatHeader();

  Future<void> _confirmAndClear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(dialogCtx);
        return Dialog(
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.chat_clearTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.chat_clearBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogCtx, true),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusLarge,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                  child: Text(l10n.chat_clearAction),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, false),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  child: Text(l10n.common_cancel),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (confirmed != true) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    if (!context.mounted) return;
    final locale = Localizations.localeOf(context).languageCode;
    final instruction = l10n.chat_clearOpeningPrompt;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(chatControllerProvider)
          .clearAndOpen(
            uid: uid,
            locale: locale,
            openingInstruction: instruction,
          );
    } catch (e, st) {
      debugPrint('clearAndOpen failed: $e\n$st');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errors_generic)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const _AiAvatar(size: 32),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chat_aiLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.activeRing,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        l10n.chat_aiTagline,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmAndClear(context, ref),
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l10n.chat_clearAction,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.auto_awesome_rounded, size: size * 0.55, color: accent),
    );
  }
}

class _StarterPrompts extends StatelessWidget {
  const _StarterPrompts({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prompts = [
      l10n.chat_starter1,
      l10n.chat_starter2,
      l10n.chat_starter3,
      l10n.chat_starter4,
    ];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: _AiAvatar(size: 56)),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Text(
                  l10n.chat_aiLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  l10n.chat_aiTagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...prompts.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () => onSelect(p),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMedium,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMedium,
                        ),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm + 2),
                          Expanded(
                            child: Text(
                              p,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.showAiAvatar});

  final ChatMessage message;
  final bool showAiAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (message.role == ChatRole.tool) {
      return _ToolCallCard(message: message);
    }
    final isUser = message.role == ChatRole.user;
    if (isUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.16),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLarge),
                  topRight: Radius.circular(AppSpacing.radiusLarge),
                  bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                  bottomRight: Radius.circular(AppSpacing.radiusSmall),
                ),
              ),
              child: Text(
                message.content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: showAiAvatar
                ? const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: _AiAvatar(size: 28),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusSmall),
                    topRight: Radius.circular(AppSpacing.radiusLarge),
                    bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                    bottomRight: Radius.circular(AppSpacing.radiusLarge),
                  ),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.25,
                    ),
                  ),
                ),
                child: MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolCallCard extends StatelessWidget {
  const _ToolCallCard({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ok = message.toolResult?['ok'] == true;
    final summary = _summary(message.toolName ?? '', l10n);
    final sources = _sources(message);
    final accent = ok ? AppColors.activeRing : theme.colorScheme.error;
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 4, 0, 4),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm + 2,
          AppSpacing.sm,
          AppSpacing.sm + 2,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: accent.withValues(alpha: 0.32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  size: 14,
                  color: accent,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    summary,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
            if (sources.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.chat_sourcesLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              ...sources.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs + 2),
                      Expanded(
                        child: Text(
                          s.title?.isNotEmpty == true
                              ? s.title!
                              : (s.domain ?? s.uri ?? ''),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _summary(String tool, AppLocalizations l) {
    return switch (tool) {
      'updateProfile' => l.chat_toolProfileUpdated,
      'createProgram' => l.chat_toolProgramCreated,
      'updateProgram' => l.chat_toolProgramUpdated,
      'setActiveProgram' => l.chat_toolProgramUpdated,
      'createNote' => l.chat_toolNoteCreated,
      'scheduleReminder' => l.chat_toolReminderScheduled,
      'lookupSource' => l.chat_toolSourceLookup,
      _ => tool,
    };
  }

  List<({String? title, String? uri, String? domain})> _sources(
    ChatMessage m,
  ) {
    if (m.toolName != 'lookupSource') return const [];
    final raw = m.toolResult?['sources'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(
          (m) => (
            title: m['title'] as String?,
            uri: m['uri'] as String?,
            domain: m['domain'] as String?,
          ),
        )
        .toList();
  }
}

class _ThinkingIndicator extends StatelessWidget {
  const _ThinkingIndicator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          const _AiAvatar(size: 22),
          const SizedBox(width: AppSpacing.sm + 2),
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.6,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.busy,
    required this.onSend,
    required this.hint,
    required this.attachLabel,
  });

  final TextEditingController controller;
  final bool busy;
  final Future<void> Function([String?]) onSend;
  final String hint;
  final String attachLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 6, 6, 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  textAlignVertical: TextAlignVertical.center,
                  minLines: 2,
                  maxLines: 2,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.35),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintMaxLines: 1,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.35,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton.filled(
                  onPressed: busy ? null : () => onSend(),
                  icon: const Icon(Icons.arrow_upward_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
