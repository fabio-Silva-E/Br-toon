import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:brasiltoon/src/models/user_models.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  factory AuthResult.success(UserModel user) = Success;
  factory AuthResult.error(String message) = Error;
}
