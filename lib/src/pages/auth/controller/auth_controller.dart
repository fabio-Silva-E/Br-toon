import 'dart:convert';

import 'package:brasiltoon/src/constants/storage_keys.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/repository/auth_repository.dart';
import 'package:brasiltoon/src/pages/auth/result/auth_result.dart';
import 'package:brasiltoon/src/pages_routes/app_pages.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:path_provider/path_provider.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool setLoading = false.obs;
  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();
  UserModel user = UserModel();
  UserModel editor = UserModel();
  @override
  void onInit() {
    super.onInit();
    validateToken();
    //  perfil(user.id!);
  }

  Future<void> perfil(String userId) async {
    isLoading.value = true;
    AuthResult result = await authRepository.perfil(userId: userId);
    isLoading.value = false;
    result.when(
      success: (data) {
        editor = data;
        // print('usuario $data');
        print('usuario ${user.id}');
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

  Future<void> validateToken() async {
    //recuperar o token salvo localmente
    String? token = await utilsServices.getLocalDate(key: StorageKeys.token);
    //authRepository.validateToken(token);
    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }
    AuthResult result = await authRepository.validateToken(token);
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase(user.token);
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

  void saveTokenAndProceedToBase(String? token) {
    if (user.token != null) {
      //salvar token
      utilsServices.saveLocalDate(key: StorageKeys.token, date: user.token!);
      //ir para tela base
      //  print('token');
      //  print(user.token);
      Get.offAllNamed(PagesRoutes.baseRoute);
    } else {
      // Faça algo se o token for nulo, como exibir uma mensagem de erro
      //  print('Erro: O token do usuário é nulo');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullname,
    required String phone,
    required String personImage,
  }) async {
    isLoading.value = true;
    AuthResult result = await authRepository.signUp(
        email: email,
        personImage: personImage,
        password: password,
        fullname: fullname,
        phone: phone);
    isLoading.value = false;
    result.when(
      success: (user) {
        utilsServices.showToast(
          message: 'cadastro realizado ',
        );
        /*  signIn(email: this.user.email!, password: this.user.password!);
        // Get.offAllNamed(PagesRoutes.signInRoute);*/
        this.user = user;
        saveTokenAndProceedToBase(user.token);
        //  signIn(email: this.user.email!, password: this.user.password!);
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
        saveTokenAndProceedToBase(user.token);
      },
      error: (message) {
        // print(message);
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<String> saveImageToParse(XFile image) async {
    isLoading.value = true;
    ParseFileBase? parseFile;

    if (kIsWeb) {
      //Flutter Web
      parseFile = ParseWebFile(await image.readAsBytes(),
          name: 'image.jpg'); //Name for file is required
    } else {
      //Flutter Mobile/Desktop
      parseFile = ParseFile(File(image.path));
    }
    await parseFile.save();

    final gallery = ParseObject('GalleryPerfil')..set('file', parseFile);
    await gallery.save();
    final savedId = gallery.objectId;

    // Obtenha o ID salvo

    //isloading.value = false;
    return savedId.toString();
  }

  Future<XFile> loadAssetAsXFile(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();

    // Para dispositivos móveis, crie um arquivo temporário
    if (!kIsWeb) {
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(bytes);
      return XFile(tempFile.path);
    }

    // Para web, use XFile.fromData para criar a partir dos bytes
    return XFile.fromData(bytes, name: 'asset_image.png');
  }

  String assetPath = 'assets/perfil/perfil-de-usuario.png';
  Future<String> saveImageToAppDirectoryFromBytes() async {
    //Criar um arquivo temporário no diretório de cache
    XFile xFile = await loadAssetAsXFile(assetPath);

    // Escrever os bytes da imagem no arquivo temporário

    // Chamar o método existente para salvar o arquivo
    return saveImageToParse(xFile);
    //String imagePath = base64Encode(bytes);
    // return imagePath;
  }

  Future<void> overwriteFileInGallery({
    required String objectId,
    required XFile newFile,
  }) async {
    isLoading.value = true;
    try {
      // Crie um ParseFile a partir do novo arquivo
      ParseFileBase? parseFile;

      if (kIsWeb) {
        parseFile = ParseWebFile(
          await newFile.readAsBytes(),
          name: 'new_image.jpg', // O nome do arquivo é obrigatório
        );
      } else {
        parseFile = ParseFile(File(newFile.path));
      }

      // Salve o novo arquivo
      await parseFile.save();

      // Encontre o objeto com o ID fornecido e atualize o campo do arquivo
      final ParseObject gallery = ParseObject('GalleryPerfil')
        ..objectId = objectId;
      gallery.set('file', parseFile);

      // Salve as alterações para sobrescrever o arquivo existente
      final ParseResponse response = await gallery.save();

      if (response.success) {
        user.userphoto?.file = parseFile.url!;
        utilsServices.showToast(
          message: 'foto de perfil alterada',
        );
        await reloadProfile();
      } else {
        utilsServices.showToast(
          message: 'Erro durante a modificação da imagem',
          isError: true,
        );
      }
    } finally {
      isLoading.value =
          false; // Define isLoading como falso somente após todas as operações
    }
  }

  Future<void> reloadProfile() async {
    if (user.id != null) {
      await perfil(user.id!);
    }
  }
}
