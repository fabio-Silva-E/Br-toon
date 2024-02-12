import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/repository/publish_chapter_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/result/publish_chapter_result.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/view/publish_pages_product.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class PublishChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final String productId;
  RxBool isloading = false.obs;
  final authController = Get.find<AuthController>();

  PublishChapterController({required this.productId});
  final chapterRepository = ChapterRepository();

  Future<void> publishChapter({
    required String title,
    required String cape,
    required String productId,
    required String description,
  }) async {
    isloading.value = true;
    final ChapterResult<String> result = await chapterRepository.publishChapter(
        token: authController.user.token!,
        userId: authController.user.id!,
        title: title,
        cape: cape,
        productId: productId,
        description: description);
    isloading.value = false;
    print('Success! Product ID: $productId');
    result.when(success: (chapterId) {
      chapterId;

      update();
      Get.to(() => PublishPageTab(chapterId: chapterId));
      print('Success! chapter ID: $chapterId');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });

    //  update();
  }

  Future<String> saveImageToAppDirectory(File image) async {
    isloading.value = true;
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
      isloading.value = false;
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
