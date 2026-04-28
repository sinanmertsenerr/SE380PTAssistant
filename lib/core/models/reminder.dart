import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

enum ReminderType { workout, weighIn, mobility, hydration, custom }

@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String title,
    @Default('') String body,
    @TimestampConverter() required DateTime when,
    @Default(ReminderType.custom) ReminderType type,
    String? rrule,
    @Default(true) bool enabled,
    @TimestampConverter() DateTime? createdAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
