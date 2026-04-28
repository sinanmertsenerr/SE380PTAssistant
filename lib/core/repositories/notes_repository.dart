import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';
import 'firestore_paths.dart';

class NotesRepository {
  NotesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.notes(uid));

  Stream<List<Note>> watchAll(String uid) {
    return _col(uid)
        .orderBy('pinned', descending: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => Note.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Future<List<Note>> recent(String uid, {int limit = 10}) async {
    final snap = await _col(
      uid,
    ).orderBy('updatedAt', descending: true).limit(limit).get();
    return snap.docs
        .map((d) => Note.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<Note> get(String uid, String id) async {
    final snap = await _col(uid).doc(id).get();
    return Note.fromJson({...snap.data() ?? {}, 'id': id});
  }

  Future<List<Note>> search(String uid, String query) async {
    final lowered = query.toLowerCase();
    final all = await watchAll(uid).first;
    return all
        .where(
          (n) =>
              n.title.toLowerCase().contains(lowered) ||
              n.body.toLowerCase().contains(lowered) ||
              n.tags.any((t) => t.toLowerCase().contains(lowered)),
        )
        .toList();
  }

  Future<String> create(String uid, Note note) async {
    final now = DateTime.now();
    final docRef = _col(uid).doc();
    final json =
        note.copyWith(id: docRef.id, createdAt: now, updatedAt: now).toJson()
          ..remove('id');
    await docRef.set(json);
    return docRef.id;
  }

  Future<void> update(String uid, String id, Map<String, dynamic> patch) {
    final clean = Map<String, dynamic>.from(patch)..remove('id');
    clean['updatedAt'] = Timestamp.fromDate(DateTime.now());
    return _col(uid).doc(id).set(clean, SetOptions(merge: true));
  }

  Future<void> append(String uid, String id, String text) async {
    final note = await get(uid, id);
    final newBody = note.body.isEmpty ? text : '${note.body}\n\n$text';
    await update(uid, id, {'body': newBody});
  }

  Future<void> delete(String uid, String id) => _col(uid).doc(id).delete();
}
