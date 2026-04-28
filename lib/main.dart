import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    await FirebaseBootstrap.initialize();
  } catch (e, st) {
    debugPrint('Firebase init failed (run flutterfire configure): $e\n$st');
  }
  runApp(const ProviderScope(child: PtAssistantApp()));
}
