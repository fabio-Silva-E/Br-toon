import 'package:brasiltoon/src/constants/storage_keys.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/repository/auth_repository.dart';
import 'package:brasiltoon/src/pages/auth/result/auth_result.dart';
import 'package:brasiltoon/src/pages_routes/pages_routes.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isloading = false.obs;
  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();
  UserModel user = UserModel();
  @override
  void onInit() {
    super.onInit();
    validateToken();
  }

  Future<void> validateToken() async {
    //recuperar o token salvo localmente
    String? token = await utilsServices.getLocalDate(key: StorageKeys.token);
    // authRepository.validateToken(token);
    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }
    AuthResult result = await authRepository.validateToken(token);
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        signOut();
      },
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isloading.value = true;
    final result = await authRepository.changPassword(
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: user.token!,
    );
    isloading.value = false;
    if (result) {
      //menssagem
      utilsServices.showToast(
        message: 'A senha foi atualizada com sucesso!',
      );
      //logout
      signOut();
    } else {
      utilsServices.showToast(
        message: 'A senha atual está incorreta',
        isError: true,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> signOut() async {
    //zerar o user
    user = UserModel();
    //remover o token localmente
    await utilsServices.removeLocalData(key: StorageKeys.token);
    //ir para o login
    Get.offAllNamed(PagesRoutes.signInRoute);
  }

  void saveTokenAndProceedToBase() {
    //salvar token
    utilsServices.saveLocalDate(key: StorageKeys.token, date: user.token!);
    //ir para tela base
    Get.offAllNamed(PagesRoutes.baseRoute);
  }

  Future<void> signUp() async {
    isloading.value = true;
    AuthResult result = await authRepository.signUp(user);
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isloading.value = true;
    AuthResult result =
        await authRepository.signin(email: email, password: password);
    isloading.value = false;
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        print(message);
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
