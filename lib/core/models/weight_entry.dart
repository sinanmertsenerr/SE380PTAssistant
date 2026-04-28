import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'weight_entry.freezed.dart';
part 'weight_entry.g.dart';

@freezed
abstract class WeightEntry with _$WeightEntry {
  const factory WeightEntry({
    required String id,
    required double weightKg,
    @TimestampConverter() required DateTime recordedAt,
  }) = _WeightEntry;

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
}
