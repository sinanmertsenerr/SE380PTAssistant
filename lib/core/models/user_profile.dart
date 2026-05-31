import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum Sex { male, female }

enum ExperienceLevel { beginner, intermediate, advanced }

enum FitnessGoal { loseFat, buildMuscle, strength, endurance, mobility, health }

enum Equipment { bodyweight, dumbbells, barbell, machines, bands, fullGym }

enum AppThemeMode { system, light, dark }

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    @Default('') String firstName,
    @Default('') String lastName,
    String? photoUrl,
    @NullableTimestampConverter() DateTime? dob,
    @JsonKey(unknownEnumValue: Sex.male) @Default(Sex.male) Sex sex,
    @Default(0) double heightCm,
    @Default(0) double weightKg,
    @Default(<FitnessGoal>[]) List<FitnessGoal> goals,
    @Default(ExperienceLevel.beginner) ExperienceLevel experienceLevel,
    @Default(<String>[]) List<String> injuries,
    @Default(<Equipment>[]) List<Equipment> equipment,
    @Default(3) int weeklySessions,
    @Default('en') String locale,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool onboardingComplete,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.empty(String uid) => UserProfile(uid: uid);
}
