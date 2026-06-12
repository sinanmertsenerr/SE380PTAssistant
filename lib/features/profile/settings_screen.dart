import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_profile.dart';
import '../../core/providers/providers.dart';
import '../../core/repositories/firestore_paths.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/ui/app_dialogs.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final profile = ref.watch(profileStreamProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_settings)),
      body: ListView(
        children: [
          _Section(title: l10n.profile_appearance),
          ListTile(
            title: Text(l10n.profile_language),
            trailing: DropdownButton<String>(
              value:
                  settings.locale?.languageCode ??
                  Localizations.localeOf(context).languageCode,
              items: [
                DropdownMenuItem(
                  value: 'tr',
                  child: Text(l10n.profile_languageTr),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.profile_languageEn),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                ref
                    .read(settingsControllerProvider.notifier)
                    .setLocale(Locale(v));
              },
            ),
          ),
          ListTile(
            title: Text(l10n.profile_themeMode),
            trailing: DropdownButton<AppThemeMode>(
              value: settings.themeMode,
              items: [
                DropdownMenuItem(
                  value: AppThemeMode.system,
                  child: Text(l10n.profile_themeSystem),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.light,
                  child: Text(l10n.profile_themeLight),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.dark,
                  child: Text(l10n.profile_themeDark),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                ref.read(settingsControllerProvider.notifier).setThemeMode(v);
              },
            ),
          ),
          _Section(title: l10n.profile_notifications),
          SwitchListTile(
            title: Text(l10n.profile_notificationsEnabled),
            value: profile?.notificationsEnabled ?? true,
            onChanged: (v) async {
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              await ref.read(profileRepoProvider).update(uid, {
                'notificationsEnabled': v,
              });
            },
          ),
          _Section(title: l10n.profile_account),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(l10n.auth_signOut),
            onTap: () async {
              await ref.read(authControllerProvider).signOut();
              if (context.mounted) context.go('/auth/sign-in');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: theme.colorScheme.error,
            ),
            title: Text(
              l10n.profile_deleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showAppConfirm(
      context,
      title: l10n.profile_deleteConfirmTitle,
      body: l10n.profile_deleteConfirmBody,
      confirmLabel: l10n.common_delete,
      destructive: true,
    );
    if (!confirm) return;
    final uid = ref.read(currentUidProvider);
    final user = ref.read(currentUserProvider);
    if (uid == null || user == null) return;
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.doc(FirestorePaths.user(uid)).delete().catchError((_) {});
    try {
      await user.delete();
    } on FirebaseAuthException catch (_) {
      await ref.read(authControllerProvider).signOut();
    }
    if (context.mounted) context.go('/auth/sign-in');
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
