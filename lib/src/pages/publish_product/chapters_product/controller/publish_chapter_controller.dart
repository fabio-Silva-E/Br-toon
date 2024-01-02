import 'dart:io';

import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/repository/publish_chapter_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/result/publish_chapter_result.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/view/publish_pages_product.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class PublishChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final String productId;
  final authController = Get.find<AuthController>();

  PublishChapterController({required this.productId});
  final chapterRepository = ChapterRepository();

  Future<void> publishChapter({
    required String title,
    required String cape,
    required String productId,
  }) async {
    final ChapterResult<String> result = await chapterRepository.publishChapter(
      token: authController.user.token!,
      userId: authController.user.id!,
      title: title,
      cape: cape,
      product: productId,
    );
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
    try {
      // Obtém o diretório de documentos do aplicativo
      // Directory appDocDir =   await getApplicationDocumentsDirectory();

      // Concatena o caminho desejado para o diretório de imagens
      String imagesDirectoryPath = 'assets/manga'; //'${appDocDir.path}/images';

      // Verifica se o diretório de imagens existe, senão cria
      Directory imagesDirectory = Directory(imagesDirectoryPath);
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      // Gera um nome de arquivo único para a imagem
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imagePath = '$imagesDirectoryPath/$uniqueFileName.png';

      // Copia o arquivo da imagem para o caminho desejado
      await image.copy(imagePath);

      // Retorna o caminho completo da imagem
      print(imagePath);
      return imagePath;
    } catch (e) {
      (message) {
        utilsServices.showToast(
          message: 'Erro durante o upload da imagem: $e',
          isError: true,
        );
      };
      return '';
    }
  }
}
