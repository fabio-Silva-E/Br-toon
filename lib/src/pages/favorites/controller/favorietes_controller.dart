import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/favorites_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/favorites/repository/favorites_repository.dart';
import 'package:brasiltoon/src/pages/favorites/result/favorites_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

const int itemPerPage = 6;

class FavoritesController extends GetxController {
  final utilsServices = UtilsServices();
  final favoritesRepository = FavoritesRepository();
  bool isCategoryloading = false;
  bool isCheckingInitialFavorites =
      true; // Adicione esta variável para rastrear o estado de checagem inicial

  bool isProductloading = true;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  RxString searchTitle = ''.obs;
  final authController = Get.find<AuthController>();
  List<FavoritesItemModel> favoriteItems = [];
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
    checkInitialFavorites();
  }

  Future<void> checkInitialFavorites() async {
    isCheckingInitialFavorites = true;
    update();

    // Lógica para verificar os favoritos iniciais
    await getFavoritesItems(canLoad: false);

    isCheckingInitialFavorites = false;
    update();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) return;
    getFavoritesItems();
  }

  Future<void> getAllCategory() async {
    setLoading(true);
    FavoritesResult<List<CategoryModel>> favoritesResult =
        await favoritesRepository.getAllCategories();
    setLoading(false);
    favoritesResult.when(
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

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getFavoritesItems(canLoad: false);
  }

  void filterByTitle() {
    //apagar todas as historias da categoria
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }
    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        // criar nova categoria de todos
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
    currentCategory = currentCategory;
    update();
    getFavoritesItems();
  }

  //remove a historia de meus favoritos
  Future<bool> removeItemTofavorites({
    required FavoritesItemModel item,
  }) async {
    final result = await favoritesRepository.removeItemToFavorites(
      favoriteItemId: item.id,
      token: authController.user.token!,
    );
    if (result) {
      favoriteItems.removeWhere((favoriteItems) => favoriteItems.id == item.id);
      update();

      utilsServices.showToast(
        message: 'historia removida de seus favoritos',
      );
    } else {
      utilsServices.showToast(
        message: 'ocorreu um erro ao desfavoritar a historia',
        isError: true,
      );
    }
    return result;
  }
  // Dentro da classe FavoritesController

  Future<void> getFavoritesItems({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    final result = await favoritesRepository.getFavoritesItems(
      /* page: currentCategory!.pagination,
      itemPerPage: itemPerPage,*/
      token: authController.user.token!,
      userId: authController.user.id!,
      categoryId: searchTitle.value.isNotEmpty ? null : currentCategory!.id,
      title: searchTitle.value.isNotEmpty ? searchTitle.value : null,
    );

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        favoriteItems = data;
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

  Future<void> addItemToFavorites({required ItemModel item}) async {
    final FavoritesResult<String> result =
        await favoritesRepository.addItemToFavorites(
      token: authController.user.token!,
      userId: authController.user.id!,
      productId: item.id,
    );

    result.when(success: (favoriteItemId) {
      favoriteItems.add(
        FavoritesItemModel(
          id: favoriteItemId,
          item: item,
          //  pagination: 0,
        ),
      );
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });

    update();
  }

  Future<int> getTotalFavoritesCount() async {
    int totalCount = 0;

    for (var category in allCategories) {
      int categoryCount = 0;

      if (currentCategory != null && category.id == currentCategory!.id) {
        categoryCount = category.items.length;
      } else {
        categoryCount =
            await getFavoritesItemCount(categoryId: category.id, title: null);
      }

      totalCount += categoryCount;
    }

    return totalCount;
  }

  Future<int> getFavoritesItemCount({
    String? categoryId,
    String? title,
  }) async {
    final result = await favoritesRepository.getFavoritesItems(
      /* page: 0,
      itemPerPage: 100,*/
      token: authController.user.token!,
      userId: authController.user.id!,
      categoryId: null,
      title: title,
    );

    return result.when<int>(
      success: (data) => data.length,
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        return 0;
      },
    );
  }
}
