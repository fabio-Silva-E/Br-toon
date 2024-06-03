import 'package:brasiltoon/src/models/follow_editor_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/editor_perfil/repository/perfil_repository.dart';
import 'package:brasiltoon/src/pages/editor_perfil/result/perfil_result.dart';

import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

class PerfilController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isFollowing = false.obs;
  final perfilRepository = PerfilRepository();
  final utilsServices = UtilsServices();
  List<UserModel> list = [];
  UserModel? editor = UserModel();
  FollowEditorModel? followed = FollowEditorModel();
  final authController = Get.find<AuthController>();
  String? followedId;
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

  Future<void> follow(
    String userId,
  ) async {
    final result = await perfilRepository.follow(
      userId: userId,
    );

    result.when(
      success: (followEditorModel) {
        followed = followEditorModel;
        utilsServices.showToast(
          message: 'Agora você está seguindo  ${followed!.editorName}',
        );
        isFollowing.value = true;
        followed = followEditorModel;
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error liking the post: $message');
      },
    );
  }

  Future<void> unFollow(String id) async {
    final result = await perfilRepository.unFollow(id: id);

    result.when(
      success: (success) {
        utilsServices.showToast(
          message: 'voçe não esta mais seguindo este editor',
        );
        isFollowing.value = false;
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error unliking the post: $message');
      },
    );
  }

  Future<void> checkIfFollowing(
    String editorId,
  ) async {
    final result = await perfilRepository.checkIfFollowing(
      editorId: editorId,
    );

    result.when(
      success: (check) {
        isFollowing.value = (check);
        print('Like status for productId: $editorId is $check');
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error checking like status: $message');
      },
    );
  }

  Future<void> abstractId(
    String editorId,
  ) async {
    final result = await perfilRepository.abstractId(
      editorId: editorId,
    );

    result.when(
      success: (check) {
        followedId = (check);
        return followedId;
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error checking like status: $message');
      },
    );
  }
}
