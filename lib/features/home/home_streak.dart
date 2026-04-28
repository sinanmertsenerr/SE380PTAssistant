import '../../core/models/workout_log.dart';

int computeStreak(List<WorkoutLog> workouts) {
  if (workouts.isEmpty) return 0;
  final completed = workouts.where((w) => w.completedAt != null).toList()
    ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
  if (completed.isEmpty) return 0;

  var streak = 0;
  var cursor = DateTime.now();
  cursor = DateTime(cursor.year, cursor.month, cursor.day);
  for (final w in completed) {
    final ts = w.completedAt!;
    final day = DateTime(ts.year, ts.month, ts.day);
    final diff = cursor.difference(day).inDays;
    if (diff == 0) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    } else if (diff == 1) {
      streak += 1;
      cursor = day.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
}
