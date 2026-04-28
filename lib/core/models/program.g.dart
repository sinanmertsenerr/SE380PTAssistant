// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramDay _$ProgramDayFromJson(Map<String, dynamic> json) => _ProgramDay(
  name: json['name'] as String,
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Exercise>[],
);

Map<String, dynamic> _$ProgramDayToJson(_ProgramDay instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
    };

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  id: json['id'] as String,
  title: json['title'] as String,
  source:
      $enumDecodeNullable(_$ProgramSourceEnumMap, json['source']) ??
      ProgramSource.manual,
  isActive: json['isActive'] as bool? ?? false,
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => ProgramDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProgramDay>[],
  originChatMessageId: json['originChatMessageId'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'source': _$ProgramSourceEnumMap[instance.source]!,
  'isActive': instance.isActive,
  'days': instance.days.map((e) => e.toJson()).toList(),
  'originChatMessageId': instance.originChatMessageId,
  'createdAt': _$JsonConverterToJson<Object?, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
  'updatedAt': _$JsonConverterToJson<Object?, DateTime>(
    instance.updatedAt,
    const TimestampConverter().toJson,
  ),
};

const _$ProgramSourceEnumMap = {
  ProgramSource.ai: 'ai',
  ProgramSource.manual: 'manual',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
