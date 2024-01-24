import 'package:brasiltoon/src/constants/storage_keys.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/repository/auth_repository.dart';
import 'package:brasiltoon/src/pages/auth/result/auth_result.dart';
import 'package:brasiltoon/src/pages_routes/app_pages.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool setLoading = false.obs;
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
    isLoading.value = true;
    final result = await authRepository.changPassword(
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: user.token!,
    );
    isLoading.value = false;
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
    isLoading.value = true;
    AuthResult result = await authRepository.signUp(user);
    isLoading.value = false;
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
    isLoading.value = true;
    AuthResult result =
        await authRepository.signin(email: email, password: password);
    isLoading.value = false;
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

  String extractAndReplace(String fullUrl) {
    // Analisa a URL completa
    Uri uri = Uri.parse(fullUrl);

    // Obtém o caminho local após a última barra
    String localPath = uri.pathSegments.last;

    // Substitui "%25" por "/"
    String modifiedPath = localPath.replaceAll('%25', '/');

    return modifiedPath;
  }

  Future<void> modifyImage(String profilePath, File newImage) async {
    setLoading.value =
        true; // Definindo o estado de carregamento para verdadeiro
    String modifiedPath = extractAndReplace(profilePath);
    try {
      //
      // Referência ao caminho no Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child(modifiedPath);
      print(modifiedPath);
      // Envia o novo arquivo para substituir o existente
      await storageReference.putFile(newImage);

      // Obtém o URL do arquivo recém-enviado
      String imagePath = await storageReference.getDownloadURL();

      // Atualiza o URL da imagem no seu modelo de usuário ou onde quer que seja necessário
      user.userphoto = imagePath;

      // Outras ações ou atualizações necessárias

      // Retorna o URL completo da imagem
      print(imagePath);
      setLoading.value = false;
    } catch (e) {
      // Lida com erros durante a modificação
      utilsServices.showToast(
        message: 'Erro durante a modificação da imagem: $e',
        isError: true,
      );
      print('Erro durante a modificação da imagem: $e');
      setLoading.value = false;
    }
  }

  Future<String> saveImageToAppDirectoryFromBytes(List<int> bytes) async {
    // Criar um arquivo temporário no diretório de cache
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/temp_image.png');

    // Escrever os bytes da imagem no arquivo temporário
    await tempFile.writeAsBytes(bytes);

    // Chamar o método existente para salvar o arquivo
    return saveImageToAppDirectory(tempFile);
  }

  Future<String> saveImageToAppDirectory(File image) async {
    try {
      // Gera um nome de arquivo único para a imagem usando UUID
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = '$uniqueFileName.png';

      // Referência ao caminho no Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('perfil/$imageName');

      // Envia o arquivo para o Firebase Storage
      await storageReference.putFile(image);

      // Obtém o URL do arquivo recém-enviado
      String imagePath = await storageReference.getDownloadURL();

      // Retorna o URL completo da imagem
      print(imagePath);
      return imagePath;
    } catch (e) {
      // Lida com erros durante o upload
      utilsServices.showToast(
        message: 'Erro durante o upload da imagem: $e',
        isError: true,
      );
      print('Erro durante o upload da imagem: $e');
      return '';
    }
  }
}
