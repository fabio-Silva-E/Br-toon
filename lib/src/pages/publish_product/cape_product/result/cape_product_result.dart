import 'package:freezed_annotation/freezed_annotation.dart';

part 'cape_product_result.freezed.dart';

@freezed
class CapeProductResult<T> with _$CapeProductResult<T> {
  factory CapeProductResult.success(T data) = Success;
  factory CapeProductResult.error(String message) = Error;
}
