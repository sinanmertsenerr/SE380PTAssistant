import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../models/program.dart';
import '../models/user_profile.dart';
import '../repositories/firestore_paths.dart';
import 'ai_service.dart';

class DailyNudge {
  const DailyNudge({
    required this.dateKey,
    required this.text,
    required this.createdAt,
    required this.dismissed,
  });

  final String dateKey;
  final String text;
  final DateTime createdAt;
  final bool dismissed;

  Map<String, Object?> toMap() => {
    'dateKey': dateKey,
    'text': text,
    'createdAt': Timestamp.fromDate(createdAt),
    'dismissed': dismissed,
  };

  static DailyNudge? fromMap(Map<String, Object?>? m) {
    if (m == null) return null;
    final ts = m['createdAt'];
    return DailyNudge(
      dateKey: m['dateKey'] as String? ?? '',
      text: m['text'] as String? ?? '',
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
      dismissed: m['dismissed'] as bool? ?? false,
    );
  }
}

class DailyNudgeService {
  DailyNudgeService(this._firestore, this._aiService);

  final FirebaseFirestore _firestore;
  final AiService _aiService;

  static String dateKey(DateTime now) =>
      DateFormat('yyyyMMdd').format(now.toLocal());

  Stream<DailyNudge?> watchToday(String uid) {
    final key = dateKey(DateTime.now());
    return _firestore
        .doc('${FirestorePaths.nudges(uid)}/$key')
        .snapshots()
        .map(
          (snap) => snap.exists ? DailyNudge.fromMap(snap.data()) : null,
        );
  }

  Future<void> ensureForToday({
    required String uid,
    required UserProfile profile,
    required Program? activeProgram,
    required List<Note> recentNotes,
    required String locale,
  }) async {
    final key = dateKey(DateTime.now());
    final docRef = _firestore.doc('${FirestorePaths.nudges(uid)}/$key');
    final existing = await docRef.get();
    if (existing.exists) return;
    try {
      final text = await _aiService.generateDailyNudge(
        AiContext(
          profile: profile,
          activeProgram: activeProgram,
          recentNotes: recentNotes,
          locale: locale,
        ),
      );
      if (text.isEmpty) return;
      final nudge = DailyNudge(
        dateKey: key,
        text: text,
        createdAt: DateTime.now(),
        dismissed: false,
      );
      await docRef.set(nudge.toMap());
    } catch (e, st) {
      debugPrint('Daily nudge ensure failed: $e\n$st');
    }
  }

  Future<void> dismiss(String uid) async {
    final key = dateKey(DateTime.now());
    await _firestore.doc('${FirestorePaths.nudges(uid)}/$key').set({
      'dismissed': true,
    }, SetOptions(merge: true));
  }
}
