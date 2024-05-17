import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/editor_perfil/repository/perfil_repository.dart';
import 'package:brasiltoon/src/pages/editor_perfil/result/perfil_result.dart';

import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

class PerfilController extends GetxController {
  RxBool isLoading = true.obs;
  final perfilRepository = PerfilRepository();
  final utilsServices = UtilsServices();
  List<UserModel> list = [];
  UserModel? editor = UserModel();
  @override
  void onInit() {
    super.onInit();
    // perfil(userId: 'yE5vcm6Mb1');
    getAllperfil();
  }

  Future<void> perfil(String userId) async {
    isLoading.value = true;
    PerfilResult result = await perfilRepository.perfil(userId: userId);
    isLoading.value = false;
    result.when(
      success: (data) {
        editor = data;
        // print('usuario $data');
        // print('usuario $userId');
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> getAllperfil() async {
    isLoading.value = true;
    PerfilResult result = await perfilRepository.getAllperfil();
    isLoading.value = false;
    result.when(
      success: (data) {
        list = data;
        //  print('usuario $data');

        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
