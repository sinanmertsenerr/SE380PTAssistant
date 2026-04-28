import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/models/workout_log.dart';
import 'package:ptassistant/features/home/home_streak.dart';

void main() {
  WorkoutLog log({required DateTime completedAt}) => WorkoutLog(
    id: 'w-${completedAt.toIso8601String()}',
    programId: 'p',
    dayIndex: 0,
    startedAt: completedAt.subtract(const Duration(hours: 1)),
    completedAt: completedAt,
  );

  test('returns 0 for empty list', () {
    expect(computeStreak(const []), 0);
  });

  test('returns 0 if no workout completed', () {
    final w = WorkoutLog(
      id: 'x',
      programId: 'p',
      dayIndex: 0,
      startedAt: DateTime.now(),
    );
    expect(computeStreak([w]), 0);
  });

  test('counts consecutive days from today', () {
    final today = DateTime.now();
    final logs = [
      log(completedAt: today),
      log(completedAt: today.subtract(const Duration(days: 1))),
      log(completedAt: today.subtract(const Duration(days: 2))),
    ];
    expect(computeStreak(logs), 3);
  });

  test('breaks streak on gap', () {
    final today = DateTime.now();
    final logs = [
      log(completedAt: today),
      log(completedAt: today.subtract(const Duration(days: 3))),
    ];
    expect(computeStreak(logs), 1);
  });
}
