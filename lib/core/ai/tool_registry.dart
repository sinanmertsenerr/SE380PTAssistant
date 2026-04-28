import 'package:firebase_ai/firebase_ai.dart';

import '../models/exercise.dart';
import '../models/note.dart';
import '../models/program.dart';
import '../models/reminder.dart';
import '../models/user_profile.dart';
import '../notifications/local_notifications.dart';
import '../repositories/notes_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/programs_repository.dart';
import '../repositories/reminders_repository.dart';
import 'source_lookup_service.dart';

class ToolRegistry {
  ToolRegistry({
    required this.uid,
    required this.profileRepo,
    required this.programsRepo,
    required this.notesRepo,
    required this.remindersRepo,
    required this.localNotifications,
    SourceLookupService? sourceLookup,
  }) : sourceLookup = sourceLookup ?? GeminiSourceLookupService();

  final String uid;
  final ProfileRepository profileRepo;
  final ProgramsRepository programsRepo;
  final NotesRepository notesRepo;
  final RemindersRepository remindersRepo;
  final LocalNotificationsService localNotifications;
  final SourceLookupService sourceLookup;

  List<Tool> tools() => [Tool.functionDeclarations(_declarations())];

  List<FunctionDeclaration> _declarations() => [
    FunctionDeclaration(
      'getProfile',
      'Read the current user profile. Returns first/last name, goals, equipment, body metrics, injuries, weekly sessions and experience level. Always call before assuming missing details.',
      parameters: {},
    ),
    FunctionDeclaration(
      'updateProfile',
      'Merge-update the user profile with the given fields. Only the fields you pass are written. Valid fields: firstName, lastName, heightCm, weightKg, weeklySessions, experienceLevel (beginner|intermediate|advanced), goals (array of: loseFat, buildMuscle, strength, endurance, mobility, health), equipment (array of: bodyweight, dumbbells, barbell, machines, bands, fullGym), injuries (array of strings).',
      parameters: {
        'firstName': Schema.string(),
        'lastName': Schema.string(),
        'heightCm': Schema.number(),
        'weightKg': Schema.number(),
        'weeklySessions': Schema.integer(),
        'experienceLevel': Schema.string(),
        'goals': Schema.array(items: Schema.string()),
        'equipment': Schema.array(items: Schema.string()),
        'injuries': Schema.array(items: Schema.string()),
      },
    ),
    FunctionDeclaration(
      'listPrograms',
      'List all programs (id, title, isActive, day count) belonging to the user.',
      parameters: {},
    ),
    FunctionDeclaration(
      'getProgram',
      'Read a single program by id, including all days and exercises.',
      parameters: {
        'id': Schema.string(),
      },
    ),
    FunctionDeclaration(
      'createProgram',
      'Create a new training program for the user. days is an array of {name, exercises:[{name, sets, reps, restSec, notes}]}. Returns the new program id.',
      parameters: {
        'title': Schema.string(),
        'days': Schema.array(
          items: Schema.object(
            properties: {
              'name': Schema.string(),
              'exercises': Schema.array(
                items: Schema.object(
                  properties: {
                    'name': Schema.string(),
                    'sets': Schema.integer(),
                    'reps': Schema.string(),
                    'restSec': Schema.integer(),
                    'notes': Schema.string(),
                  },
                  optionalProperties: ['notes', 'restSec'],
                ),
              ),
            },
          ),
        ),
      },
    ),
    FunctionDeclaration(
      'updateProgram',
      'Patch a program: change title and/or replace its days array. Pass only the fields you want to change.',
      parameters: {
        'id': Schema.string(),
        'title': Schema.string(),
        'days': Schema.array(
          items: Schema.object(
            properties: {
              'name': Schema.string(),
              'exercises': Schema.array(
                items: Schema.object(
                  properties: {
                    'name': Schema.string(),
                    'sets': Schema.integer(),
                    'reps': Schema.string(),
                    'restSec': Schema.integer(),
                    'notes': Schema.string(),
                  },
                  optionalProperties: ['notes', 'restSec'],
                ),
              ),
            },
          ),
        ),
      },
      optionalParameters: ['title', 'days'],
    ),
    FunctionDeclaration(
      'setActiveProgram',
      "Mark a program as the user's active program. All other programs become inactive.",
      parameters: {
        'id': Schema.string(),
      },
    ),
    FunctionDeclaration(
      'listNotes',
      "List the user's recent notes, optionally filtered by a search query.",
      parameters: {
        'query': Schema.string(),
        'limit': Schema.integer(),
      },
      optionalParameters: ['query', 'limit'],
    ),
    FunctionDeclaration(
      'getNote',
      'Read a single note by id.',
      parameters: {
        'id': Schema.string(),
      },
    ),
    FunctionDeclaration(
      'createNote',
      'Create a new note. body is markdown. Returns the new note id.',
      parameters: {
        'title': Schema.string(),
        'body': Schema.string(),
        'tags': Schema.array(items: Schema.string()),
      },
      optionalParameters: ['tags'],
    ),
    FunctionDeclaration(
      'updateNote',
      'Patch a note: change title, body or tags. Pass only the fields you want to change.',
      parameters: {
        'id': Schema.string(),
        'title': Schema.string(),
        'body': Schema.string(),
        'tags': Schema.array(items: Schema.string()),
      },
      optionalParameters: ['title', 'body', 'tags'],
    ),
    FunctionDeclaration(
      'appendToNote',
      'Append text to an existing note (with a blank line in between).',
      parameters: {
        'id': Schema.string(),
        'text': Schema.string(),
      },
    ),
    FunctionDeclaration(
      'scheduleReminder',
      "Schedule a local reminder for the user. when is an ISO-8601 timestamp in the user's local timezone.",
      parameters: {
        'title': Schema.string(),
        'body': Schema.string(),
        'when': Schema.string(),
        'type': Schema.string(),
      },
      optionalParameters: ['body', 'type'],
    ),
    FunctionDeclaration(
      'lookupSource',
      'Search the web (via Google Search grounding) for fitness, training, recovery or sports-nutrition information and return a short summary plus citations. Use only when you need a current, evidence-based citation; do not use for casual questions you can answer from training knowledge.',
      parameters: {
        'query': Schema.string(),
      },
    ),
  ];

