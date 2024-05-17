import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/result/auth_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';
import 'package:brasiltoon/src/pages/auth/repository/auth_errors.dart'
    as authErrors;

class AuthRepository {
  final HttpManager _httpManager = HttpManager();
  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrors.authErrorString(result['error']));
    }
  }

  Future<bool> changPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changPassword,
        method: HttpMethods.post,
        body: {
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    return result['error'] == null;
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.validateToken,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        });
    return handleUserOrError(result);
  }

  Future<AuthResult> signin({
    required String email,
    required String password,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signin,
        method: HttpMethods.post,
        body: {'email': email, 'password': password});
    return handleUserOrError(result);
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullname,
    required String phone,
    required String personImage,
  }) async {
    final result = await _httpManager
        .restRequest(url: Endpoints.signup, method: HttpMethods.post, body: {
      "email": email,
      "personImage": personImage,
      "password": password,
      "fullname": fullname,
      "phone": phone
    });
    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
        url: Endpoints.resetPassword,
        method: HttpMethods.post,
        body: {'email': email});
  }

  Future<AuthResult> perfil({
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.perfil,
        method: HttpMethods.post,
        body: {"userId": userId});
    if (result['result'] != null) {
      UserModel data = UserModel.fromJson(result['result']);

      return AuthResult.success(data);
    } else {
      return AuthResult.error((result['error']));
    }
  }
}
