import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise.dart';
import 'timestamp_converter.dart';

part 'program.freezed.dart';
part 'program.g.dart';

enum ProgramSource { ai, manual }

@freezed
abstract class ProgramDay with _$ProgramDay {
  const factory ProgramDay({
    required String name,
    @Default(<Exercise>[]) List<Exercise> exercises,
  }) = _ProgramDay;

  factory ProgramDay.fromJson(Map<String, dynamic> json) =>
      _$ProgramDayFromJson(json);
}

@freezed
abstract class Program with _$Program {
  const factory Program({
    required String id,
    required String title,
    @Default(ProgramSource.manual) ProgramSource source,
    @Default(false) bool isActive,
    @Default(<ProgramDay>[]) List<ProgramDay> days,
    String? originChatMessageId,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}
