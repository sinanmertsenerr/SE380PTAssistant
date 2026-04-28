import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ai/ai_service.dart';
import '../ai/daily_nudge_service.dart';
import '../ai/tool_registry.dart';
import '../models/user_profile.dart';
import '../notifications/fcm_service.dart';
import '../notifications/local_notifications.dart';
import '../repositories/chat_repository.dart';
import '../repositories/notes_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/programs_repository.dart';
import '../repositories/reminders_repository.dart';
import '../repositories/weights_repository.dart';
import '../repositories/workouts_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.uid;
});

final profileRepoProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(firebaseFirestoreProvider)),
);
final programsRepoProvider = Provider<ProgramsRepository>(
  (ref) => ProgramsRepository(ref.watch(firebaseFirestoreProvider)),
);
final notesRepoProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.watch(firebaseFirestoreProvider)),
);
final chatRepoProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(firebaseFirestoreProvider)),
);
final remindersRepoProvider = Provider<RemindersRepository>(
  (ref) => RemindersRepository(ref.watch(firebaseFirestoreProvider)),
);
final weightsRepoProvider = Provider<WeightsRepository>(
  (ref) => WeightsRepository(ref.watch(firebaseFirestoreProvider)),
);
final workoutsRepoProvider = Provider<WorkoutsRepository>(
  (ref) => WorkoutsRepository(ref.watch(firebaseFirestoreProvider)),
);

final profileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(profileRepoProvider).watch(uid);
});

final localNotificationsProvider = Provider<LocalNotificationsService>(
  (ref) => LocalNotificationsService(),
);

final fcmServiceProvider = Provider<FcmService>(
  (ref) => FcmService(ref.watch(firebaseFirestoreProvider)),
);

final toolRegistryProvider = Provider.family<ToolRegistry, String>((ref, uid) {
  return ToolRegistry(
    uid: uid,
    profileRepo: ref.watch(profileRepoProvider),
    programsRepo: ref.watch(programsRepoProvider),
    notesRepo: ref.watch(notesRepoProvider),
    remindersRepo: ref.watch(remindersRepoProvider),
    localNotifications: ref.watch(localNotificationsProvider),
  );
});

final aiServiceProvider = Provider.family<AiService, String>((ref, uid) {
  return AiService(toolRegistry: ref.watch(toolRegistryProvider(uid)));
});

final dailyNudgeServiceProvider = Provider.family<DailyNudgeService, String>(
  (ref, uid) => DailyNudgeService(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(aiServiceProvider(uid)),
  ),
);

final dailyNudgeStreamProvider = StreamProvider.family
    .autoDispose<DailyNudge?, String>((ref, uid) {
      return ref.watch(dailyNudgeServiceProvider(uid)).watchToday(uid);
    });
