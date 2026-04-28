import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import 'firestore_paths.dart';

class ChatRepository {
  ChatRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const String defaultChatId = 'main';

  Future<void> ensureDefaultChat(String uid) async {
    await _firestore.doc(FirestorePaths.chat(uid, defaultChatId)).set(
      {
        'title': 'Main',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  CollectionReference<Map<String, dynamic>> _msgCol(
    String uid,
    String chatId,
  ) => _firestore.collection(FirestorePaths.chatMessages(uid, chatId));

  Stream<List<ChatMessage>> watchMessages(
    String uid, {
    String chatId = defaultChatId,
    int limit = 100,
  }) {
    return _msgCol(uid, chatId)
        .orderBy('createdAt')
        .limitToLast(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => ChatMessage.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  Future<List<ChatMessage>> recentMessages(
    String uid, {
    String chatId = defaultChatId,
    int limit = 30,
  }) async {
    final snap = await _msgCol(
      uid,
      chatId,
    ).orderBy('createdAt', descending: true).limit(limit).get();
    return snap.docs.reversed
        .map((d) => ChatMessage.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<String> append(
    String uid,
    ChatMessage message, {
    String chatId = defaultChatId,
  }) async {
    final docRef = _msgCol(uid, chatId).doc();
    final json = message.copyWith(id: docRef.id).toJson()..remove('id');
    json['createdAt'] = FieldValue.serverTimestamp();
    await docRef.set(json);
    return docRef.id;
  }

  Future<void> updateContent(
    String uid,
    String messageId,
    String content, {
    String chatId = defaultChatId,
  }) {
    return _msgCol(
      uid,
      chatId,
    ).doc(messageId).set({'content': content}, SetOptions(merge: true));
  }

  Future<void> clear(String uid, {String chatId = defaultChatId}) async {
    const pageSize = 450;
    final col = _msgCol(uid, chatId);
    while (true) {
      final snap = await col.limit(pageSize).get();
      if (snap.docs.isEmpty) return;
      final batch = _firestore.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
      if (snap.docs.length < pageSize) return;
    }
  }
}
