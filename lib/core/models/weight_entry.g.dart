// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  id: json['id'] as String,
  weightKg: (json['weightKg'] as num).toDouble(),
  recordedAt: const TimestampConverter().fromJson(json['recordedAt']),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weightKg': instance.weightKg,
      'recordedAt': const TimestampConverter().toJson(instance.recordedAt),
    };
