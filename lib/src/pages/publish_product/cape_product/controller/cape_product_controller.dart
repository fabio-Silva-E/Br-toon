import 'dart:io';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/home/repository/home_repository.dart';
import 'package:brasiltoon/src/pages/publishers/controller/publishers_contoller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/repository/cape_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/result/cape_product_result.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/view/publish_product_chapter_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';

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
    required String cape,
    required String description,
    required String category,
  }) async {
    isloading.value = true;
    currentCategory =
        allCategories.firstWhereOrNull((cat) => cat.id == category);
    final CapeProductResult<String> result =
        await capeProductRepository.publishCover(
      token: authController.user.token!,
      userId: authController.user.id!,
      title: title,
      cape: cape,
      description: description,
      category: category,
    );
    isloading.value = false;
    result.when(success: (productId) {
      final item = ItemModel(
        id: productId,
        description: description,
        imgUrl: cape,
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

  /*  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'itemsPerPage': itemPerPage,
      'categoryId': currentCategory!.id,
    };
    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;
      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }
    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);
    setLoading(false, isProduct: true);
    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
        // print('home $data');
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }*/
  /* Future<String> saveImageToAppDirectory(File image) async {
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
  }*/
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
