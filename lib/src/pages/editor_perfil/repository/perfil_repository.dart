import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/editor_perfil/result/perfil_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class PerfilRepository {
  final HttpManager _httpManager = HttpManager();

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
}