  Future<Map<String, Object?>> dispatch(
    String name,
    Map<String, Object?> args,
  ) async {
    try {
      switch (name) {
        case 'getProfile':
          final profile = await profileRepo.get(uid);
          return _ok({'profile': profile.toJson()});

        case 'updateProfile':
          await profileRepo.update(uid, _profilePatch(args));
          return _ok({'updated': true});

        case 'listPrograms':
          final list = await programsRepo.watchAll(uid).first;
          return _ok({
            'programs': list
                .map(
                  (p) => {
                    'id': p.id,
                    'title': p.title,
                    'isActive': p.isActive,
                    'dayCount': p.days.length,
                    'source': p.source.name,
                  },
                )
                .toList(),
          });

        case 'getProgram':
          final id = args['id'] as String?;
          if (id == null) return _err('id required');
          final program = await programsRepo.get(uid, id);
          return _ok({'program': program.toJson()});

        case 'createProgram':
          final program = _programFromArgs(args);
          final id = await programsRepo.create(uid, program);
          return _ok({'id': id});

        case 'updateProgram':
          final id = args['id'] as String?;
          if (id == null) return _err('id required');
          await programsRepo.update(uid, id, _programPatch(args));
          return _ok({'updated': true, 'id': id});

        case 'setActiveProgram':
          final id = args['id'] as String?;
          if (id == null) return _err('id required');
          await programsRepo.setActive(uid, id);
          return _ok({'activated': id});

        case 'listNotes':
          final limit = (args['limit'] as num?)?.toInt() ?? 10;
          final notes = await notesRepo.recent(uid, limit: limit);
          final query = (args['query'] as String?)?.toLowerCase();
          final filtered = query == null || query.isEmpty
              ? notes
              : notes
                    .where(
                      (n) =>
                          n.title.toLowerCase().contains(query) ||
                          n.body.toLowerCase().contains(query),
                    )
                    .toList();
          return _ok({
            'notes': filtered
                .map(
                  (n) => {
                    'id': n.id,
                    'title': n.title,
                    'body': n.body.length > 600
                        ? '${n.body.substring(0, 600)}…'
                        : n.body,
                    'tags': n.tags,
                    'pinned': n.pinned,
                  },
                )
                .toList(),
          });

        case 'getNote':
          final id = args['id'] as String?;
          if (id == null) return _err('id required');
          final note = await notesRepo.get(uid, id);
          return _ok({'note': note.toJson()});

        case 'createNote':
          final tags = (args['tags'] as List?)?.cast<String>() ?? const [];
          final id = await notesRepo.create(
            uid,
            Note(
              id: '',
              title: args['title'] as String? ?? '',
              body: args['body'] as String? ?? '',
              tags: tags,
            ),
          );
          return _ok({'id': id});

        case 'updateNote':
          final id = args['id'] as String?;
          if (id == null) return _err('id required');
          final patch = <String, dynamic>{};
          if (args['title'] != null) patch['title'] = args['title'];
          if (args['body'] != null) patch['body'] = args['body'];
          final tagsArg = args['tags'];
          if (tagsArg is List) {
            patch['tags'] = tagsArg.cast<String>();
          }
          await notesRepo.update(uid, id, patch);
          return _ok({'updated': true});

        case 'appendToNote':
          final id = args['id'] as String?;
          final text = args['text'] as String?;
          if (id == null || text == null) return _err('id and text required');
          await notesRepo.append(uid, id, text);
          return _ok({'appended': true});

        case 'lookupSource':
          final query = args['query'] as String?;
          if (query == null || query.trim().isEmpty) {
            return _err('query required');
          }
          final result = await sourceLookup.lookup(query);
          return _ok(result.toMap());

        case 'scheduleReminder':
          final title = args['title'] as String? ?? '';
          final body = args['body'] as String? ?? '';
          final whenStr = args['when'] as String?;
          if (whenStr == null) return _err('when required');
          final when = DateTime.tryParse(whenStr);
          if (when == null) return _err('invalid when (use ISO-8601)');
          final typeName = args['type'] as String? ?? 'custom';
          final type = ReminderType.values.firstWhere(
            (t) => t.name == typeName,
            orElse: () => ReminderType.custom,
          );
          final reminder = Reminder(
            id: '',
            title: title,
            body: body,
            when: when,
            type: type,
          );
          final id = await remindersRepo.create(uid, reminder);
          await localNotifications.schedule(
            id: id.hashCode & 0x7fffffff,
            title: title,
            body: body,
            when: when,
          );
          return _ok({'id': id, 'scheduledFor': when.toIso8601String()});

        default:
          return _err('unknown tool: $name');
      }
    } catch (e) {
      return _err('exception: $e');
    }
  }

