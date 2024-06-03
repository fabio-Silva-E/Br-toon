import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_result.freezed.dart';

@freezed
class LikeResult<T> with _$LikeResult<T> {
  factory LikeResult.success(T data) = Success;
  factory LikeResult.error(String message) = Error;
}
