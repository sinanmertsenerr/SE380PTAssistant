import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/weight_entry.dart';
import 'firestore_paths.dart';

class WeightsRepository {
  WeightsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.weights(uid));

  Stream<List<WeightEntry>> watchRecent(String uid, {int limit = 30}) {
    return _col(uid)
        .orderBy('recordedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => WeightEntry.fromJson({...d.data(), 'id': d.id}))
              .toList()
              .reversed
              .toList(),
        );
  }

  Future<void> log(String uid, double weightKg) async {
    final docRef = _col(uid).doc();
    await docRef.set({
      'weightKg': weightKg,
      'recordedAt': FieldValue.serverTimestamp(),
    });
  }
}
