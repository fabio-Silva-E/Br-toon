import 'package:freezed_annotation/freezed_annotation.dart';

part 'publish_chapter_result.freezed.dart';

@freezed
class ChapterResult<T> with _$ChapterResult<T> {
  factory ChapterResult.success(T data) = Success;
  factory ChapterResult.error(String message) = Error;
}
