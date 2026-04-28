import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/exercise.dart';
import '../../core/models/program.dart';
import '../../core/models/workout_log.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class SessionRunnerScreen extends ConsumerStatefulWidget {
  const SessionRunnerScreen({required this.programId, super.key});

  final String programId;

  @override
  ConsumerState<SessionRunnerScreen> createState() =>
      _SessionRunnerScreenState();
}

class _SessionRunnerScreenState extends ConsumerState<SessionRunnerScreen> {
  bool _loaded = false;
  Program? _program;
  int _dayIdx = 0;
  late DateTime _startedAt;
  final Map<String, List<_SetEntry>> _sets = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
  }

  void _ensureSets(Exercise ex) {
    _sets.putIfAbsent(
      ex.name,
      () => List.generate(ex.sets, (_) => _SetEntry(reps: '', kg: '')),
    );
  }

  Future<void> _finish() async {
    final p = _program;
    final uid = ref.read(currentUidProvider);
    if (p == null || uid == null || _saving) return;
    setState(() => _saving = true);

    final logged = <LoggedSet>[];
    var totalVolume = 0;
    for (final ex in p.days[_dayIdx].exercises) {
      final entries = _sets[ex.name] ?? const [];
      for (final e in entries) {
        final reps = int.tryParse(e.reps);
        final kg = double.tryParse(e.kg);
        if (reps == null || reps <= 0 || kg == null) continue;
        logged.add(
          LoggedSet(exerciseName: ex.name, reps: reps, weightKg: kg),
        );
        totalVolume += (reps * kg).round();
      }
    }

    final log = WorkoutLog(
      id: '',
      programId: widget.programId,
      dayIndex: _dayIdx,
      sets: logged,
      totalVolumeKgReps: totalVolume,
      startedAt: _startedAt,
      completedAt: DateTime.now(),
    );
    await ref.read(workoutsRepoProvider).create(uid, log);
    await HapticFeedback.mediumImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${logged.length} set kaydedildi'),
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncProgram = ref.watch(
      _sessionProgramProvider((uid, widget.programId)),
    );

    return asyncProgram.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text(l10n.errors_generic)),
      ),
      data: (program) {
        if (!_loaded) {
          _loaded = true;
          _program = program;
          if (program.days.isNotEmpty) {
            _dayIdx = DateTime.now().weekday % program.days.length;
          }
        }
        final p = _program ?? program;
        if (p.days.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(p.title)),
            body: Center(child: Text(l10n.programs_emptyHint)),
          );
        }
        final day = p.days[_dayIdx];

        return Scaffold(
          appBar: AppBar(
            title: Text(day.name),
            actions: [
              if (p.days.length > 1)
                PopupMenuButton<int>(
                  icon: const Icon(Icons.swap_vert_rounded),
                  onSelected: (i) => setState(() => _dayIdx = i),
                  itemBuilder: (_) => [
                    for (var i = 0; i < p.days.length; i++)
                      PopupMenuItem(value: i, child: Text(p.days[i].name)),
                  ],
                ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xxl + AppSpacing.xl,
            ),
            itemCount: day.exercises.length,
            itemBuilder: (_, i) {
              final ex = day.exercises[i];
              _ensureSets(ex);
              final entries = _sets[ex.name]!;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.name, style: theme.textTheme.titleMedium),
                    Text(
                      l10n.programs_setsRepsRest(
                        ex.sets,
                        ex.reps,
                        ex.restSec,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (var s = 0; s < entries.length; s++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: Text(
                                '${s + 1}',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.activeRing,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  labelText: 'kg',
                                  isDense: true,
                                ),
                                onChanged: (v) => entries[s].kg = v,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'reps',
                                  isDense: true,
                                ),
                                onChanged: (v) => entries[s].reps = v,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(
                          () => entries.add(_SetEntry(reps: '', kg: '')),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Set ekle'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _saving ? null : _finish,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(l10n.common_finish),
          ),
        );
      },
    );
  }
}

class _SetEntry {
  _SetEntry({required this.reps, required this.kg});
  String reps;
  String kg;
}

final _sessionProgramProvider = FutureProvider.family
    .autoDispose<Program, (String uid, String id)>((ref, args) {
      return ref.watch(programsRepoProvider).get(args.$1, args.$2);
    });
