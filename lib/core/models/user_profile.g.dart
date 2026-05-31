// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  photoUrl: json['photoUrl'] as String?,
  dob: const NullableTimestampConverter().fromJson(json['dob']),
  sex:
      $enumDecodeNullable(_$SexEnumMap, json['sex'], unknownValue: Sex.male) ??
      Sex.male,
  heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
  weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
  goals:
      (json['goals'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$FitnessGoalEnumMap, e))
          .toList() ??
      const <FitnessGoal>[],
  experienceLevel:
      $enumDecodeNullable(_$ExperienceLevelEnumMap, json['experienceLevel']) ??
      ExperienceLevel.beginner,
  injuries:
      (json['injuries'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  equipment:
      (json['equipment'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EquipmentEnumMap, e))
          .toList() ??
      const <Equipment>[],
  weeklySessions: (json['weeklySessions'] as num?)?.toInt() ?? 3,
  locale: json['locale'] as String? ?? 'en',
  themeMode:
      $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
      AppThemeMode.system,
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  onboardingComplete: json['onboardingComplete'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserProfileToJson(
  _UserProfile instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'photoUrl': instance.photoUrl,
  'dob': const NullableTimestampConverter().toJson(instance.dob),
  'sex': _$SexEnumMap[instance.sex]!,
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
  'goals': instance.goals.map((e) => _$FitnessGoalEnumMap[e]!).toList(),
  'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
  'injuries': instance.injuries,
  'equipment': instance.equipment.map((e) => _$EquipmentEnumMap[e]!).toList(),
  'weeklySessions': instance.weeklySessions,
  'locale': instance.locale,
  'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
  'notificationsEnabled': instance.notificationsEnabled,
  'onboardingComplete': instance.onboardingComplete,
  'createdAt': _$JsonConverterToJson<Object?, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
  'updatedAt': _$JsonConverterToJson<Object?, DateTime>(
    instance.updatedAt,
    const TimestampConverter().toJson,
  ),
};

const _$SexEnumMap = {Sex.male: 'male', Sex.female: 'female'};

const _$FitnessGoalEnumMap = {
  FitnessGoal.loseFat: 'loseFat',
  FitnessGoal.buildMuscle: 'buildMuscle',
  FitnessGoal.strength: 'strength',
  FitnessGoal.endurance: 'endurance',
  FitnessGoal.mobility: 'mobility',
  FitnessGoal.health: 'health',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};

const _$EquipmentEnumMap = {
  Equipment.bodyweight: 'bodyweight',
  Equipment.dumbbells: 'dumbbells',
  Equipment.barbell: 'barbell',
  Equipment.machines: 'machines',
  Equipment.bands: 'bands',
  Equipment.fullGym: 'fullGym',
};

const _$AppThemeModeEnumMap = {
  AppThemeMode.system: 'system',
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
