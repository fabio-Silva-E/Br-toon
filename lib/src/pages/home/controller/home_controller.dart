import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/favorites/repository/favorites_repository.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/home/repository/home_repository.dart';
import 'package:brasiltoon/src/pages/home/result/home_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

const int itemPerPage = 6;

class HomeController extends GetxController {
  final utilsServices = UtilsServices();
  final homeRepository = HomeRepository();
  final favoritesRepository = FavoritesRepository();
  // final favoritesController = Get.find<FavoritesController>();
  final authController = Get.find<AuthController>();

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  bool isChangingCategory = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  RxString searchTitle = ''.obs;
  // List<ItemModel> Products = [];
  bool get isLastPage {
    if (currentCategory!.items.length < itemPerPage) return true;
    return currentCategory!.pagination * itemPerPage > allProducts.length;
  }

  // Função específica para atualizar a tela
  /* void updateScreen() {
    update(); // Este método força a atualização da interface do usuário
  }*/

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

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
    getAllCategory();
    //  getProducts();
  }

  void selectCategory(CategoryModel category) {
    // Marque como mudança de categoria
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) {
      // Marque como fim da mudança de categoria
      return;
    }
    getAllProducts();
  }

  Future<void> getAllCategory() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false);
    homeResult.when(
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
    getAllProducts();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
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

    getAllProducts();
    update();
  }

/*  Future<void> getProducts() async {
    final HomeResult<ItemModel> result = await homeRepository.getProducts();

    result.when(
      success: (data) {
        Products = data;
        update();
        // print('items $Products');
        // Retorna a lista de favoritos
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        // Retorna uma lista vazia em caso de erro
      },
    );
  }*/
}

  // Seus outros métodos e variáveis ...

