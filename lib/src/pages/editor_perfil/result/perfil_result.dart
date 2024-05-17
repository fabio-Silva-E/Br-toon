import 'package:freezed_annotation/freezed_annotation.dart';

part 'perfil_result.freezed.dart';

@freezed
class PerfilResult<T> with _$PerfilResult<T> {
  factory PerfilResult.success(T data) = Success;
  factory PerfilResult.error(String message) = Error;
}
