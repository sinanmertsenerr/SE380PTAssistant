import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workout_log.dart';
import 'firestore_paths.dart';

class WorkoutsRepository {
  WorkoutsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.workoutLogs(uid));

  Stream<List<WorkoutLog>> watchRecent(String uid, {int limit = 14}) {
    return _col(uid)
        .orderBy('startedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => WorkoutLog.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Future<String> create(String uid, WorkoutLog log) async {
    final docRef = _col(uid).doc();
    final json = log.copyWith(id: docRef.id).toJson()..remove('id');
    await docRef.set(json);
    return docRef.id;
  }

  Future<void> markCompleted(String uid, String id) => _col(uid).doc(id).set({
    'completedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
