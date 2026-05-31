// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get firstName; String get lastName; String? get photoUrl;@NullableTimestampConverter() DateTime? get dob;@JsonKey(unknownEnumValue: Sex.male) Sex get sex; double get heightCm; double get weightKg; List<FitnessGoal> get goals; ExperienceLevel get experienceLevel; List<String> get injuries; List<Equipment> get equipment; int get weeklySessions; String get locale; AppThemeMode get themeMode; bool get notificationsEnabled; bool get onboardingComplete;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&const DeepCollectionEquality().equals(other.goals, goals)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel)&&const DeepCollectionEquality().equals(other.injuries, injuries)&&const DeepCollectionEquality().equals(other.equipment, equipment)&&(identical(other.weeklySessions, weeklySessions) || other.weeklySessions == weeklySessions)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,firstName,lastName,photoUrl,dob,sex,heightCm,weightKg,const DeepCollectionEquality().hash(goals),experienceLevel,const DeepCollectionEquality().hash(injuries),const DeepCollectionEquality().hash(equipment),weeklySessions,locale,themeMode,notificationsEnabled,onboardingComplete,createdAt,updatedAt]);

@override
String toString() {
  return 'UserProfile(uid: $uid, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, dob: $dob, sex: $sex, heightCm: $heightCm, weightKg: $weightKg, goals: $goals, experienceLevel: $experienceLevel, injuries: $injuries, equipment: $equipment, weeklySessions: $weeklySessions, locale: $locale, themeMode: $themeMode, notificationsEnabled: $notificationsEnabled, onboardingComplete: $onboardingComplete, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String firstName, String lastName, String? photoUrl,@NullableTimestampConverter() DateTime? dob,@JsonKey(unknownEnumValue: Sex.male) Sex sex, double heightCm, double weightKg, List<FitnessGoal> goals, ExperienceLevel experienceLevel, List<String> injuries, List<Equipment> equipment, int weeklySessions, String locale, AppThemeMode themeMode, bool notificationsEnabled, bool onboardingComplete,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? dob = freezed,Object? sex = null,Object? heightCm = null,Object? weightKg = null,Object? goals = null,Object? experienceLevel = null,Object? injuries = null,Object? equipment = null,Object? weeklySessions = null,Object? locale = null,Object? themeMode = null,Object? notificationsEnabled = null,Object? onboardingComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<FitnessGoal>,experienceLevel: null == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as ExperienceLevel,injuries: null == injuries ? _self.injuries : injuries // ignore: cast_nullable_to_non_nullable
as List<String>,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<Equipment>,weeklySessions: null == weeklySessions ? _self.weeklySessions : weeklySessions // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String firstName,  String lastName,  String? photoUrl, @NullableTimestampConverter()  DateTime? dob, @JsonKey(unknownEnumValue: Sex.male)  Sex sex,  double heightCm,  double weightKg,  List<FitnessGoal> goals,  ExperienceLevel experienceLevel,  List<String> injuries,  List<Equipment> equipment,  int weeklySessions,  String locale,  AppThemeMode themeMode,  bool notificationsEnabled,  bool onboardingComplete, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.firstName,_that.lastName,_that.photoUrl,_that.dob,_that.sex,_that.heightCm,_that.weightKg,_that.goals,_that.experienceLevel,_that.injuries,_that.equipment,_that.weeklySessions,_that.locale,_that.themeMode,_that.notificationsEnabled,_that.onboardingComplete,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String firstName,  String lastName,  String? photoUrl, @NullableTimestampConverter()  DateTime? dob, @JsonKey(unknownEnumValue: Sex.male)  Sex sex,  double heightCm,  double weightKg,  List<FitnessGoal> goals,  ExperienceLevel experienceLevel,  List<String> injuries,  List<Equipment> equipment,  int weeklySessions,  String locale,  AppThemeMode themeMode,  bool notificationsEnabled,  bool onboardingComplete, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.firstName,_that.lastName,_that.photoUrl,_that.dob,_that.sex,_that.heightCm,_that.weightKg,_that.goals,_that.experienceLevel,_that.injuries,_that.equipment,_that.weeklySessions,_that.locale,_that.themeMode,_that.notificationsEnabled,_that.onboardingComplete,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String firstName,  String lastName,  String? photoUrl, @NullableTimestampConverter()  DateTime? dob, @JsonKey(unknownEnumValue: Sex.male)  Sex sex,  double heightCm,  double weightKg,  List<FitnessGoal> goals,  ExperienceLevel experienceLevel,  List<String> injuries,  List<Equipment> equipment,  int weeklySessions,  String locale,  AppThemeMode themeMode,  bool notificationsEnabled,  bool onboardingComplete, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.firstName,_that.lastName,_that.photoUrl,_that.dob,_that.sex,_that.heightCm,_that.weightKg,_that.goals,_that.experienceLevel,_that.injuries,_that.equipment,_that.weeklySessions,_that.locale,_that.themeMode,_that.notificationsEnabled,_that.onboardingComplete,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.uid, this.firstName = '', this.lastName = '', this.photoUrl, @NullableTimestampConverter() this.dob, @JsonKey(unknownEnumValue: Sex.male) this.sex = Sex.male, this.heightCm = 0, this.weightKg = 0, final  List<FitnessGoal> goals = const <FitnessGoal>[], this.experienceLevel = ExperienceLevel.beginner, final  List<String> injuries = const <String>[], final  List<Equipment> equipment = const <Equipment>[], this.weeklySessions = 3, this.locale = 'en', this.themeMode = AppThemeMode.system, this.notificationsEnabled = true, this.onboardingComplete = false, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt}): _goals = goals,_injuries = injuries,_equipment = equipment;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override final  String? photoUrl;
@override@NullableTimestampConverter() final  DateTime? dob;
@override@JsonKey(unknownEnumValue: Sex.male) final  Sex sex;
@override@JsonKey() final  double heightCm;
@override@JsonKey() final  double weightKg;
 final  List<FitnessGoal> _goals;
@override@JsonKey() List<FitnessGoal> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}

