import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/repository/pages_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/result/pages_product_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class PublishPageController extends GetxController {
  final utilsServices = UtilsServices();
  final String chapterId;
  RxBool isloading = false.obs;
  final authController = Get.find<AuthController>();

  PublishPageController({required this.chapterId});
  final pageRepository = PageRepository();
  Future<void> publishPages({
    required String page,
    required String chapterId,
  }) async {
    isloading.value = true;
    final PageResult<String> result = await pageRepository.publishPages(
      token: authController.user.token!,
      userId: authController.user.id!,
      page: page,
      chapterId: chapterId,
    );
    isloading.value = false;
    print('chapter ID: $chapterId');
    result.when(success: (pageId) {
      pageId;

      update();
      print('Success! page ID: $pageId');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });

    //  update();
  }

  Future<String> saveImageToAppDirectory(File image) async {
    try {
      // Gera um nome de arquivo único para a imagem usando UUID
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = '$uniqueFileName.png';

      // Referência ao caminho no Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$imageName');

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
