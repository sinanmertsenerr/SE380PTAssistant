import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/program.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

enum _ProgramFilter { all, active, ai, manual }

class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen> {
  _ProgramFilter _filter = _ProgramFilter.all;
  String _query = '';

  List<Program> _apply(List<Program> all) {
    Iterable<Program> result = all;
    if (_filter == _ProgramFilter.active) {
      result = result.where((p) => p.isActive);
    } else if (_filter == _ProgramFilter.ai) {
      result = result.where((p) => p.source == ProgramSource.ai);
    } else if (_filter == _ProgramFilter.manual) {
      result = result.where((p) => p.source == ProgramSource.manual);
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result.where((p) => p.title.toLowerCase().contains(q));
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncPrograms = ref.watch(_programsProvider(uid));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createBlank(context, ref, uid),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.programs_createNew),
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        extendedTextStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      body: asyncPrograms.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errors_generic)),
        data: (programs) {
          final filtered = _apply(programs);
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: _Header(
                    total: programs.length,
                    query: _query,
                    onQueryChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  filter: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                  background: theme.colorScheme.surface,
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    title: l10n.programs_empty,
                    hint: l10n.programs_emptyHint,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xxl + AppSpacing.xl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm + 2),
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return _ProgramCard(
                        program: p,
                        onTap: () => context.go('/programs/${p.id}'),
                        onSetActive: () {
                          HapticFeedback.selectionClick();
                          ref.read(programsRepoProvider).setActive(uid, p.id);
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createBlank(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.programs_createNew),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.programs_title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    final id = await ref
        .read(programsRepoProvider)
        .create(
          uid,
          Program(id: '', title: result),
        );
    if (context.mounted) context.go('/programs/$id');
  }
}

final _programsProvider = StreamProvider.family.autoDispose((ref, String uid) {
  return ref.watch(programsRepoProvider).watchAll(uid);
});

class _Header extends StatelessWidget {
  const _Header({
    required this.total,
    required this.query,
    required this.onQueryChanged,
  });

  final int total;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.programs_title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.4,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            total == 0
                ? l10n.programs_empty
                : (total == 1 ? l10n.programs_countOne : l10n.programs_count(total)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.programs_searchHint,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: onQueryChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  _FilterBarDelegate({
    required this.filter,
    required this.onChanged,
    required this.background,
  });

  final _ProgramFilter filter;
  final ValueChanged<_ProgramFilter> onChanged;
  final Color background;

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(_FilterBarDelegate old) =>
      old.filter != filter || old.background != background;

  @override
  Widget build(BuildContext context, double shrink, bool overlaps) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filters = <(_ProgramFilter, String)>[
      (_ProgramFilter.all, l10n.programs_filterAll),
      (_ProgramFilter.active, l10n.programs_filterActive),
      (_ProgramFilter.ai, l10n.programs_filterAi),
      (_ProgramFilter.manual, l10n.programs_filterManual),
    ];
    return ColoredBox(
      color: background,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (_, i) {
          final (f, label) = filters[i];
          final selected = filter == f;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onChanged(f),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            side: BorderSide(
              color: selected
                  ? Colors.transparent
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            backgroundColor: theme.colorScheme.surface,
            selectedColor: theme.colorScheme.primary.withValues(alpha: 0.16),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              letterSpacing: -0.1,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.program,
    required this.onTap,
    required this.onSetActive,
  });

  final Program program;
  final VoidCallback onTap;
  final VoidCallback onSetActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isActive = program.isActive;
    final dayCount = program.days.length;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(
              color: isActive
                  ? AppColors.activeRing.withValues(alpha: 0.55)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.activeRing : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLarge),
                      bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSmall,
                                ),
                              ),
                              child: Text(
                                dayCount == 1
                                    ? l10n.programs_dayBadge(1)
                                    : l10n.programs_dayBadgePlural(dayCount),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              program.source == ProgramSource.ai
                                  ? l10n.programs_sourceAi.toUpperCase()
                                  : l10n.programs_sourceManual.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.activeRing.withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusFull,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.activeRing,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      l10n.programs_active.toUpperCase(),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: AppColors.activeRing,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          program.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isActive)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: IconButton(
                      tooltip: l10n.programs_setActive,
                      onPressed: onSetActive,
                      icon: const Icon(Icons.bolt_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHigh,
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 32,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
