import 'package:freezed_annotation/freezed_annotation.dart';

part 'editi_result.freezed.dart';

@freezed
class EditiResult<T> with _$EditiResult<T> {
  factory EditiResult.success(T data) = Success;
  factory EditiResult.error(String message) = Error;
}
