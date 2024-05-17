import 'dart:io';

import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/controller/product_chapter_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/repository/editing_repository.dart';
import 'package:brasiltoon/src/pages/story_editing/result/editi_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class EditingController extends GetxController {
  RxBool isLoading = false.obs;
  // final homeController = Get.find<HomeController>();
  final pagecontroller = Get.find<ProductPagesChapterController>();
  final chaptercontroller = Get.find<ProductChapterController>();
  final utilsServices = UtilsServices();
  final editingRepository = EditingRepository();
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
    EditiResult<List<CategoryModel>> editiResult =
        await editingRepository.getAllCategories();

    editiResult.when(
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
      final ParseObject gallery = ParseObject('Gallery')..objectId = objectId;
      gallery.set('file', parseFile);

      // Salve as alterações para sobrescrever o arquivo existente
      final ParseResponse response = await gallery.save();

      if (response.success) {
        print('Arquivo sobrescrito com sucesso.');
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

  Future<void> overwriteFileInGalleryPage({
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
      final ParseObject gallery = ParseObject('GalleryPage')
        ..objectId = objectId;
      gallery.set('file', parseFile);

      // Salve as alterações para sobrescrever o arquivo existente
      final ParseResponse response = await gallery.save();

      if (response.success) {
        print('Arquivo sobrescrito com sucesso.');
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

  Future<void> overwriteFileInGalleryChapter({
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
      final ParseObject gallery = ParseObject('GalleryChapter')
        ..objectId = objectId;
      gallery.set('file', parseFile);

      // Salve as alterações para sobrescrever o arquivo existente
      final ParseResponse response = await gallery.save();

      if (response.success) {
        print('Arquivo sobrescrito com sucesso.');
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

  Future<void> editeCover({
    required String title,
    required String productId,
    required String description,
    required String category,
    XFile? newImageFile,
    required String Id,
  }) async {
    isLoading.value = true;
    if (newImageFile != null) {
      await overwriteFileInGallery(objectId: Id, newFile: newImageFile)
          .catchError((error) {
        // Ensure loading is set to false on error
        utilsServices.showToast(
          message: 'Erro ao atualizar a imagem',
          isError: true,
        );
      });
    }
    final EditiResult<String> result = await editingRepository.editeCover(
      userId: authController.user.id!,
      token: authController.user.token!,
      title: title,
      productId: productId,
      description: description,
      category: category,
    );

    isLoading.value = false;
    result.when(success: (data) {
      // homeController.getAllProducts();

      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      utilsServices.showToast(
        message:
            'Dados da historia alterados com sucesso!', //'Os dados da historia foram alterados para\n $data',
      );
      // print('Success!: $data');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<void> editeChapter({
    required String title,
    required String chapterId,
    required String description,
    XFile? newImageFile,
    required String Id,
  }) async {
    isLoading.value = true;
    if (newImageFile != null) {
      await overwriteFileInGalleryChapter(objectId: Id, newFile: newImageFile)
          .catchError((error) {
        // Ensure loading is set to false on error
        utilsServices.showToast(
          message: 'Erro ao atualizar a imagem',
          isError: true,
        );
      });
    }
    final EditiResult<String> result = await editingRepository.editeChapter(
      userId: authController.user.id!,
      token: authController.user.token!,
      title: title,
      chapterId: chapterId,
      description: description,
    );
    isLoading.value = false;
    result.when(success: (data) {
      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      utilsServices.showToast(
        message:
            'Capitulo alterado com sucesso!', //'os dados do capitulo foram alterados para\n $data',
      );
      // print('Success!: $data');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<void> editePage({
    required String pageId,
    XFile? newImageFile,
    required String Id,
  }) async {
    isLoading.value = true;
    if (newImageFile != null) {
      await overwriteFileInGalleryPage(objectId: Id, newFile: newImageFile)
          .catchError((error) {
        // Ensure loading is set to false on error
        utilsServices.showToast(
          message: 'Erro ao atualizar a imagem',
          isError: true,
        );
      });
    }
    final EditiResult<String> result = await editingRepository.editePage(
      userId: authController.user.id!,
      token: authController.user.token!,
      pageId: pageId,
    );
    isLoading.value = false;
    result.when(success: (data) {
      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      utilsServices.showToast(
        message:
            'Pagina alterada com sucesso!', //'os dados do capitulo foram alterados para\n $data',
      );
      // print('Success!: $data');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<void> deletePage({
    required String pageId,
    required String chapter,
  }) async {
    isLoading.value = true;

    try {
      final EditiResult<String> result = await editingRepository.deletePage(
        userId: authController.user.id!,
        token: authController.user.token!,
        pageId: pageId,
      );

      result.when(success: (data) {
        utilsServices.showToast(
          message: 'Pagina deletada com sucesso!',
        );
        pagecontroller.deletePage(chapterId: chapter, pageId: pageId);
      }, error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      });
    } catch (e) {
      // Handle any other exceptions
      utilsServices.showToast(
        message: 'Ocorreu um erro inesperado: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false; // Ensure isLoading is always set to false
    }
  }

  Future<void> deleteChapter({
    required String chapterId,
    required String productId,
  }) async {
    isLoading.value = true;
    try {
      final EditiResult<String> result = await editingRepository.deleteChapter(
        userId: authController.user.id!,
        token: authController.user.token!,
        chapterId: chapterId,
      );
      //  isLoading.value = false;
      result.when(success: (data) {
        // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
        utilsServices.showToast(
          message:
              'Capitulo deletado com sucesso!', //'os dados do capitulo foram alterados para\n $data',
        );
        chaptercontroller.deleteChapter(
            chapterId: chapterId, productId: productId); // Recarregue a página
      }, error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      });
    } finally {
      isLoading.value = false; // Ensure isLoading is always set to false
    }
  }

  Future<void> deleteCover({
    required String productId,
  }) async {
    isLoading.value = true;

    final EditiResult<String> result = await editingRepository.deleteCover(
      userId: authController.user.id!,
      token: authController.user.token!,
      productId: productId,
    );
    isLoading.value = false;
    result.when(success: (data) {
      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      utilsServices.showToast(
        message:
            'Historia deletado com sucesso!', //'os dados do capitulo foram alterados para\n $data',
      );
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }
}
