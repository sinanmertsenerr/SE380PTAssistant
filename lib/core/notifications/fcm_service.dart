import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../repositories/firestore_paths.dart';

class FcmService {
  FcmService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> initialize(String uid) async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      if (token != null) await _saveToken(uid, token);
      messaging.onTokenRefresh.listen((t) => _saveToken(uid, t));
    } catch (e, st) {
      debugPrint('FCM initialize failed: $e\n$st');
    }
  }

  Future<void> _saveToken(String uid, String token) async {
    await _firestore.collection(FirestorePaths.fcmTokens(uid)).doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