@override@JsonKey() final  ExperienceLevel experienceLevel;
 final  List<String> _injuries;
@override@JsonKey() List<String> get injuries {
  if (_injuries is EqualUnmodifiableListView) return _injuries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_injuries);
}

 final  List<Equipment> _equipment;
@override@JsonKey() List<Equipment> get equipment {
  if (_equipment is EqualUnmodifiableListView) return _equipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipment);
}

@override@JsonKey() final  int weeklySessions;
@override@JsonKey() final  String locale;
@override@JsonKey() final  AppThemeMode themeMode;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool onboardingComplete;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&const DeepCollectionEquality().equals(other._goals, _goals)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel)&&const DeepCollectionEquality().equals(other._injuries, _injuries)&&const DeepCollectionEquality().equals(other._equipment, _equipment)&&(identical(other.weeklySessions, weeklySessions) || other.weeklySessions == weeklySessions)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,firstName,lastName,photoUrl,dob,sex,heightCm,weightKg,const DeepCollectionEquality().hash(_goals),experienceLevel,const DeepCollectionEquality().hash(_injuries),const DeepCollectionEquality().hash(_equipment),weeklySessions,locale,themeMode,notificationsEnabled,onboardingComplete,createdAt,updatedAt]);

@override
String toString() {
  return 'UserProfile(uid: $uid, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, dob: $dob, sex: $sex, heightCm: $heightCm, weightKg: $weightKg, goals: $goals, experienceLevel: $experienceLevel, injuries: $injuries, equipment: $equipment, weeklySessions: $weeklySessions, locale: $locale, themeMode: $themeMode, notificationsEnabled: $notificationsEnabled, onboardingComplete: $onboardingComplete, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String firstName, String lastName, String? photoUrl,@NullableTimestampConverter() DateTime? dob,@JsonKey(unknownEnumValue: Sex.male) Sex sex, double heightCm, double weightKg, List<FitnessGoal> goals, ExperienceLevel experienceLevel, List<String> injuries, List<Equipment> equipment, int weeklySessions, String locale, AppThemeMode themeMode, bool notificationsEnabled, bool onboardingComplete,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? firstName = null,Object? lastName = null,Object? photoUrl = freezed,Object? dob = freezed,Object? sex = null,Object? heightCm = null,Object? weightKg = null,Object? goals = null,Object? experienceLevel = null,Object? injuries = null,Object? equipment = null,Object? weeklySessions = null,Object? locale = null,Object? themeMode = null,Object? notificationsEnabled = null,Object? onboardingComplete = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<FitnessGoal>,experienceLevel: null == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as ExperienceLevel,injuries: null == injuries ? _self._injuries : injuries // ignore: cast_nullable_to_non_nullable
as List<String>,equipment: null == equipment ? _self._equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<Equipment>,weeklySessions: null == weeklySessions ? _self.weeklySessions : weeklySessions // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
