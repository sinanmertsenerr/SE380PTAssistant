import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import 'firestore_paths.dart';

class ProfileRepository {
  ProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.doc(FirestorePaths.user(uid));

  Stream<UserProfile> watch(String uid) {
    return _doc(uid).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return UserProfile.empty(uid);
      return UserProfile.fromJson({...data, 'uid': uid});
    });
  }

  Future<UserProfile> get(String uid) async {
    final snap = await _doc(uid).get();
    final data = snap.data();
    if (data == null) return UserProfile.empty(uid);
    return UserProfile.fromJson({...data, 'uid': uid});
  }

  Future<void> create(UserProfile profile) async {
    final now = DateTime.now();
    final json = profile.copyWith(createdAt: now, updatedAt: now).toJson()
      ..remove('uid');
    await _doc(profile.uid).set(json, SetOptions(merge: true));
  }

  Future<void> update(String uid, Map<String, dynamic> patch) async {
    final clean = Map<String, dynamic>.from(patch)..remove('uid');
    clean['updatedAt'] = Timestamp.fromDate(DateTime.now());
    await _doc(uid).set(clean, SetOptions(merge: true));
  }

  Future<void> setOnboardingComplete(String uid) =>
      update(uid, {'onboardingComplete': true});
}
