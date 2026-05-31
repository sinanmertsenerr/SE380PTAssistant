import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_profile.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _pageController = PageController();
  int _step = 0;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _heightCm = TextEditingController();
  final _weightKg = TextEditingController();
  final _injuries = TextEditingController();

  DateTime? _dob;
  Sex _sex = Sex.male;
  ExperienceLevel _experience = ExperienceLevel.beginner;
  final Set<FitnessGoal> _goals = {};
  final Set<Equipment> _equipment = {};
  int _weeklySessions = 3;
  bool _busy = false;

  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _heightCm.dispose();
    _weightKg.dispose();
    _injuries.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step == 1 && !_validateMetrics()) return;
    if (_step < 2) {
      setState(() => _step += 1);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      await _finish();
    }
  }

  bool _validateMetrics() {
    final l10n = AppLocalizations.of(context);
    final height = double.tryParse(_heightCm.text.trim().replaceAll(',', '.'));
    final weight = double.tryParse(_weightKg.text.trim().replaceAll(',', '.'));
    if (height == null || height < 80 || height > 250) {
      _showMetricError('${l10n.onboarding_height} • 80–250 cm');
      return false;
    }
    if (weight == null || weight < 25 || weight > 350) {
      _showMetricError('${l10n.onboarding_weight} • 25–350 kg');
      return false;
    }
    return true;
  }

  void _showMetricError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _back() async {
    if (_step == 0) return;
    setState(() => _step -= 1);
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final injuries = _injuries.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final patch = {
      'firstName': _firstName.text.trim(),
      'lastName': _lastName.text.trim(),
      'dob': _dob,
      'sex': _sex.name,
      'heightCm': double.tryParse(_heightCm.text.trim().replaceAll(',', '.')) ?? 0,
      'weightKg': double.tryParse(_weightKg.text.trim().replaceAll(',', '.')) ?? 0,
      'experienceLevel': _experience.name,
      'goals': _goals.map((g) => g.name).toList(),
      'equipment': _equipment.map((e) => e.name).toList(),
      'injuries': injuries,
      'weeklySessions': _weeklySessions,
      'onboardingComplete': true,
    };
    try {
      await ref.read(profileRepoProvider).update(uid, patch);
    } catch (e, st) {
      debugPrint('onboarding finish failed: $e\n$st');
      if (mounted) {
        setState(() => _busy = false);
        messenger.showSnackBar(SnackBar(content: Text(l10n.errors_generic)));
      }
      return;
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: _step == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _back,
              ),
        title: Text(l10n.onboarding_title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: LinearProgressIndicator(
                value: (_step + 1) / 3,
                minHeight: 6,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(l10n),
                  _buildStep2(l10n),
                  _buildStep3(l10n),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                onPressed: _busy ? null : _next,
                child: _busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _step == 2 ? l10n.onboarding_finish : l10n.common_next,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onboarding_step1Title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _firstName,
            decoration: InputDecoration(labelText: l10n.onboarding_firstName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _lastName,
            decoration: InputDecoration(labelText: l10n.onboarding_lastName),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dob ?? DateTime(2000, 1, 1),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dob = picked);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            child: InputDecorator(
              decoration: InputDecoration(labelText: l10n.onboarding_dob),
              child: Text(
                _dob == null ? '—' : _dob!.toIso8601String().split('T').first,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.onboarding_sex, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: Sex.values.map((s) {
              final selected = _sex == s;
              return ChoiceChip(
                label: Text(_sexLabel(l10n, s)),
                selected: selected,
                onSelected: (_) => setState(() => _sex = s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onboarding_step2Title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _heightCm,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.onboarding_height),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _weightKg,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.onboarding_weight),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.onboarding_experience, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: ExperienceLevel.values.map((e) {
              return ChoiceChip(
                label: Text(_expLabel(l10n, e)),
                selected: _experience == e,
                onSelected: (_) => setState(() => _experience = e),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.onboarding_weeklySessions,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Slider(
            value: _weeklySessions.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_weeklySessions',
            onChanged: (v) => setState(() => _weeklySessions = v.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onboarding_step3Title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.onboarding_goals, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: FitnessGoal.values.map((g) {
              return FilterChip(
                label: Text(_goalLabel(l10n, g)),
                selected: _goals.contains(g),
                onSelected: (sel) => setState(() {
                  sel ? _goals.add(g) : _goals.remove(g);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.onboarding_equipment, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: Equipment.values.map((e) {
              return FilterChip(
                label: Text(_equipLabel(l10n, e)),
                selected: _equipment.contains(e),
                onSelected: (sel) => setState(() {
                  sel ? _equipment.add(e) : _equipment.remove(e);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _injuries,
            decoration: InputDecoration(
              labelText: l10n.onboarding_injuries,
              hintText: l10n.onboarding_injuriesHint,
            ),
          ),
        ],
      ),
    );
  }

  String _sexLabel(AppLocalizations l, Sex s) => switch (s) {
    Sex.male => l.onboarding_sexMale,
    Sex.female => l.onboarding_sexFemale,
  };

  String _expLabel(AppLocalizations l, ExperienceLevel e) => switch (e) {
    ExperienceLevel.beginner => l.onboarding_expBeginner,
    ExperienceLevel.intermediate => l.onboarding_expIntermediate,
    ExperienceLevel.advanced => l.onboarding_expAdvanced,
  };

  String _goalLabel(AppLocalizations l, FitnessGoal g) => switch (g) {
    FitnessGoal.loseFat => l.onboarding_goalLoseFat,
    FitnessGoal.buildMuscle => l.onboarding_goalBuildMuscle,
    FitnessGoal.strength => l.onboarding_goalStrength,
    FitnessGoal.endurance => l.onboarding_goalEndurance,
    FitnessGoal.mobility => l.onboarding_goalMobility,
    FitnessGoal.health => l.onboarding_goalHealth,
  };

  String _equipLabel(AppLocalizations l, Equipment e) => switch (e) {
    Equipment.bodyweight => l.onboarding_equipmentNone,
    Equipment.dumbbells => l.onboarding_equipmentDumbbells,
    Equipment.barbell => l.onboarding_equipmentBarbell,
    Equipment.machines => l.onboarding_equipmentMachines,
    Equipment.bands => l.onboarding_equipmentBands,
    Equipment.fullGym => l.onboarding_equipmentGym,
  };
}
