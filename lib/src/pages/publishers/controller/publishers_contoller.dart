import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/repository/editing_repository.dart';
import 'package:brasiltoon/src/pages/story_editing/result/editi_result.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publishers/repository/publishers_repository.dart';
import 'package:brasiltoon/src/pages/publishers/result/publishers_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

const int itemPerPage = 6;

class PublisherController extends GetxController {
  final utilsServices = UtilsServices();
  final publishersRepository = PublisherRepository();
  final editingRepository = EditingRepository();
  bool isCategoryloading = false;
  bool isProductloading = true;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  RxString searchTitle = ''.obs;
  final authController = Get.find<AuthController>();
  final homeController = Get.find<HomeController>();
  List<ItemModel> items = [];
  bool get isLastPage {
    if (currentCategory!.items.length < itemPerPage) return true;
    return currentCategory!.pagination * itemPerPage > allProducts.length;
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryloading = value;
    } else {
      isProductloading = value;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
    getAllCategory();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) return;
    getPublishersItems();
  }

  Future<void> getAllCategory() async {
    setLoading(true);
    PublishersResult<List<CategoryModel>> publishersResult =
        await publishersRepository.getAllCategories();
    setLoading(false);
    publishersResult.when(
      success: (data) {
        allCategories.assignAll(data);
        //print('Start $data');
        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
    setLoading(false);
  }

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }
    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        final allProductsCategory = CategoryModel(
          title: 'todos',
          id: '',
          items: [],
          pagination: 0,
        );
        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }
    currentCategory = allCategories.first;
    update();
    getPublishersItems();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getPublishersItems(canLoad: false);
  }

  Future<void> removeItemOfEditor({
    required String productId,
  }) async {
    final EditiResult<String> result = await editingRepository.deleteCover(
      productId: productId,
      token: authController.user.token!,
      userId: authController.user.id!,
    );
    result.when(success: (data) {
      // Remove o item dos favoritos locais
      items.removeWhere((item) => item.id == item.id);
      // Remove o item da lista de favoritos do controller
      currentCategory!.items.removeWhere((item) => item.id == item.id);
      // Atualiza a tela
      homeController.currentCategory!.items
          .removeWhere((item) => item.id == item.id);
      getPublishersItems();
      homeController.getAllProducts();
      update();
      //   await getFavoritesItems();
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<void> getPublishersItems({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    final result = await publishersRepository.getPublishersItems(
      token: authController.user.token!,
      userId: authController.user.id!,
      page: currentCategory!.pagination,
      itemPerPage: itemPerPage,
      categoryId: searchTitle.value.isNotEmpty ? null : currentCategory!.id,
      title: searchTitle.value.isNotEmpty ? searchTitle.value : null,
    );

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
        // update();
        // print(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> addItem({
    required String category,
    required ItemModel item,
    // required String categoryId,
  }) async {
    // Obtenha a categoria correspondente ao ID

    getAllCategory();
    currentCategory =
        allCategories.firstWhereOrNull((cat) => cat.id == category);
    // Adiciona o novo item à lista de favoritos da categoria correspondente
    currentCategory!.items.add(item);

    getPublishersItems();
    update();
  }
}
