import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/ai/source_lookup_service.dart';
import 'package:ptassistant/core/ai/tool_registry.dart';
import 'package:ptassistant/core/models/note.dart';
import 'package:ptassistant/core/models/user_profile.dart';
import 'package:ptassistant/core/notifications/local_notifications.dart';
import 'package:ptassistant/core/repositories/notes_repository.dart';
import 'package:ptassistant/core/repositories/profile_repository.dart';
import 'package:ptassistant/core/repositories/programs_repository.dart';
import 'package:ptassistant/core/repositories/reminders_repository.dart';

class _FakeSourceLookup implements SourceLookupService {
  @override
  Future<SourceLookupResult> lookup(String query) async => SourceLookupResult(
    summary: 'fake summary for $query',
    sources: const [
      SourceCitation(
        uri: 'https://example.com',
        title: 'Example',
        domain: 'example.com',
      ),
    ],
  );
}

void main() {
  late ToolRegistry registry;
  late ProfileRepository profileRepo;
  late ProgramsRepository programsRepo;
  late NotesRepository notesRepo;

  setUp(() async {
    final firestore = FakeFirebaseFirestore();
    profileRepo = ProfileRepository(firestore);
    programsRepo = ProgramsRepository(firestore);
    notesRepo = NotesRepository(firestore);
    final remindersRepo = RemindersRepository(firestore);
    await profileRepo.create(const UserProfile(uid: 'u1', firstName: 'A'));
    registry = ToolRegistry(
      uid: 'u1',
      profileRepo: profileRepo,
      programsRepo: programsRepo,
      notesRepo: notesRepo,
      remindersRepo: remindersRepo,
      localNotifications: LocalNotificationsService(),
      sourceLookup: _FakeSourceLookup(),
    );
  });

  test('getProfile returns the stored profile', () async {
    final result = await registry.dispatch('getProfile', {});
    expect(result['ok'], true);
    expect((result['profile']! as Map)['firstName'], 'A');
  });

  test('updateProfile patches fields', () async {
    final result = await registry.dispatch('updateProfile', {
      'firstName': 'B',
      'weightKg': 80,
      'goals': ['buildMuscle', 'strength', 'invalid_value'],
    });
    expect(result['ok'], true);
    final profile = await profileRepo.get('u1');
    expect(profile.firstName, 'B');
    expect(profile.weightKg, 80);
    expect(profile.goals.length, 2);
  });

  test('createProgram + setActiveProgram round-trip', () async {
    final create = await registry.dispatch('createProgram', {
      'title': 'PPL',
      'days': [
        {
          'name': 'Push',
          'exercises': [
            {'name': 'Bench', 'sets': 4, 'reps': '6-8', 'restSec': 120},
          ],
        },
      ],
    });
    expect(create['ok'], true);
    final id = create['id']! as String;
    final activate = await registry.dispatch('setActiveProgram', {'id': id});
    expect(activate['ok'], true);

    final active = await programsRepo.getActive('u1');
    expect(active?.id, id);
    expect(active?.title, 'PPL');
    expect(active?.days.first.exercises.first.name, 'Bench');
  });

  test('listNotes returns recent notes filtered by query', () async {
    await notesRepo.create(
      'u1',
      const Note(id: '', title: 'shoulder', body: 'left ache'),
    );
    await notesRepo.create(
      'u1',
      const Note(id: '', title: 'leg day', body: 'squats heavy'),
    );
    final all = await registry.dispatch('listNotes', {});
    expect((all['notes']! as List).length, 2);
    final filtered = await registry.dispatch('listNotes', {
      'query': 'shoulder',
    });
    expect((filtered['notes']! as List).length, 1);
  });

  test('unknown tool returns error', () async {
    final result = await registry.dispatch('nope', {});
    expect(result['ok'], false);
    expect(result['error'], contains('unknown tool'));
  });

  test(
    'lookupSource returns summary + sources from injected service',
    () async {
      final result = await registry.dispatch('lookupSource', {
        'query': 'creatine timing',
      });
      expect(result['ok'], true);
      expect((result['sources']! as List).length, 1);
      expect(result['summary'], contains('creatine timing'));
    },
  );

  test('lookupSource rejects empty query', () async {
    final result = await registry.dispatch('lookupSource', {'query': '  '});
    expect(result['ok'], false);
  });
}
