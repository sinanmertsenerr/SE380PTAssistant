import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'workout_log.freezed.dart';
part 'workout_log.g.dart';

@freezed
abstract class WorkoutLog with _$WorkoutLog {
  const factory WorkoutLog({
    required String id,
    required String programId,
    required int dayIndex,
    @Default(<LoggedSet>[]) List<LoggedSet> sets,
    @Default(0) int totalVolumeKgReps,
    @TimestampConverter() required DateTime startedAt,
    @NullableTimestampConverter() DateTime? completedAt,
  }) = _WorkoutLog;

  factory WorkoutLog.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogFromJson(json);
}

@freezed
abstract class LoggedSet with _$LoggedSet {
  const factory LoggedSet({
    required String exerciseName,
    required int reps,
    required double weightKg,
  }) = _LoggedSet;

  factory LoggedSet.fromJson(Map<String, dynamic> json) =>
      _$LoggedSetFromJson(json);
}
