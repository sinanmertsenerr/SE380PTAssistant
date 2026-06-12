import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/settings_controller.dart';
import 'l10n/app_localizations.dart';

class PtAssistantApp extends ConsumerStatefulWidget {
  const PtAssistantApp({super.key});

  @override
  ConsumerState<PtAssistantApp> createState() => _PtAssistantAppState();
}

class _PtAssistantAppState extends ConsumerState<PtAssistantApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Every time the app comes back to the foreground the inactivity
    // notifications are pushed further into the future, so they only ever
    // fire after the user has actually stayed away.
    if (state == AppLifecycleState.resumed &&
        ref.read(currentUserProvider) != null) {
      ref.read(inactivityNudgeProvider).reschedule(languageCode: _lang);
    }
  }

  String get _lang =>
      ref.read(settingsControllerProvider).locale?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (prev, next) async {
      final user = next.value;
      final nudges = ref.read(inactivityNudgeProvider);
      if (user != null && prev?.value?.uid != user.uid) {
        await ref.read(localNotificationsProvider).requestPermissions();
        await nudges.reschedule(languageCode: _lang);
      } else if (user == null && prev?.value != null) {
        await nudges.cancelAll();
      }
    });

    final router = ref.watch(goRouterProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mapThemeMode(settings.themeMode),
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
