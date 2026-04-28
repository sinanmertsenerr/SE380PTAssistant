// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutLog {

 String get id; String get programId; int get dayIndex; List<LoggedSet> get sets; int get totalVolumeKgReps;@TimestampConverter() DateTime get startedAt;@NullableTimestampConverter() DateTime? get completedAt;
/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLogCopyWith<WorkoutLog> get copyWith => _$WorkoutLogCopyWithImpl<WorkoutLog>(this as WorkoutLog, _$identity);

  /// Serializes this WorkoutLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLog&&(identical(other.id, id) || other.id == id)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&const DeepCollectionEquality().equals(other.sets, sets)&&(identical(other.totalVolumeKgReps, totalVolumeKgReps) || other.totalVolumeKgReps == totalVolumeKgReps)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,programId,dayIndex,const DeepCollectionEquality().hash(sets),totalVolumeKgReps,startedAt,completedAt);

@override
String toString() {
  return 'WorkoutLog(id: $id, programId: $programId, dayIndex: $dayIndex, sets: $sets, totalVolumeKgReps: $totalVolumeKgReps, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $WorkoutLogCopyWith<$Res>  {
  factory $WorkoutLogCopyWith(WorkoutLog value, $Res Function(WorkoutLog) _then) = _$WorkoutLogCopyWithImpl;
@useResult
$Res call({
 String id, String programId, int dayIndex, List<LoggedSet> sets, int totalVolumeKgReps,@TimestampConverter() DateTime startedAt,@NullableTimestampConverter() DateTime? completedAt
});




}
/// @nodoc
class _$WorkoutLogCopyWithImpl<$Res>
    implements $WorkoutLogCopyWith<$Res> {
  _$WorkoutLogCopyWithImpl(this._self, this._then);

  final WorkoutLog _self;
  final $Res Function(WorkoutLog) _then;

/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? programId = null,Object? dayIndex = null,Object? sets = null,Object? totalVolumeKgReps = null,Object? startedAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<LoggedSet>,totalVolumeKgReps: null == totalVolumeKgReps ? _self.totalVolumeKgReps : totalVolumeKgReps // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutLog].
extension WorkoutLogPatterns on WorkoutLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutLog value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutLog value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String programId,  int dayIndex,  List<LoggedSet> sets,  int totalVolumeKgReps, @TimestampConverter()  DateTime startedAt, @NullableTimestampConverter()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
return $default(_that.id,_that.programId,_that.dayIndex,_that.sets,_that.totalVolumeKgReps,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String programId,  int dayIndex,  List<LoggedSet> sets,  int totalVolumeKgReps, @TimestampConverter()  DateTime startedAt, @NullableTimestampConverter()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkoutLog():
return $default(_that.id,_that.programId,_that.dayIndex,_that.sets,_that.totalVolumeKgReps,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String programId,  int dayIndex,  List<LoggedSet> sets,  int totalVolumeKgReps, @TimestampConverter()  DateTime startedAt, @NullableTimestampConverter()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
return $default(_that.id,_that.programId,_that.dayIndex,_that.sets,_that.totalVolumeKgReps,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutLog implements WorkoutLog {
  const _WorkoutLog({required this.id, required this.programId, required this.dayIndex, final  List<LoggedSet> sets = const <LoggedSet>[], this.totalVolumeKgReps = 0, @TimestampConverter() required this.startedAt, @NullableTimestampConverter() this.completedAt}): _sets = sets;
  factory _WorkoutLog.fromJson(Map<String, dynamic> json) => _$WorkoutLogFromJson(json);

@override final  String id;
@override final  String programId;
@override final  int dayIndex;
 final  List<LoggedSet> _sets;
@override@JsonKey() List<LoggedSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@override@JsonKey() final  int totalVolumeKgReps;
@override@TimestampConverter() final  DateTime startedAt;
@override@NullableTimestampConverter() final  DateTime? completedAt;

/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutLogCopyWith<_WorkoutLog> get copyWith => __$WorkoutLogCopyWithImpl<_WorkoutLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutLog&&(identical(other.id, id) || other.id == id)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.totalVolumeKgReps, totalVolumeKgReps) || other.totalVolumeKgReps == totalVolumeKgReps)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,programId,dayIndex,const DeepCollectionEquality().hash(_sets),totalVolumeKgReps,startedAt,completedAt);

@override
String toString() {
  return 'WorkoutLog(id: $id, programId: $programId, dayIndex: $dayIndex, sets: $sets, totalVolumeKgReps: $totalVolumeKgReps, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutLogCopyWith<$Res> implements $WorkoutLogCopyWith<$Res> {
  factory _$WorkoutLogCopyWith(_WorkoutLog value, $Res Function(_WorkoutLog) _then) = __$WorkoutLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String programId, int dayIndex, List<LoggedSet> sets, int totalVolumeKgReps,@TimestampConverter() DateTime startedAt,@NullableTimestampConverter() DateTime? completedAt
});




}
/// @nodoc
class __$WorkoutLogCopyWithImpl<$Res>
    implements _$WorkoutLogCopyWith<$Res> {
  __$WorkoutLogCopyWithImpl(this._self, this._then);

  final _WorkoutLog _self;
  final $Res Function(_WorkoutLog) _then;

/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? programId = null,Object? dayIndex = null,Object? sets = null,Object? totalVolumeKgReps = null,Object? startedAt = null,Object? completedAt = freezed,}) {
  return _then(_WorkoutLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<LoggedSet>,totalVolumeKgReps: null == totalVolumeKgReps ? _self.totalVolumeKgReps : totalVolumeKgReps // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$LoggedSet {

 String get exerciseName; int get reps; double get weightKg;
/// Create a copy of LoggedSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoggedSetCopyWith<LoggedSet> get copyWith => _$LoggedSetCopyWithImpl<LoggedSet>(this as LoggedSet, _$identity);

  /// Serializes this LoggedSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoggedSet&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseName,reps,weightKg);

@override
String toString() {
  return 'LoggedSet(exerciseName: $exerciseName, reps: $reps, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class $LoggedSetCopyWith<$Res>  {
  factory $LoggedSetCopyWith(LoggedSet value, $Res Function(LoggedSet) _then) = _$LoggedSetCopyWithImpl;
@useResult
$Res call({
 String exerciseName, int reps, double weightKg
});




}
/// @nodoc
class _$LoggedSetCopyWithImpl<$Res>
    implements $LoggedSetCopyWith<$Res> {
  _$LoggedSetCopyWithImpl(this._self, this._then);

  final LoggedSet _self;
  final $Res Function(LoggedSet) _then;

/// Create a copy of LoggedSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseName = null,Object? reps = null,Object? weightKg = null,}) {
  return _then(_self.copyWith(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LoggedSet].
extension LoggedSetPatterns on LoggedSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoggedSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoggedSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoggedSet value)  $default,){
final _that = this;
switch (_that) {
case _LoggedSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoggedSet value)?  $default,){
final _that = this;
switch (_that) {
case _LoggedSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseName,  int reps,  double weightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoggedSet() when $default != null:
return $default(_that.exerciseName,_that.reps,_that.weightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseName,  int reps,  double weightKg)  $default,) {final _that = this;
switch (_that) {
case _LoggedSet():
return $default(_that.exerciseName,_that.reps,_that.weightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseName,  int reps,  double weightKg)?  $default,) {final _that = this;
switch (_that) {
case _LoggedSet() when $default != null:
return $default(_that.exerciseName,_that.reps,_that.weightKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoggedSet implements LoggedSet {
  const _LoggedSet({required this.exerciseName, required this.reps, required this.weightKg});
  factory _LoggedSet.fromJson(Map<String, dynamic> json) => _$LoggedSetFromJson(json);

@override final  String exerciseName;
@override final  int reps;
@override final  double weightKg;

/// Create a copy of LoggedSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoggedSetCopyWith<_LoggedSet> get copyWith => __$LoggedSetCopyWithImpl<_LoggedSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoggedSetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoggedSet&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseName,reps,weightKg);

@override
String toString() {
  return 'LoggedSet(exerciseName: $exerciseName, reps: $reps, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class _$LoggedSetCopyWith<$Res> implements $LoggedSetCopyWith<$Res> {
  factory _$LoggedSetCopyWith(_LoggedSet value, $Res Function(_LoggedSet) _then) = __$LoggedSetCopyWithImpl;
@override @useResult
$Res call({
 String exerciseName, int reps, double weightKg
});




}
/// @nodoc
class __$LoggedSetCopyWithImpl<$Res>
    implements _$LoggedSetCopyWith<$Res> {
  __$LoggedSetCopyWithImpl(this._self, this._then);

  final _LoggedSet _self;
  final $Res Function(_LoggedSet) _then;

/// Create a copy of LoggedSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseName = null,Object? reps = null,Object? weightKg = null,}) {
  return _then(_LoggedSet(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
