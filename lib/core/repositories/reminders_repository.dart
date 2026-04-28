import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reminder.dart';
import 'firestore_paths.dart';

class RemindersRepository {
  RemindersRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.reminders(uid));

  Stream<List<Reminder>> watchAll(String uid) {
    return _col(uid)
        .orderBy('when')
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => Reminder.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Future<String> create(String uid, Reminder reminder) async {
    final docRef = _col(uid).doc();
    final json =
        reminder.copyWith(id: docRef.id, createdAt: DateTime.now()).toJson()
          ..remove('id');
    await docRef.set(json);
    return docRef.id;
  }

  Future<void> update(String uid, String id, Map<String, dynamic> patch) {
    final clean = Map<String, dynamic>.from(patch)..remove('id');
    return _col(uid).doc(id).set(clean, SetOptions(merge: true));
  }

  Future<void> delete(String uid, String id) => _col(uid).doc(id).delete();
}
