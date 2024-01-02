import 'package:freezed_annotation/freezed_annotation.dart';

part 'publishers_result.freezed.dart';

@freezed
class PublishersResult<T> with _$PublishersResult<T> {
  factory PublishersResult.success(T data) = Success;
  factory PublishersResult.error(String message) = Error;
}
