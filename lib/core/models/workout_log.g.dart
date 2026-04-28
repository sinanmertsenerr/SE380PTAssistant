// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutLog _$WorkoutLogFromJson(Map<String, dynamic> json) => _WorkoutLog(
  id: json['id'] as String,
  programId: json['programId'] as String,
  dayIndex: (json['dayIndex'] as num).toInt(),
  sets:
      (json['sets'] as List<dynamic>?)
          ?.map((e) => LoggedSet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LoggedSet>[],
  totalVolumeKgReps: (json['totalVolumeKgReps'] as num?)?.toInt() ?? 0,
  startedAt: const TimestampConverter().fromJson(json['startedAt']),
  completedAt: const NullableTimestampConverter().fromJson(json['completedAt']),
);

Map<String, dynamic> _$WorkoutLogToJson(_WorkoutLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'programId': instance.programId,
      'dayIndex': instance.dayIndex,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'totalVolumeKgReps': instance.totalVolumeKgReps,
      'startedAt': const TimestampConverter().toJson(instance.startedAt),
      'completedAt': const NullableTimestampConverter().toJson(
        instance.completedAt,
      ),
    };

_LoggedSet _$LoggedSetFromJson(Map<String, dynamic> json) => _LoggedSet(
  exerciseName: json['exerciseName'] as String,
  reps: (json['reps'] as num).toInt(),
  weightKg: (json['weightKg'] as num).toDouble(),
);

Map<String, dynamic> _$LoggedSetToJson(_LoggedSet instance) =>
    <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'reps': instance.reps,
      'weightKg': instance.weightKg,
    };
