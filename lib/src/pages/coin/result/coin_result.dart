import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_result.freezed.dart';

@freezed
class CoinResult<T> with _$CoinResult<T> {
  factory CoinResult.success(List<T> data) = Success;
  factory CoinResult.error(String message) = Error;
}
