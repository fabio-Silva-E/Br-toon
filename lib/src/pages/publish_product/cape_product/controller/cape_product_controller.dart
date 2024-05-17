import 'dart:io';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/home/repository/home_repository.dart';
import 'package:brasiltoon/src/pages/publishers/controller/publishers_contoller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/repository/cape_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/result/cape_product_result.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/view/publish_product_chapter_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class CapeProductController extends GetxController {
  bool isCategoryLoading = false;
  bool isProductLoading = true;
  RxBool isloading = false.obs;
  final homeRepository = HomeRepository();
  final homeController = Get.find<HomeController>();
  final publisherController = Get.find<PublisherController>();
  final utilsServices = UtilsServices();
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  List<ItemModel> items = [];
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

  void setLoading(
    bool value, {
    bool isProduct = false,
    /*bool changingCategory = false*/
  }) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    //isChangingCategory = changingCategory;
    update();
  }

  void selectCategory(CategoryModel category) {
    selectedCategoryId = category.id; // Defina o ID da categoria selecionada
    update();
  }

  Future<void> getAllCategory() async {
    CapeProductResult<List<CategoryModel>> capeProductResult =
        await capeProductRepository.getAllCategories();

    capeProductResult.when(
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

  Future<void> publishCover({
    required String title,
    required String image,
    required String description,
    required String category,
  }) async {
    isloading.value = true;
    currentCategory =
        allCategories.firstWhereOrNull((cat) => cat.id == category);
    // Lê o conteúdo do arquivo como bytes
    // List<int> imageBytes = await cape.readAsBytes();

    // Codifica os bytes em formato base64
    //  String base64Image = base64Encode(imageBytes);
    //   final savedImageId = await saveImageToParse(image);
    final CapeProductResult<String> result =
        await capeProductRepository.publishCover(
      token: authController.user.token!,
      userId: authController.user.id!,
      title: title,
      cape: image,
      description: description,
      category: category,
    );
    isloading.value = false;
    result.when(success: (productId) {
      final item = ItemModel(
        id: productId,
        description: description,
        imgUrl: null, //corrigir o erro
        itemName: title,
        chapters: [],
        pagination: 0,
      );
      // Se a operação foi bem-sucedida, você pode prosseguir com outras ações
      productId;

      homeController.addItem(category: category, item: item);
      publisherController.addItem(category: category, item: item);
      Get.to(() => PublishChapterTab(productId: productId));
      // print('Success! Product ID: $productId');
      update();
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<String> saveImageToParse(XFile image) async {
    isloading.value = true;
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

    final gallery = ParseObject('Gallery')..set('file', parseFile);
    await gallery.save();
    final savedId = gallery.objectId;

    // Obtenha o ID salvo

    //isloading.value = false;
    return savedId.toString();
  }
}
