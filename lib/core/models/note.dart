import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    @Default('') String title,
    @Default('') String body,
    @Default(<String>[]) List<String> tags,
    @Default(false) bool pinned,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
