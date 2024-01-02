import 'dart:io';

import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/repository/pages_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/result/pages_product_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class PublishPageController extends GetxController {
  final utilsServices = UtilsServices();
  final String chapterId;
  final authController = Get.find<AuthController>();

  PublishPageController({required this.chapterId});
  final pageRepository = PageRepository();
  Future<void> publishPages({
    required String page,
    required String chapterId,
  }) async {
    final PageResult<String> result = await pageRepository.publishPages(
      token: authController.user.token!,
      userId: authController.user.id!,
      page: page,
      chapterId: chapterId,
    );
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
