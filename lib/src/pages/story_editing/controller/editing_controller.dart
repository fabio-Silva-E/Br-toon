import 'dart:io';

import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/repository/editing_repository.dart';
import 'package:brasiltoon/src/pages/story_editing/result/editi_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class EditingController extends GetxController {
  RxBool isLoading = false.obs;
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

  String extractAndReplace(String fullUrl) {
    // Analisa a URL completa
    Uri uri = Uri.parse(fullUrl);

    // Obtém o caminho local após a última barra
    String localPath = uri.pathSegments.last;

    // Substitui "%25" por "/"
    String modifiedPath = localPath.replaceAll('%25', '/');

    return modifiedPath;
  }

  Future<void> modifyCover(String profilePath, File newImage) async {
    isLoading.value =
        true; // Definindo o estado de carregamento para verdadeiro
    String modifiedPath = extractAndReplace(profilePath);
    try {
      //
      // Referência ao caminho no Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child(modifiedPath);
      print('imagem para modificação $modifiedPath');
      // Envia o novo arquivo para substituir o existente
      await storageReference.putFile(newImage);

      // Obtém o URL do arquivo recém-enviado
      String imagePath = await storageReference.getDownloadURL();

      // Atualiza o URL da imagem no seu modelo de usuário ou onde quer que seja necessário
      //  user.userphoto = imagePath;

      // Outras ações ou atualizações necessárias

      // Retorna o URL completo da imagem
      print(' imagem modificada $imagePath');
      isLoading.value = false;
    } catch (e) {
      // Lida com erros durante a modificação
      utilsServices.showToast(
        message: 'Erro durante a modificação da imagem: $e',
        isError: true,
      );
      print('Erro durante a modificação da imagem: $e');
      isLoading.value = false;
    }
  }

  Future<void> editiCover({
    required String title,
    required String productId,
    required String description,
    required String category,
  }) async {
    isLoading.value = true;

    final EditiResult<String> result = await editingRepository.editiCover(
      userId: authController.user.id!,
      token: authController.user.token!,
      title: title,
      productId: productId,
      description: description,
      category: category,
    );

    isLoading.value = false;
    result.when(success: (data) {
      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      utilsServices.showToast(
        message: 'os dados da historia foram alterados para\n $data',
      );
      // print('Success!: $data');
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }
}