  Map<String, Object?> _ok(Map<String, Object?> payload) => {
    'ok': true,
    ...payload,
  };
  Map<String, Object?> _err(String msg) => {'ok': false, 'error': msg};

  Map<String, dynamic> _profilePatch(Map<String, Object?> args) {
    final patch = <String, dynamic>{};
    void copy(String key, [Object? Function(Object?)? transform]) {
      if (args.containsKey(key) && args[key] != null) {
        patch[key] = transform == null ? args[key] : transform(args[key]);
      }
    }

    copy('firstName');
    copy('lastName');
    copy('heightCm');
    copy('weightKg');
    copy('weeklySessions');
    copy('experienceLevel', (v) {
      final s = v as String?;
      return ExperienceLevel.values
          .firstWhere(
            (e) => e.name == s,
            orElse: () => ExperienceLevel.beginner,
          )
          .name;
    });
    copy('goals', (v) {
      final list = (v as List?)?.cast<String>() ?? const [];
      return list
          .where((s) => FitnessGoal.values.any((g) => g.name == s))
          .toList();
    });
    copy('equipment', (v) {
      final list = (v as List?)?.cast<String>() ?? const [];
      return list
          .where((s) => Equipment.values.any((g) => g.name == s))
          .toList();
    });
    copy('injuries', (v) => (v as List?)?.cast<String>() ?? const []);
    return patch;
  }

  Program _programFromArgs(Map<String, Object?> args) {
    final title = args['title'] as String? ?? 'Program';
    final daysJson = (args['days'] as List?) ?? const [];
    final days = daysJson.map((d) {
      final dm = d as Map;
      final ex = (dm['exercises'] as List? ?? const [])
          .map((e) => _exerciseFromMap((e as Map).cast<String, Object?>()))
          .toList();
      return ProgramDay(
        name: dm['name'] as String? ?? '',
        exercises: ex,
      );
    }).toList();
    return Program(
      id: '',
      title: title,
      source: ProgramSource.ai,
      days: days,
    );
  }

  Exercise _exerciseFromMap(Map<String, Object?> m) {
    return Exercise(
      name: m['name'] as String? ?? '',
      sets: (m['sets'] as num?)?.toInt() ?? 3,
      reps: m['reps'] as String? ?? '8-12',
      restSec: (m['restSec'] as num?)?.toInt() ?? 90,
      notes: m['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> _programPatch(Map<String, Object?> args) {
    final patch = <String, dynamic>{};
    if (args['title'] != null) patch['title'] = args['title'];
    final daysArg = args['days'];
    if (daysArg is List) {
      patch['days'] = daysArg.map((d) {
        final dm = d as Map;
        final ex = (dm['exercises'] as List? ?? const [])
            .map((e) => _exerciseFromMap((e as Map).cast<String, Object?>()))
            .map((e) => e.toJson())
            .toList();
        return {'name': dm['name'] ?? '', 'exercises': ex};
      }).toList();
    }
    return patch;
  }
}
