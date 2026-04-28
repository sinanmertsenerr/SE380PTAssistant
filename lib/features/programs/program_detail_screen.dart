import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/exercise.dart';
import '../../core/models/program.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  const ProgramDetailScreen({required this.programId, super.key});

  final String programId;

  @override
  ConsumerState<ProgramDetailScreen> createState() =>
      _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  late final PageController _pageController;
  int _dayIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncProgram = ref.watch(
      _programDetailProvider((uid, widget.programId)),
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            asyncProgram.value?.title ?? '...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: l10n.common_edit,
            onPressed: () => context.go('/programs/${widget.programId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.bolt_rounded),
            tooltip: l10n.programs_setActive,
            onPressed: () =>
                ref.read(programsRepoProvider).setActive(uid, widget.programId),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: l10n.programs_duplicate,
            onPressed: () =>
                ref.read(programsRepoProvider).duplicate(uid, widget.programId),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: l10n.common_delete,
            onPressed: () async {
              await ref
                  .read(programsRepoProvider)
                  .delete(uid, widget.programId);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: asyncProgram.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errors_generic)),
        data: (program) {
          if (!_initialized && program.days.isNotEmpty) {
            _initialized = true;
            _dayIndex = DateTime.now().weekday % program.days.length;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(_dayIndex);
              }
            });
          }
          if (program.days.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Text(
                  l10n.programs_emptyHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          final today = program.days[_dayIndex];
          final estMin = (today.exercises.length * 6).clamp(15, 90);
          return Column(
            children: [
              _DayTabsStrip(
                program: program,
                currentIndex: _dayIndex,
                onSelect: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _dayIndex = i);
                  _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
              _SessionPreview(
                day: today,
                estMin: estMin,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _dayIndex = i),
                  itemCount: program.days.length,
                  itemBuilder: (_, i) => _DayBody(
                    day: program.days[i],
                    onEdit: () {
                      context.go('/programs/${widget.programId}/edit');
                    },
                  ),
                ),
              ),
              _SessionCtaBar(programId: widget.programId),
            ],
          );
        },
      ),
    );
  }
}

final _programDetailProvider = StreamProvider.family
    .autoDispose<Program, (String uid, String id)>((ref, args) async* {
      final repo = ref.watch(programsRepoProvider);
      yield await repo.get(args.$1, args.$2);
    });

class _DayTabsStrip extends StatelessWidget {
  const _DayTabsStrip({
    required this.program,
    required this.currentIndex,
    required this.onSelect,
  });

  final Program program;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: program.days.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, i) {
            final day = program.days[i];
            final selected = i == currentIndex;
            final dayName = day.name.isEmpty
                ? l10n.programs_dayLabel(i + 1)
                : day.name;
            return InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? AppColors.activeRing
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  dayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SessionPreview extends StatelessWidget {
  const _SessionPreview({required this.day, required this.estMin});

  final ProgramDay day;
  final int estMin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          Text(
            l10n.programs_exerciseSets(day.exercises.length),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.programs_estDuration(estMin),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: theme.colorScheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayBody extends StatelessWidget {
  const _DayBody({required this.day, required this.onEdit});

  final ProgramDay day;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      itemCount: day.exercises.length,
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Divider(
          height: 1,
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      itemBuilder: (_, i) {
        final ex = day.exercises[i];
        return _ExerciseRow(ex: ex, index: i, onEdit: onEdit);
      },
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.ex,
    required this.index,
    required this.onEdit,
  });

  final Exercise ex;
  final int index;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ex.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        l10n.programs_setsRepsRestEditorial(ex.sets, ex.reps),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.timer_outlined,
                        size: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        l10n.programs_restMeta(ex.restSec),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  if (ex.notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      ex.notes,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCtaBar extends StatelessWidget {
  const _SessionCtaBar({required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm + 2,
          AppSpacing.lg,
          AppSpacing.sm + 2,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              context.go('/programs/$programId/session');
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: Text(l10n.home_startSession),
          ),
        ),
      ),
    );
  }
}
