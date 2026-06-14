import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/chat_message.dart';
import '../../core/models/exercise.dart';
import '../../core/models/program.dart';
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
  bool _cooling = false;
  bool _autoScroll = true;
  bool _seededHistory = false;
  int _lastMsgCount = 0;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;
  final Set<String> _shownToolMsgIds = <String>{};
  final Set<String> _importInFlight = <String>{};
  final Set<String> _importedMsgIds = <String>{};

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    _autoScroll = _scroll.position.maxScrollExtent - _scroll.offset < 120;
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _scroll.removeListener(_onScroll);
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
    if (messages.isEmpty) {
      _seededHistory = true;
      return;
    }
    String? newestProgramId;
    for (final m in messages) {
      if (m.role != ChatRole.tool) continue;
      if (m.id.isEmpty) continue;
      if (_shownToolMsgIds.contains(m.id)) continue;
      final programId = _programIdFromTool(m);
      if (programId == null) continue;
      _shownToolMsgIds.add(m.id);
      newestProgramId = programId;
    }
    // First load of an existing conversation: mark prior programs as seen
    // without notifying — only newly created programs trigger a snackbar.
    if (!_seededHistory) {
      _seededHistory = true;
      return;
    }
    if (newestProgramId == null) return;
    final programId = newestProgramId;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(l10n.programs_addedFromChat),
          action: SnackBarAction(
            label: l10n.programs_openInPrograms,
            onPressed: () {
              messenger.hideCurrentSnackBar();
              context.go('/programs/$programId');
            },
          ),
        ),
      );
  }

  static const _programHints = <String>[
    'gün:',
    'gün ',
    'day:',
    'day ',
    'set',
    'tekrar',
    'reps',
    'push',
    'pull',
    'leg',
    'bacak',
    'göğüs',
    'sırt',
    'omuz',
    'biceps',
    'triceps',
    'split',
    'antrenman',
    'workout',
    'press',
    'squat',
    'deadlift',
    'curl',
    'row',
  ];

  bool _looksLikeProgram(String content) {
    if (content.length < 80) return false;
    final lower = content.toLowerCase();
    var hits = 0;
    for (final h in _programHints) {
      if (lower.contains(h)) {
        hits++;
        if (hits >= 4) return true;
      }
    }
    return false;
  }

  bool _alreadySavedAsProgram(List<ChatMessage> messages, int index) {
    for (var j = index + 1; j < messages.length; j++) {
      final m = messages[j];
      if (m.role == ChatRole.user) return false;
      if (m.role == ChatRole.tool &&
          (m.toolName == 'createProgram' ||
              m.toolName == 'updateProgram') &&
          m.toolResult?['ok'] == true) {
        return true;
      }
    }
    return false;
  }

  String _extractProgramTitle(String content) {
    final lines = content.split('\n');
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final clean = line
          .replaceAll(RegExp(r'^[#>*\-•\d.\s]+'), '')
          .replaceAll(RegExp('[*_`]'), '')
          .trim();
      if (clean.length < 8) continue;
      var snippet = clean.length > 80 ? clean.substring(0, 80) : clean;
      final colonIdx = snippet.indexOf(':');
      if (colonIdx > 10 && colonIdx < snippet.length - 1) {
        snippet = snippet.substring(0, colonIdx).trim();
      }
      return snippet;
    }
    final flat = content.replaceAll('\n', ' ').trim();
    return flat.length > 60 ? flat.substring(0, 60) : flat;
  }

  /// Imports the program straight from the chat text into Firestore, with no
  /// AI round-trip: the program is already written out above, so we parse it
  /// locally and save it. Zero model calls, and the safety classifier cannot
  /// block it.
  Future<void> _importProgram(ChatMessage message) async {
    if (message.id.isEmpty) return;
    if (_importInFlight.contains(message.id)) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final title = _extractProgramTitle(message.content);
    final program = _parseProgram(message.content, title);
    setState(() => _importInFlight.add(message.id));
    try {
      if (program == null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.chat_errorGeneric)));
        return;
      }
      final id = await ref
          .read(programsRepoProvider)
          .create(uid, program.copyWith(originChatMessageId: message.id));
      if (!mounted) return;
      setState(() => _importedMsgIds.add(message.id));
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(l10n.programs_addedFromChat),
            action: SnackBarAction(
              label: l10n.programs_openInPrograms,
              onPressed: () {
                messenger.hideCurrentSnackBar();
                router.go('/programs/$id');
              },
            ),
          ),
        );
    } catch (e, st) {
      debugPrint('local program import failed: $e\n$st');
      if (mounted) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.chat_errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _importInFlight.remove(message.id));
    }
  }

  /// Best-effort parse of an AI program reply (markdown) into a [Program].
  /// Days come from headings / bold / "Day N" lines, exercises from list rows.
  /// Unrecognized fields fall back to sensible defaults so the user only has to
  /// fine-tune in the editor. Returns null when no exercises are found.
  Program? _parseProgram(String content, String fallbackTitle) {
    final days = <ProgramDay>[];
    var exercises = <Exercise>[];
    String? dayName;

    void flush() {
      if (exercises.isEmpty) return;
      days.add(
        ProgramDay(
          name: (dayName == null || dayName.trim().isEmpty)
              ? 'Day ${days.length + 1}'
              : dayName,
          exercises: List.of(exercises.take(15)),
        ),
      );
      exercises = [];
    }

    for (final raw in content.split('\n')) {
      if (raw.trim().isEmpty) continue;
      final ex = _parseExerciseLine(raw);
      if (ex != null) {
        exercises.add(ex);
        continue;
      }
      final header = _dayHeader(raw);
      if (header != null) {
        flush();
        dayName = header;
      }
    }
    flush();
    if (days.isEmpty) return null;
    return Program(
      id: '',
      title: fallbackTitle.isEmpty ? 'AI Program' : fallbackTitle,
      source: ProgramSource.ai,
      days: List.of(days.take(8)),
    );
  }

  String? _dayHeader(String line) {
    final original = line.trim();
    var s = original.replaceAll(RegExp('[*_`]'), '').trim();
    final heading = RegExp(r'^#{1,6}\s*(.+)$').firstMatch(s);
    if (heading != null) s = heading.group(1)!.trim();
    s = s.replaceAll(RegExp(r':$'), '').trim();
    if (s.isEmpty) return null;
    final isDayWord = RegExp(
      r'^(day|g[üu]n)\b',
      caseSensitive: false,
    ).hasMatch(s);
    final isBold = RegExp(r'^\*\*.+\*\*:?$').hasMatch(original);
    if (heading != null || isBold || isDayWord) {
      return s.length > 50 ? s.substring(0, 50).trim() : s;
    }
    return null;
  }

  Exercise? _parseExerciseLine(String raw) {
    final hadMarker = RegExp(r'^\s*([-*•]|\d+[.)])\s+').hasMatch(raw);
    final s = raw
        .replaceFirst(RegExp(r'^\s*([-*•]|\d+[.)])\s+'), '')
        .replaceAll(RegExp('[*_`#]'), '')
        .trim();
    if (s.isEmpty) return null;

    var sets = 3;
    var reps = '8-12';
    var found = false;

    final sr = RegExp(
      r'(\d+)\s*(?:sets?\s*)?(?:x|×|of)\s*(\d+(?:\s*[-–]\s*\d+)?)',
      caseSensitive: false,
    ).firstMatch(s);
    if (sr != null) {
      sets = int.tryParse(sr.group(1)!) ?? 3;
      reps = sr.group(2)!.replaceAll(RegExp(r'\s+'), '').replaceAll('–', '-');
      found = true;
    } else {
      final setsM = RegExp(
        r'(\d+)\s*sets?\b',
        caseSensitive: false,
      ).firstMatch(s);
      final repsM =
          RegExp(
            r'(\d+(?:\s*[-–]\s*\d+)?)\s*reps?\b',
            caseSensitive: false,
          ).firstMatch(s) ??
          RegExp(
            r'reps?\s*[:=]?\s*(\d+(?:\s*[-–]\s*\d+)?)',
            caseSensitive: false,
          ).firstMatch(s);
      if (setsM != null) {
        sets = int.tryParse(setsM.group(1)!) ?? 3;
        found = true;
      }
      if (repsM != null) {
        reps = repsM.group(1)!.replaceAll(RegExp(r'\s+'), '').replaceAll('–', '-');
        found = true;
      }
    }

    if (!hadMarker && !found) return null;

    var restSec = 90;
    final restM = RegExp(
      r'(\d+)\s*(?:sec|secs|seconds|sn|saniye|s)\b',
      caseSensitive: false,
    ).firstMatch(s);
    if (restM != null) restSec = int.tryParse(restM.group(1)!) ?? 90;

    var name = s;
    final specCut = RegExp(
      r'[\(:,\-]?\s*\d+\s*(?:x|×|sets?|reps?|sec|sn|s\b)',
      caseSensitive: false,
    ).firstMatch(s);
    if (specCut != null && specCut.start > 0) {
      name = s.substring(0, specCut.start);
    }
    name = name.replaceAll(RegExp(r'[\-:–—,(]+\s*$'), '').trim();
    if (name.isEmpty) name = s.trim();
    if (name.length > 70) name = name.substring(0, 70).trim();
    if (name.isEmpty) return null;

    return Exercise(name: name, sets: sets, reps: reps, restSec: restSec);
  }

  Future<void> _send([String? overrideText]) async {
    final text = (overrideText ?? _input.text).trim();
    if (text.isEmpty || _busy || _cooling) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    _autoScroll = true;
    setState(() => _busy = true);
    _input.clear();
    await HapticFeedback.selectionClick();
    Duration? cooldown;
    try {
      cooldown = await ref
          .read(chatControllerProvider)
          .sendUserMessage(uid: uid, text: text, locale: locale, l10n: l10n);
    } finally {
      if (mounted) setState(() => _busy = false);
      _scrollToEnd();
    }
    if (cooldown != null && cooldown.inMilliseconds > 0 && mounted) {
      _startCooldown(cooldown);
    }
  }

  void _startCooldown(Duration cooldown) {
    _cooldownTimer?.cancel();
    setState(() {
      _cooling = true;
      _cooldownSeconds = (cooldown.inMilliseconds / 1000).ceil().clamp(1, 999);
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _cooldownSeconds -= 1;
        if (_cooldownSeconds <= 0) {
          _cooling = false;
          timer.cancel();
        }
      });
    });
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
    final streamingText = ref.watch(streamingReplyProvider) ?? '';
    final hasStreamingBubble = streamingText.isNotEmpty;
    ref.listen<String?>(streamingReplyProvider, (_, next) {
      if (next == null || next.isEmpty || !_autoScroll) return;
      // jumpTo instead of animateTo: deltas arrive every ~30ms and restarting
      // a 200ms scroll animation per delta reads as stutter.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scroll.hasClients) return;
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      });
    });

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
                    final hasNew = messages.length > _lastMsgCount;
                    _lastMsgCount = messages.length;
                    if (hasNew && _autoScroll) _scrollToEnd();
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
                    itemCount: messages.length + (hasStreamingBubble ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == messages.length) {
                        return _MessageBubble(
                          message: ChatMessage(
                            id: '',
                            role: ChatRole.model,
                            content: streamingText,
                          ),
                          showAiAvatar: messages.isEmpty ||
                              messages.last.role != ChatRole.model,
                        );
                      }
                      final m = messages[i];
                      final showAvatar =
                          m.role == ChatRole.model &&
                          (i == 0 || messages[i - 1].role != ChatRole.model);
                      final canImport =
                          m.role == ChatRole.model &&
                          m.id.isNotEmpty &&
                          _looksLikeProgram(m.content) &&
                          !_importedMsgIds.contains(m.id) &&
                          !_alreadySavedAsProgram(messages, i);
                      return _MessageBubble(
                        message: m,
                        showAiAvatar: showAvatar,
                        onImport: canImport
                            ? () => _importProgram(m)
                            : null,
                        importing: _importInFlight.contains(m.id),
                        importDisabled: false,
                      );
                    },
                  );
                },
              ),
            ),
            if (_busy && !hasStreamingBubble)
              _ThinkingIndicator(label: l10n.chat_thinking)
            else if (_cooling)
              _CooldownIndicator(
                message: l10n.chat_errorRateLimited(_cooldownSeconds),
              ),
            _ComposerBar(
              controller: _input,
              busy: _busy || _cooling,
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
  const _MessageBubble({
    required this.message,
    required this.showAiAvatar,
    this.onImport,
    this.importing = false,
    this.importDisabled = false,
  });

  final ChatMessage message;
  final bool showAiAvatar;
  final VoidCallback? onImport;
  final bool importing;
  final bool importDisabled;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                  if (onImport != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: _ImportProgramButton(
                        onPressed: importDisabled || importing
                            ? null
                            : onImport,
                        loading: importing,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportProgramButton extends StatelessWidget {
  const _ImportProgramButton({
    required this.onPressed,
    required this.loading,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final accent = theme.colorScheme.primary;
    final label = loading ? l10n.chat_importingProgram : l10n.chat_importProgram;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: onPressed == null ? 0.06 : 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: accent.withValues(alpha: onPressed == null ? 0.18 : 0.36),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: accent,
                  ),
                )
              else
                Icon(Icons.fitness_center_rounded, size: 16, color: accent),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
    final hasResult = message.toolResult != null;
    final ok = hasResult && message.toolResult!['ok'] == true;
    final summary = _summary(message.toolName ?? '', l10n);
    final sources = _sources(message);
    final accent = !hasResult
        ? theme.colorScheme.outline
        : ok
        ? AppColors.activeRing
        : theme.colorScheme.error;
    final icon = !hasResult
        ? Icons.help_outline_rounded
        : ok
        ? Icons.check_circle_rounded
        : Icons.error_outline_rounded;
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
                Icon(icon, size: 14, color: accent),
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

class _CooldownIndicator extends StatelessWidget {
  const _CooldownIndicator({required this.message});

  final String message;

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
          Icon(
            Icons.hourglass_bottom_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
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
                child: SizedBox(
                  height: 56,
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    textAlignVertical: TextAlignVertical.center,
                    expands: true,
                    minLines: null,
                    maxLines: null,
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
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
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
