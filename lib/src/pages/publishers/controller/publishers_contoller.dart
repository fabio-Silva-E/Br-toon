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
  bool isCategoryloading = false;
  bool isProductloading = true;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  RxString searchTitle = ''.obs;
  final authController = Get.find<AuthController>();
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
  }

  void filterByTitle() {
    // Limpa os itens de todas as categorias
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if (searchTitle.value.isNotEmpty) {
      // Se a busca por título não estiver vazia, remova a categoria "todos" se existir
      allCategories.removeWhere((cat) => cat.id == '');

      // Cria uma nova categoria "todos" com base nos resultados da pesquisa
      final allProductsCategory = CategoryModel(
        title: 'todos',
        id: '',
        items: [],
        pagination: 0,
      );

      // Adiciona a nova categoria "todos" no início da lista de categorias
      allCategories.insert(0, allProductsCategory);
    } else {
      // Se a busca por título estiver vazia, remove a categoria "todos" se existir
      allCategories.removeWhere((cat) => cat.id == '');
    }

    currentCategory = allCategories.first;
    update();
    getPublishersItems();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getPublishersItems(canLoad: false);
  }

  Future<void> getPublishersItems({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    final result = await publishersRepository.getPublishersItems(
      token: authController.user.token!,
      userId: authController.user.id!,
      categoryId: searchTitle.value.isNotEmpty ? null : currentCategory!.id,
      title: searchTitle.value.isNotEmpty ? searchTitle.value : null,
    );

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        items = data;
        update();
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
}
