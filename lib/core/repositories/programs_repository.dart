import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/program.dart';
import 'firestore_paths.dart';

class ProgramsRepository {
  ProgramsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.programs(uid));

  Stream<List<Program>> watchAll(String uid) {
    return _col(uid)
        .orderBy('isActive', descending: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => Program.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Stream<Program?> watchActive(String uid) {
    return _col(uid)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(
          (s) => s.docs.isEmpty
              ? null
              : Program.fromJson({
                  ...s.docs.first.data(),
                  'id': s.docs.first.id,
                }),
        );
  }

  Future<Program?> getActive(String uid) async {
    final snap = await _col(
      uid,
    ).where('isActive', isEqualTo: true).limit(1).get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return Program.fromJson({...doc.data(), 'id': doc.id});
  }

  Future<Program> get(String uid, String id) async {
    final snap = await _col(uid).doc(id).get();
    return Program.fromJson({...snap.data() ?? {}, 'id': id});
  }

  Future<String> create(String uid, Program program) async {
    final now = DateTime.now();
    final docRef = _col(uid).doc();
    final json =
        program.copyWith(id: docRef.id, createdAt: now, updatedAt: now).toJson()
          ..remove('id');
    await docRef.set(json);
    return docRef.id;
  }

  Future<void> update(String uid, String id, Map<String, dynamic> patch) {
    final clean = Map<String, dynamic>.from(patch)..remove('id');
    clean['updatedAt'] = Timestamp.fromDate(DateTime.now());
    return _col(uid).doc(id).set(clean, SetOptions(merge: true));
  }

  Future<void> setActive(String uid, String id) async {
    final batch = _firestore.batch();
    final all = await _col(uid).where('isActive', isEqualTo: true).get();
    for (final doc in all.docs) {
      batch.update(doc.reference, {
        'isActive': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    }
    batch.set(
      _col(uid).doc(id),
      {'isActive': true, 'updatedAt': Timestamp.fromDate(DateTime.now())},
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  Future<void> delete(String uid, String id) => _col(uid).doc(id).delete();

  Future<String> duplicate(String uid, String id) async {
    final original = await get(uid, id);
    final copy = original.copyWith(
      id: '',
      title: '${original.title} (kopya)',
      isActive: false,
    );
    return create(uid, copy);
  }
}
