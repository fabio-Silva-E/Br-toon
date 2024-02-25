import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_pages_chapter_result.freezed.dart';

@freezed
class ProductPagesChapterResult<T> with _$ProductPagesChapterResult<T> {
  factory ProductPagesChapterResult.success(T data) = Success;
  factory ProductPagesChapterResult.error(String message) = Error;
}
