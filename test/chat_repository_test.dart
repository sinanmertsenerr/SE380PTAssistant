import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/models/chat_message.dart';
import 'package:ptassistant/core/repositories/chat_repository.dart';

void main() {
  group('ChatRepository', () {
    test('append + recentMessages round trip preserves order', () async {
      final firestore = FakeFirebaseFirestore();
      final repo = ChatRepository(firestore);
      await repo.ensureDefaultChat('u1');
      await repo.append(
        'u1',
        const ChatMessage(id: '', role: ChatRole.user, content: 'hi'),
      );
      await repo.append(
        'u1',
        const ChatMessage(id: '', role: ChatRole.model, content: 'hello'),
      );
      final recent = await repo.recentMessages('u1', limit: 10);
      expect(recent.length, 2);
      expect(recent.first.content, 'hi');
      expect(recent.last.content, 'hello');
    });

    test('clear removes every message in a single page', () async {
      final firestore = FakeFirebaseFirestore();
      final repo = ChatRepository(firestore);
      await repo.ensureDefaultChat('u1');
      for (var i = 0; i < 10; i++) {
        await repo.append(
          'u1',
          ChatMessage(id: '', role: ChatRole.user, content: 'msg $i'),
        );
      }
      await repo.clear('u1');
      final after = await repo.recentMessages('u1', limit: 100);
      expect(after, isEmpty);
    });

    test(
      'clear paginates beyond the 500-doc Firestore batch limit',
      () async {
        final firestore = FakeFirebaseFirestore();
        final repo = ChatRepository(firestore);
        await repo.ensureDefaultChat('u1');
        for (var i = 0; i < 1100; i++) {
          await repo.append(
            'u1',
            ChatMessage(id: '', role: ChatRole.user, content: 'm$i'),
          );
        }
        await repo.clear('u1');
        final after = await repo.recentMessages('u1', limit: 2000);
        expect(after, isEmpty);
      },
    );

    test('clear is a no-op on an empty chat', () async {
      final firestore = FakeFirebaseFirestore();
      final repo = ChatRepository(firestore);
      await repo.ensureDefaultChat('u1');
      await repo.clear('u1');
      final after = await repo.recentMessages('u1', limit: 10);
      expect(after, isEmpty);
    });
  });
}
