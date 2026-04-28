// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String? ?? '',
  when: const TimestampConverter().fromJson(json['when']),
  type:
      $enumDecodeNullable(_$ReminderTypeEnumMap, json['type']) ??
      ReminderType.custom,
  rrule: json['rrule'] as String?,
  enabled: json['enabled'] as bool? ?? true,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'when': const TimestampConverter().toJson(instance.when),
  'type': _$ReminderTypeEnumMap[instance.type]!,
  'rrule': instance.rrule,
  'enabled': instance.enabled,
  'createdAt': _$JsonConverterToJson<Object?, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
};

const _$ReminderTypeEnumMap = {
  ReminderType.workout: 'workout',
  ReminderType.weighIn: 'weighIn',
  ReminderType.mobility: 'mobility',
  ReminderType.hydration: 'hydration',
  ReminderType.custom: 'custom',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
