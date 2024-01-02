import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_chapter_result.freezed.dart';

@freezed
class ProductChapterResult<T> with _$ProductChapterResult<T> {
  factory ProductChapterResult.success(List<T> data) = Success;
  factory ProductChapterResult.error(String message) = Error;
}
