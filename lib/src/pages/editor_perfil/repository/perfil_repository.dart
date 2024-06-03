import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/follow_editor_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/editor_perfil/result/perfil_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/editor_perfil/repository/perfil_error.dart'
    as authErrors;

class PerfilRepository {
  final HttpManager _httpManager = HttpManager();
  final authController = Get.find<AuthController>();
  PerfilResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = FollowEditorModel.fromJson(result['result']);
      print(user);
      return PerfilResult.success(user);
    } else {
      return PerfilResult.error(authErrors.followErrorString(result['error']));
    }
  }

  Future<PerfilResult> perfil({
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.perfil,
        method: HttpMethods.post,
        body: {"userId": userId});
    if (result['result'] != null) {
      UserModel data = UserModel.fromJson(result['result']);

      return PerfilResult.success(data);
    } else {
      return PerfilResult.error((result['error']));
    }
  }

  Future<PerfilResult> getAllperfil() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.perfil,
        method: HttpMethods.post,
        body: {"userId": null});
    if (result['result'] != null) {
      List<UserModel> data = (List<Map<String, dynamic>>.from(result['result']))
          .map(UserModel.fromJson)
          .toList();
      return PerfilResult.success(data);
    } else {
      return PerfilResult.error((result['error']));
    }
  }

  Future<PerfilResult> follow({
    required String userId,
  }) async {
    final result = await _httpManager
        .restRequest(url: Endpoints.follow, method: HttpMethods.post, headers: {
      'X-Parse-Session-Token': authController.user.token,
    }, body: {
      'user': authController.user.id,
      'userId': userId, // Assegure-se de usar 'userId' em vez de 'user'
    });
    // Converta explicitamente o resultado para Map<String, dynamic>
    return handleUserOrError(result);
  }

  Future<PerfilResult<String>> unFollow({
    required String id,
  }) async {
    final body = {
      'followeditorId': id, // Asse 'postId': productId,
    };

    final result = await _httpManager.restRequest(
      url: Endpoints.unfollow,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      return PerfilResult.success(result['result']);
    } else {
      return PerfilResult.error('Não foi possivel deixar de seguir o editor');
    }
  }

  Future<PerfilResult<bool>> checkIfFollowing({
    required String editorId,
  }) async {
    final body = {
      'userId': authController
          .user.id, // Assegure-se de usar 'userId' em vez de 'user'
      'editor': editorId,
    };

    final result = await _httpManager.restRequest(
      url: Endpoints.checkIfFollowing,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      return PerfilResult.success(result['result']['isFollow'] as bool);
    } else {
      return PerfilResult.error('Não foi possível checar');
    }
  }

  Future<PerfilResult> abstractId({
    required String editorId,
  }) async {
    final body = {
      'userId': authController
          .user.id, // Assegure-se de usar 'userId' em vez de 'user'
      'editor': editorId,
    };

    final result = await _httpManager.restRequest(
      url: Endpoints.abstractId,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null && result['result']['id'] != null) {
      return PerfilResult.success(result['result']['id']);
    } else {
      // Retorne null ou outra indicação de que não há ID
      return PerfilResult.success(null);
    }
  }
}
