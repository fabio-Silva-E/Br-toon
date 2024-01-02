import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_result.freezed.dart';

@freezed
class FavoritesResult<T> with _$FavoritesResult<T> {
  factory FavoritesResult.success(T data) = Success;
  factory FavoritesResult.error(String message) = Error;
}
