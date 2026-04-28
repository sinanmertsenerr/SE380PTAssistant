import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/program.dart';
import '../../core/models/user_profile.dart';
import '../../core/models/workout_log.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'home_streak.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _nudgeRequested = false;

  Future<void> _maybeRequestDailyNudge(String uid, String locale) async {
    if (_nudgeRequested) return;
    _nudgeRequested = true;
    if (!mounted) return;
    final profile = ref.read(profileStreamProvider).value;
    if (profile == null) return;
    final programsRepo = ref.read(programsRepoProvider);
    final notesRepo = ref.read(notesRepoProvider);
    final nudgeService = ref.read(dailyNudgeServiceProvider(uid));
    try {
      final activeProgram = await programsRepo.getActive(uid);
      final notes = await notesRepo.recent(uid, limit: 10);
      await nudgeService.ensureForToday(
        uid: uid,
        profile: profile,
        activeProgram: activeProgram,
        recentNotes: notes,
        locale: locale,
      );
    } catch (e, st) {
      debugPrint('Daily nudge failed: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    final profileAsync = ref.watch(profileStreamProvider);
    if (uid == null) return const SizedBox.shrink();

    if (profileAsync.value != null) {
      final locale = Localizations.localeOf(context).languageCode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeRequestDailyNudge(uid, locale);
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileStreamProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: _Greeting(profile: profileAsync.value),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _HeroSessionCard(),
                  const SizedBox(height: AppSpacing.lg),
                  const _AiNudgeCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = profile?.firstName.isNotEmpty == true
        ? profile!.firstName
        : '';
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.home_greetingMorning(name)
        : hour < 18
        ? l10n.home_greetingAfternoon(name)
        : l10n.home_greetingEvening(name);
    final uid = ref.watch(currentUidProvider);
    final workouts = uid == null
        ? const <WorkoutLog>[]
        : ref.watch(_workoutsProvider(uid)).value ?? const <WorkoutLog>[];
    final streak = computeStreak(workouts);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: streak > 0
                  ? AppColors.activeRing
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              streak > 0
                  ? l10n.home_streakValue(streak).toUpperCase()
                  : l10n.home_eyebrowReady,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroSessionCard extends ConsumerWidget {
  const _HeroSessionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncActive = ref.watch(_activeProgramProvider(uid));
    final program = asyncActive.value;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.brandAccentDark : AppColors.brandAccent;
    final ink = isDark ? AppColors.heroInkDark : AppColors.heroInkLight;

    final today = program == null || program.days.isEmpty
        ? null
        : program.days[DateTime.now().weekday % program.days.length];
    final dayIndex = program == null || program.days.isEmpty
        ? 0
        : (DateTime.now().weekday % program.days.length) + 1;
    final estMin = today == null
        ? 0
        : (today.exercises.length * 6).clamp(15, 90);

    final base = isDark
        ? AppColors.heroGradientStart
        : AppColors.heroGradientStartLight;

    final activeProgramId = program?.id;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
        onTap: () {
          if (activeProgramId == null) {
            context.go('/chat');
          } else {
            HapticFeedback.selectionClick();
            context.go('/programs/$activeProgramId');
          }
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.32 : 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroEyebrow(accent: accent, ink: ink, program: program),
              const SizedBox(height: AppSpacing.md),
              if (program == null)
                _HeroEmptyTitle(ink: ink, accent: accent)
              else
                _HeroProgramTitle(program: program, today: today, ink: ink),
              if (program != null && today != null) ...[
                const SizedBox(height: AppSpacing.md),
                _HeroMetaRow(
                  dayIndex: dayIndex,
                  totalDays: program.days.length,
                  exerciseCount: today.exercises.length,
                  estMin: estMin,
                  accent: accent,
                  ink: ink,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 1,
                  color: accent.withValues(alpha: 0.18),
                ),
                const SizedBox(height: AppSpacing.md),
                _HeroExerciseList(today: today, accent: accent, ink: ink),
              ],
              const SizedBox(height: AppSpacing.lg),
              _HeroCta(program: program, accent: accent, l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroEyebrow extends StatelessWidget {
  const _HeroEyebrow({
    required this.accent,
    required this.ink,
    required this.program,
  });

  final Color accent;
  final Color ink;
  final Program? program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final eyebrow = program == null
        ? l10n.home_eyebrowReady
        : l10n.home_todaySession.toUpperCase();
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.7),
                blurRadius: 6,
                spreadRadius: 0.5,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          eyebrow,
          style: theme.textTheme.labelSmall?.copyWith(
            color: ink.withValues(alpha: 0.7),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const Spacer(),
        Icon(Icons.bolt_rounded, color: accent, size: 20),
      ],
    );
  }
}

class _HeroEmptyTitle extends StatelessWidget {
  const _HeroEmptyTitle({required this.ink, required this.accent});

  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.home_noActiveProgram,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: ink,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.home_noActiveProgramHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ink.withValues(alpha: 0.65),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _HeroProgramTitle extends StatelessWidget {
  const _HeroProgramTitle({
    required this.program,
    required this.today,
    required this.ink,
  });

  final Program program;
  final ProgramDay? today;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          today?.name ?? program.title,
          style: theme.textTheme.displaySmall?.copyWith(
            color: ink,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            height: 1,
            fontSize: 32,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          program.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ink.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _HeroMetaRow extends StatelessWidget {
  const _HeroMetaRow({
    required this.dayIndex,
    required this.totalDays,
    required this.exerciseCount,
    required this.estMin,
    required this.accent,
    required this.ink,
  });

  final int dayIndex;
  final int totalDays;
  final int exerciseCount;
  final int estMin;
  final Color accent;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final items = [
      _MetaItem(label: l10n.home_dayOf(dayIndex, totalDays)),
      _MetaItem(label: l10n.home_exerciseCount(exerciseCount)),
      _MetaItem(label: l10n.home_estDuration(estMin)),
    ];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: items
          .map(
            (m) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 2,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                m.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MetaItem {
  const _MetaItem({required this.label});
  final String label;
}

class _HeroExerciseList extends StatelessWidget {
  const _HeroExerciseList({
    required this.today,
    required this.accent,
    required this.ink,
  });

  final ProgramDay today;
  final Color accent;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = today.exercises.take(4).toList();
    return Column(
      children: [
        ...visible.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    e.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${e.sets}×${e.reps}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ink.withValues(alpha: 0.7),
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (today.exercises.length > 4)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '+${today.exercises.length - 4}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: ink.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroCta extends StatelessWidget {
  const _HeroCta({
    required this.program,
    required this.accent,
    required this.l10n,
  });

  final Program? program;
  final Color accent;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final p = program;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
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
          if (p == null) {
            context.go('/chat');
          } else {
            HapticFeedback.mediumImpact();
            context.go('/programs/${p.id}/session');
          }
        },
        icon: Icon(
          p == null ? Icons.auto_awesome_rounded : Icons.play_arrow_rounded,
          size: 20,
        ),
        label: Text(p == null ? l10n.home_quickAskAi : l10n.home_startSession),
      ),
    );
  }
}

final _activeProgramProvider = StreamProvider.family.autoDispose((
  ref,
  String uid,
) {
  return ref.watch(programsRepoProvider).watchActive(uid);
});

final _workoutsProvider = StreamProvider.family.autoDispose((ref, String uid) {
  return ref.watch(workoutsRepoProvider).watchRecent(uid);
});

class _AiNudgeCard extends ConsumerWidget {
  const _AiNudgeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final nudge = ref.watch(dailyNudgeStreamProvider(uid)).value;
    final hasText = nudge != null && nudge.text.isNotEmpty && !nudge.dismissed;
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Text(
                  l10n.home_aiNudgeEyebrow,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            hasText ? nudge.text : l10n.home_aiNudgeNoneBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.45,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go('/chat');
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  hasText ? l10n.common_accept : l10n.home_quickAskAi,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: accent.withValues(alpha: 0.16),
                  foregroundColor: accent,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (hasText) ...[
                const SizedBox(width: AppSpacing.xs),
                TextButton(
                  onPressed: () =>
                      ref.read(dailyNudgeServiceProvider(uid)).dismiss(uid),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  child: Text(l10n.common_dismiss),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
