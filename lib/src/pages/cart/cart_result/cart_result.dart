import 'package:freezed_annotation/freezed_annotation.dart';

part 'Cart_result.freezed.dart';

@freezed
class CartResult<T> with _$CartResult<T> {
  factory CartResult.success(T data) = Success;
  factory CartResult.error(String message) = Error;
}
