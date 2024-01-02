import 'dart:io';

import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/repository/cape_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/result/cape_product_result.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/view/publish_product_chapter_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class CapeProductController extends GetxController {
  RxBool isloading = false.obs;
  final utilsServices = UtilsServices();
  final capeProductRepository = CapeProductRepository();
  final authController = Get.find<AuthController>();
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  String? selectedCategoryId;

  @override
  void onInit() {
    super.onInit();

    getAllCategory();
  }

  void selectCategory(CategoryModel category) {
    selectedCategoryId = category.id; // Defina o ID da categoria selecionada
    update();
  }

  Future<void> getAllCategory() async {
    CapeProductResult<List<CategoryModel>> favoritesResult =
        await capeProductRepository.getAllCategories();

    favoritesResult.when(
      success: (data) {
        allCategories.assignAll(data);
        //   print("$data");
        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
        //  update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> publishCape({
    required String title,
    required String cape,
    required String description,
    required String category,
  }) async {
    try {
      isloading.value = true;

      final CapeProductResult<String> result =
          await capeProductRepository.publishCape(
        token: authController.user.token!,
        userId: authController.user.id!,
        title: title,
        cape: cape,
        description: description,
        category: category,
      );

      result.when(success: (productId) {
        // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
        productId;
        update();
        Get.to(() => PublishChapterTab(productId: productId));
        print('Success! Product ID: $productId');
      }, error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      });
    } catch (e) {
      // Lidar com erros, se necessário
    } finally {
      isloading.value =
          false; // Garante que isloading seja sempre definido como false
    }
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
      // Lida com erros durante o upload
      print('Erro durante o upload da imagem: $e');
      return '';
    }
  }
}
