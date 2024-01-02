import 'package:freezed_annotation/freezed_annotation.dart';

part 'pages_product_result.freezed.dart';

@freezed
class PageResult<T> with _$PageResult<T> {
  factory PageResult.success(T data) = Success;
  factory PageResult.error(String message) = Error;
}
