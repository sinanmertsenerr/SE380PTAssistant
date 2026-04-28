import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/user_profile.dart';
import '../../core/providers/providers.dart';

const _localeKey = 'app.locale';
const _themeKey = 'app.themeMode';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.locale,
  });

  final AppThemeMode themeMode;
  final Locale? locale;

  SettingsState copyWith({AppThemeMode? themeMode, Locale? locale}) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _hydrate();
    ref.listen(profileStreamProvider, (_, next) {
      final p = next.value;
      if (p == null) return;
      _maybeUpdateFromProfile(p);
    });
    return const SettingsState(
      themeMode: AppThemeMode.system,
      locale: null,
    );
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey);
    final loc = prefs.getString(_localeKey);
    state = state.copyWith(
      themeMode: theme == null
          ? AppThemeMode.system
          : AppThemeMode.values.firstWhere(
              (t) => t.name == theme,
              orElse: () => AppThemeMode.system,
            ),
      locale: loc == null ? null : Locale(loc),
    );
  }

  void _maybeUpdateFromProfile(UserProfile p) {
    state = state.copyWith(
      themeMode: p.themeMode,
      locale: Locale(p.locale.isEmpty ? 'en' : p.locale),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    final uid = ref.read(currentUidProvider);
    if (uid != null) {
      await ref.read(profileRepoProvider).update(uid, {'themeMode': mode.name});
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    final uid = ref.read(currentUidProvider);
    if (uid != null) {
      await ref.read(profileRepoProvider).update(uid, {
        'locale': locale.languageCode,
      });
    }
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(
      SettingsController.new,
    );

ThemeMode mapThemeMode(AppThemeMode mode) => switch (mode) {
  AppThemeMode.system => ThemeMode.system,
  AppThemeMode.light => ThemeMode.light,
  AppThemeMode.dark => ThemeMode.dark,
};
