import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum ChatRole { user, model, tool, system }

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required ChatRole role,
    @Default('') String content,
    String? toolName,
    Map<String, dynamic>? toolArgs,
    Map<String, dynamic>? toolResult,
    @Default(<String>[]) List<String> attachedNoteIds,
    @Default(<String>[]) List<String> attachedProgramIds,
    @TimestampConverter() DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
