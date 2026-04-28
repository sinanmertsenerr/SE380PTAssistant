import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/exercise.dart';
import '../../core/models/program.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class ProgramEditorScreen extends ConsumerStatefulWidget {
  const ProgramEditorScreen({required this.programId, super.key});

  final String programId;

  @override
  ConsumerState<ProgramEditorScreen> createState() =>
      _ProgramEditorScreenState();
}

class _ProgramEditorScreenState extends ConsumerState<ProgramEditorScreen> {
  Program? _program;
  bool _loaded = false;
  bool _dirty = false;
  bool _saving = false;
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _titleCtrl.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleCtrl
      ..removeListener(_onTitleChanged)
      ..dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    if (_program == null) return;
    if (_titleCtrl.text != _program!.title) {
      setState(() {
        _program = _program!.copyWith(title: _titleCtrl.text);
        _dirty = true;
      });
    }
  }

  void _addDay() {
    final p = _program;
    if (p == null) return;
    setState(() {
      _program = p.copyWith(
        days: [
          ...p.days,
          ProgramDay(name: 'Day ${p.days.length + 1}'),
        ],
      );
      _dirty = true;
    });
  }

  void _removeDay(int index) {
    final p = _program;
    if (p == null) return;
    setState(() {
      final next = [...p.days]..removeAt(index);
      _program = p.copyWith(days: next);
      _dirty = true;
    });
  }

  Future<void> _renameDay(int index) async {
    final p = _program;
    if (p == null) return;
    final ctrl = TextEditingController(text: p.days[index].name);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    setState(() {
      final next = [...p.days];
      next[index] = next[index].copyWith(name: result);
      _program = p.copyWith(days: next);
      _dirty = true;
    });
  }

  Future<void> _editExercise(int dayIdx, int? exIdx) async {
    final p = _program;
    if (p == null) return;
    final existing = exIdx == null ? null : p.days[dayIdx].exercises[exIdx];
    final result = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ExerciseSheet(initial: existing),
    );
    if (result == null) return;
    setState(() {
      final days = [...p.days];
      final exercises = [...days[dayIdx].exercises];
      if (exIdx == null) {
        exercises.add(result);
      } else {
        exercises[exIdx] = result;
      }
      days[dayIdx] = days[dayIdx].copyWith(exercises: exercises);
      _program = p.copyWith(days: days);
      _dirty = true;
    });
  }

  void _removeExercise(int dayIdx, int exIdx) {
    final p = _program;
    if (p == null) return;
    setState(() {
      final days = [...p.days];
      final exercises = [...days[dayIdx].exercises]..removeAt(exIdx);
      days[dayIdx] = days[dayIdx].copyWith(exercises: exercises);
      _program = p.copyWith(days: days);
      _dirty = true;
    });
  }

  Future<void> _save() async {
    final p = _program;
    final uid = ref.read(currentUidProvider);
    if (p == null || uid == null || _saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(programsRepoProvider).update(uid, widget.programId, {
        'title': p.title,
        'days': p.days.map((d) => d.toJson()).toList(),
      });
      if (mounted) {
        setState(() {
          _dirty = false;
          _saving = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncProgram = ref.watch(
      _programOnceProvider((uid, widget.programId)),
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
          _titleCtrl.text = program.title;
        }
        final p = _program ?? program;

        return PopScope(
          canPop: !_dirty,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop || !_dirty) return;
            final discard = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Unsaved changes'),
                content: const Text('Discard your edits?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.common_cancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.common_dismiss),
                  ),
                ],
              ),
            );
            if (discard == true && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: theme.textTheme.titleLarge,
              ),
              actions: [
                IconButton(
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded),
                  onPressed: !_dirty || _saving ? null : _save,
                  tooltip: l10n.common_save,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _addDay,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add day'),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl + AppSpacing.xl,
              ),
              itemCount: p.days.length,
              itemBuilder: (_, dayIdx) => _DayCard(
                day: p.days[dayIdx],
                onRename: () => _renameDay(dayIdx),
                onRemove: () => _removeDay(dayIdx),
                onEditExercise: (exIdx) => _editExercise(dayIdx, exIdx),
                onAddExercise: () => _editExercise(dayIdx, null),
                onRemoveExercise: (exIdx) => _removeExercise(dayIdx, exIdx),
              ),
            ),
          ),
        );
      },
    );
  }
}

final _programOnceProvider = FutureProvider.family
    .autoDispose<Program, (String uid, String id)>((ref, args) {
      return ref.watch(programsRepoProvider).get(args.$1, args.$2);
    });

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.onRename,
    required this.onRemove,
    required this.onEditExercise,
    required this.onAddExercise,
    required this.onRemoveExercise,
  });

  final ProgramDay day;
  final VoidCallback onRename;
  final VoidCallback onRemove;
  final void Function(int exIdx) onEditExercise;
  final VoidCallback onAddExercise;
  final void Function(int exIdx) onRemoveExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onRename,
                  child: Text(day.name, style: theme.textTheme.titleLarge),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: onRename,
                tooltip: l10n.common_edit,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                onPressed: onRemove,
                tooltip: l10n.common_delete,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < day.exercises.length; i++)
            _ExerciseRow(
              ex: day.exercises[i],
              onTap: () => onEditExercise(i),
              onRemove: () => onRemoveExercise(i),
            ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: onAddExercise,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add exercise'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.ex,
    required this.onTap,
    required this.onRemove,
  });

  final Exercise ex;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.activeRing.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.fitness_center,
                size: 16,
                color: AppColors.activeRing,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ex.name, style: theme.textTheme.titleMedium),
                  Text(
                    l10n.programs_setsRepsRest(ex.sets, ex.reps, ex.restSec),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSheet extends StatefulWidget {
  const _ExerciseSheet({this.initial});

  final Exercise? initial;

  @override
  State<_ExerciseSheet> createState() => _ExerciseSheetState();
}

class _ExerciseSheetState extends State<_ExerciseSheet> {
  late final TextEditingController _name;
  late final TextEditingController _sets;
  late final TextEditingController _reps;
  late final TextEditingController _rest;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _name = TextEditingController(text: i?.name ?? '');
    _sets = TextEditingController(text: (i?.sets ?? 3).toString());
    _reps = TextEditingController(text: i?.reps ?? '8-12');
    _rest = TextEditingController(text: (i?.restSec ?? 90).toString());
    _notes = TextEditingController(text: i?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _sets.dispose();
    _reps.dispose();
    _rest.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            autofocus: widget.initial == null,
            decoration: const InputDecoration(labelText: 'Exercise'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sets,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Sets'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _reps,
                  decoration: const InputDecoration(labelText: 'Reps'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _rest,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Rest (sn)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () {
              final name = _name.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(
                context,
                Exercise(
                  name: name,
                  sets: int.tryParse(_sets.text) ?? 3,
                  reps: _reps.text.trim().isEmpty ? '8-12' : _reps.text.trim(),
                  restSec: int.tryParse(_rest.text) ?? 90,
                  notes: _notes.text.trim(),
                ),
              );
            },
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );
  }
}
