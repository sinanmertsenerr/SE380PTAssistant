// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {

 String get id; ChatRole get role; String get content; String? get toolName; Map<String, dynamic>? get toolArgs; Map<String, dynamic>? get toolResult; List<String> get attachedNoteIds; List<String> get attachedProgramIds;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other.toolArgs, toolArgs)&&const DeepCollectionEquality().equals(other.toolResult, toolResult)&&const DeepCollectionEquality().equals(other.attachedNoteIds, attachedNoteIds)&&const DeepCollectionEquality().equals(other.attachedProgramIds, attachedProgramIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,toolName,const DeepCollectionEquality().hash(toolArgs),const DeepCollectionEquality().hash(toolResult),const DeepCollectionEquality().hash(attachedNoteIds),const DeepCollectionEquality().hash(attachedProgramIds),createdAt);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, toolName: $toolName, toolArgs: $toolArgs, toolResult: $toolResult, attachedNoteIds: $attachedNoteIds, attachedProgramIds: $attachedProgramIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, ChatRole role, String content, String? toolName, Map<String, dynamic>? toolArgs, Map<String, dynamic>? toolResult, List<String> attachedNoteIds, List<String> attachedProgramIds,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? toolName = freezed,Object? toolArgs = freezed,Object? toolResult = freezed,Object? attachedNoteIds = null,Object? attachedProgramIds = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolArgs: freezed == toolArgs ? _self.toolArgs : toolArgs // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolResult: freezed == toolResult ? _self.toolResult : toolResult // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,attachedNoteIds: null == attachedNoteIds ? _self.attachedNoteIds : attachedNoteIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachedProgramIds: null == attachedProgramIds ? _self.attachedProgramIds : attachedProgramIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String content,  String? toolName,  Map<String, dynamic>? toolArgs,  Map<String, dynamic>? toolResult,  List<String> attachedNoteIds,  List<String> attachedProgramIds, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.toolName,_that.toolArgs,_that.toolResult,_that.attachedNoteIds,_that.attachedProgramIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String content,  String? toolName,  Map<String, dynamic>? toolArgs,  Map<String, dynamic>? toolResult,  List<String> attachedNoteIds,  List<String> attachedProgramIds, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.role,_that.content,_that.toolName,_that.toolArgs,_that.toolResult,_that.attachedNoteIds,_that.attachedProgramIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ChatRole role,  String content,  String? toolName,  Map<String, dynamic>? toolArgs,  Map<String, dynamic>? toolResult,  List<String> attachedNoteIds,  List<String> attachedProgramIds, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.toolName,_that.toolArgs,_that.toolResult,_that.attachedNoteIds,_that.attachedProgramIds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.role, this.content = '', this.toolName, final  Map<String, dynamic>? toolArgs, final  Map<String, dynamic>? toolResult, final  List<String> attachedNoteIds = const <String>[], final  List<String> attachedProgramIds = const <String>[], @TimestampConverter() this.createdAt}): _toolArgs = toolArgs,_toolResult = toolResult,_attachedNoteIds = attachedNoteIds,_attachedProgramIds = attachedProgramIds;
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  ChatRole role;
@override@JsonKey() final  String content;
@override final  String? toolName;
 final  Map<String, dynamic>? _toolArgs;
@override Map<String, dynamic>? get toolArgs {
  final value = _toolArgs;
  if (value == null) return null;
  if (_toolArgs is EqualUnmodifiableMapView) return _toolArgs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _toolResult;
@override Map<String, dynamic>? get toolResult {
  final value = _toolResult;
  if (value == null) return null;
  if (_toolResult is EqualUnmodifiableMapView) return _toolResult;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String> _attachedNoteIds;
@override@JsonKey() List<String> get attachedNoteIds {
  if (_attachedNoteIds is EqualUnmodifiableListView) return _attachedNoteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachedNoteIds);
}

 final  List<String> _attachedProgramIds;
@override@JsonKey() List<String> get attachedProgramIds {
  if (_attachedProgramIds is EqualUnmodifiableListView) return _attachedProgramIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachedProgramIds);
}

@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other._toolArgs, _toolArgs)&&const DeepCollectionEquality().equals(other._toolResult, _toolResult)&&const DeepCollectionEquality().equals(other._attachedNoteIds, _attachedNoteIds)&&const DeepCollectionEquality().equals(other._attachedProgramIds, _attachedProgramIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,toolName,const DeepCollectionEquality().hash(_toolArgs),const DeepCollectionEquality().hash(_toolResult),const DeepCollectionEquality().hash(_attachedNoteIds),const DeepCollectionEquality().hash(_attachedProgramIds),createdAt);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, toolName: $toolName, toolArgs: $toolArgs, toolResult: $toolResult, attachedNoteIds: $attachedNoteIds, attachedProgramIds: $attachedProgramIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatRole role, String content, String? toolName, Map<String, dynamic>? toolArgs, Map<String, dynamic>? toolResult, List<String> attachedNoteIds, List<String> attachedProgramIds,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? toolName = freezed,Object? toolArgs = freezed,Object? toolResult = freezed,Object? attachedNoteIds = null,Object? attachedProgramIds = null,Object? createdAt = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolArgs: freezed == toolArgs ? _self._toolArgs : toolArgs // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolResult: freezed == toolResult ? _self._toolResult : toolResult // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,attachedNoteIds: null == attachedNoteIds ? _self._attachedNoteIds : attachedNoteIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachedProgramIds: null == attachedProgramIds ? _self._attachedProgramIds : attachedProgramIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
