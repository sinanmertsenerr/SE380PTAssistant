// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  role: $enumDecode(_$ChatRoleEnumMap, json['role']),
  content: json['content'] as String? ?? '',
  toolName: json['toolName'] as String?,
  toolArgs: json['toolArgs'] as Map<String, dynamic>?,
  toolResult: json['toolResult'] as Map<String, dynamic>?,
  attachedNoteIds:
      (json['attachedNoteIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  attachedProgramIds:
      (json['attachedProgramIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$ChatRoleEnumMap[instance.role]!,
      'content': instance.content,
      'toolName': instance.toolName,
      'toolArgs': instance.toolArgs,
      'toolResult': instance.toolResult,
      'attachedNoteIds': instance.attachedNoteIds,
      'attachedProgramIds': instance.attachedProgramIds,
      'createdAt': _$JsonConverterToJson<Object?, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
    };

const _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.model: 'model',
  ChatRole.tool: 'tool',
  ChatRole.system: 'system',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
