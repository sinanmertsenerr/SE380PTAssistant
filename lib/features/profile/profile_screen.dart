import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/user_profile.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/ui/app_dialogs.dart';
import '../../core/utils/labels.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final asyncProfile = ref.watch(profileStreamProvider);
    final profile = asyncProfile.value;

    return Scaffold(
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
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
                      child: Row(
                        children: [
                          Text(
                            l10n.profile_title,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.4,
                              height: 1,
                            ),
                          ),
                          const Spacer(),
                          IconButton.filledTonal(
                            onPressed: () => context.go('/profile/settings'),
                            icon: const Icon(Icons.settings_rounded),
                            tooltip: l10n.profile_settings,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xxl + AppSpacing.xl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _ProfileHero(profile: profile),
                      const SizedBox(height: AppSpacing.lg),
                      _MetricsCard(profile: profile),
                      const SizedBox(height: AppSpacing.md),
                      _GoalsCard(profile: profile),
                      const SizedBox(height: AppSpacing.md),
                      _InjuriesCard(profile: profile),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfileHero extends ConsumerWidget {
  const _ProfileHero({required this.profile});

  final UserProfile profile;

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1024,
    );
    if (picked == null) return;
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );
    if (cropped == null) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final storage = ref.read(firebaseStorageProvider);
    final ref0 = storage.ref().child('users/$uid/avatar.jpg');
    await ref0.putFile(File(cropped.path));
    final url = await ref0.getDownloadURL();
    await ref.read(profileRepoProvider).update(uid, {'photoUrl': url});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final fullName = '${profile.firstName} ${profile.lastName}'.trim();
    final initial = profile.firstName.isEmpty
        ? '?'
        : profile.firstName[0].toUpperCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _pickPhoto(context, ref);
              },
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainerLow,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                    width: 1,
                  ),
                  image: profile.photoUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(profile.photoUrl!),
                          fit: BoxFit.cover,
                        ),
                ),
                alignment: Alignment.center,
                child: profile.photoUrl == null
                    ? Text(
                        initial,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          letterSpacing: -1,
                        ),
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _pickPhoto(context, ref),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: theme.brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.profile_eyebrowAthlete,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          fullName.isEmpty ? '—' : fullName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          experienceLabel(l10n, profile.experienceLevel),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MetricsCard extends ConsumerWidget {
  const _MetricsCard({required this.profile});

  final UserProfile profile;

  Future<void> _editNumber(
    BuildContext context,
    WidgetRef ref,
    String label,
    String field,
    double initial,
  ) async {
    final l10n = AppLocalizations.of(context);
    final raw = await showAppPrompt(
      context,
      title: label,
      initial: initial == 0 ? '' : initial.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      saveLabel: l10n.common_save,
    );
    if (raw == null) return;
    final v = double.tryParse(raw);
    if (v == null) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref.read(profileRepoProvider).update(uid, {field: v});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      eyebrow: l10n.profile_metricsTitle,
      child: Column(
        children: [
          _MetricRow(
            label: l10n.onboarding_height,
            value: profile.heightCm.toStringAsFixed(0),
            unit: l10n.profile_metricCm,
            onTap: () => _editNumber(
              context,
              ref,
              l10n.onboarding_height,
              'heightCm',
              profile.heightCm,
            ),
          ),
          _MetricRow(
            label: l10n.onboarding_weight,
            value: profile.weightKg.toStringAsFixed(1),
            unit: l10n.profile_metricKg,
            onTap: () => _editNumber(
              context,
              ref,
              l10n.onboarding_weight,
              'weightKg',
              profile.weightKg,
            ),
          ),
          _MetricRow(
            label: l10n.onboarding_weeklySessions,
            value: profile.weeklySessions.toString(),
            unit: l10n.profile_metricSessionsPerWeek,
            onTap: () => _editNumber(
              context,
              ref,
              l10n.onboarding_weeklySessions,
              'weeklySessions',
              profile.weeklySessions.toDouble(),
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _GoalsCard extends ConsumerWidget {
  const _GoalsCard({required this.profile});

  final UserProfile profile;

  Future<void> _editGoals(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final selected = {...profile.goals};
    final result = await showModalBottomSheet<Set<FitnessGoal>>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.profile_editGoals,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: FitnessGoal.values.map((g) {
                      final isSel = selected.contains(g);
                      return FilterChip(
                        label: Text(goalLabel(l10n, g)),
                        selected: isSel,
                        onSelected: (v) {
                          setSheetState(() {
                            if (v) {
                              selected.add(g);
                            } else {
                              selected.remove(g);
                            }
                          });
                        },
                        showCheckmark: false,
                        side: BorderSide(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                        selectedColor: Theme.of(
                          ctx,
                        ).colorScheme.primary.withValues(alpha: 0.16),
                        labelStyle: TextStyle(
                          color: isSel
                              ? Theme.of(ctx).colorScheme.primary
                              : Theme.of(ctx).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, selected),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.common_save),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result == null) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref.read(profileRepoProvider).update(uid, {
      'goals': result.map((g) => g.name).toList(),
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionCard(
      eyebrow: l10n.profile_goalsTitle,
      trailing: TextButton.icon(
        onPressed: () => _editGoals(context, ref),
        icon: const Icon(Icons.edit_rounded, size: 16),
        label: Text(l10n.common_edit),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          minimumSize: const Size(0, 28),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
            fontSize: 13,
          ),
        ),
      ),
      child: profile.goals.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l10n.profile_noGoals,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : Wrap(
              spacing: AppSpacing.xs + 2,
              runSpacing: AppSpacing.xs + 2,
              children: profile.goals
                  .map(
                    (g) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm + 2,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                      child: Text(
                        goalLabel(l10n, g),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _InjuriesCard extends ConsumerWidget {
  const _InjuriesCard({required this.profile});

  final UserProfile profile;

  Future<void> _addInjury(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final result = await showAppPrompt(
      context,
      title: l10n.onboarding_injuries,
      hint: l10n.onboarding_injuriesHint,
      saveLabel: l10n.common_save,
    );
    if (result == null) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final next = [...profile.injuries, result];
    await ref.read(profileRepoProvider).update(uid, {'injuries': next});
  }

  Future<void> _removeInjury(WidgetRef ref, String injury) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final next = profile.injuries.where((i) => i != injury).toList();
    await ref.read(profileRepoProvider).update(uid, {'injuries': next});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionCard(
      eyebrow: l10n.profile_injuriesTitle,
      trailing: TextButton.icon(
        onPressed: () => _addInjury(context, ref),
        icon: const Icon(Icons.add_rounded, size: 16),
        label: Text(l10n.profile_addInjury),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          minimumSize: const Size(0, 28),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
            fontSize: 13,
          ),
        ),
      ),
      child: profile.injuries.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l10n.profile_noInjuries,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : Wrap(
              spacing: AppSpacing.xs + 2,
              runSpacing: AppSpacing.xs + 2,
              children: profile.injuries
                  .map(
                    (i) => Material(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull,
                      ),
                      child: InkWell(
                        onTap: () => _removeInjury(ref, i),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.sm + 2,
                            6,
                            AppSpacing.xs,
                            6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  i,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.eyebrow,
    required this.child,
    this.trailing,
  });

  final String eyebrow;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md + 2,
        AppSpacing.md,
        AppSpacing.md + 2,
        AppSpacing.md + 2,
      ),
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
              Expanded(
                child: Text(
                  eyebrow,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.onTap,
    this.isLast = false,
  });

  final String label;
  final String value;
  final String unit;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      unit,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs + 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ],
            ),
            if (!isLast) ...[
              const SizedBox(height: AppSpacing.sm + 2),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: 0.25,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
