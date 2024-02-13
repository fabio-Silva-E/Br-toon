import 'package:brasiltoon/src/models/category_favorite_model.dart';
import 'package:brasiltoon/src/models/favoritecount_models.dart';
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/home/repository/home_repository.dart';
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
  final homeRepository = HomeRepository();
  bool isCategoryloading = false;
  bool isCheckingInitialFavorites =
      true; // Adicione esta variável para rastrear o estado de checagem inicial
  final homeController = Get.find<HomeController>();
  bool isProductloading = true;
  List<CategoryModelFavorite> allCategories = [];
  List<CategoryModelFavorite> getallCategories = [];
  CategoryModelFavorite? currentCategory;
  // CategoryModelFavorite? currentCategoryOfHome;
//  CategoryModelFavorite? categoryAll ;
  List<FavoritesItemModel> get allProducts => currentCategory?.favorites ?? [];
  RxString searchTitle = ''.obs;
  // List<FavoritesItemModel> allFavorites = [];
  List<FavoritesCountItemModel> favoritesCount = [];
  List<FavoritesItemModel> favoriteItems = [];
  final authController = Get.find<AuthController>();
  List<ItemModel> items = [];
  List<FavoritesItemModel> favorites = [];
  CategoryModel? currentCategoryofItem;
  bool get isLastPage {
    if (currentCategory!.favorites.length < itemPerPage) return true;
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
    // checkInitialFavorites();
    //  getAllFavoritesItems();
    // getAllProducts();
    // isItemFavorite();
    //getTotalFavoritesCount();
    //  updateFavoritesCount();
  }

  void selectCategory(CategoryModelFavorite category) {
    // category.id = homeController.currentCategory!.id;
    currentCategory = category;
    //  currentCategory!.id = homeController.currentCategory!.id;
    update();
    if (currentCategory!.favorites.isNotEmpty) {
      return;
    }
    getFavoritesItems();
  }

  Future<void> getAllCategory() async {
    setLoading(true);
    FavoritesResult<List<CategoryModelFavorite>> favoritesResult =
        await favoritesRepository.getAllFavoritesCategories();
    setLoading(false);
    favoritesResult.when(
      success: (data) {
        allCategories.assignAll(data);
        getallCategories = data;

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

  List<FavoritesItemModel> get allFavorites {
    List<FavoritesItemModel> allFavorites = [];
    for (var category in getallCategories) {
      allFavorites.addAll(category.favorites);
    }

    return allFavorites;
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getFavoritesItems(canLoad: false);
  }

  void filterByTitle() {
    //apagar todas as historias da categoria
    for (var category in allCategories) {
      category.favorites.clear();
      category.pagination = 0;
    }
    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModelFavorite? c =
          allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        // criar nova categoria de todos
        final allProductsCategory = CategoryModelFavorite(
          title: 'todos',
          id: '',
          favorites: [],
          pagination: 0,
        );
        allCategories.insert(0, allProductsCategory);
      } else {
        c.favorites.clear();
        c.pagination = 0;
      }
    }
    currentCategory = allCategories.first;
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
      // Remove o item dos favoritos locais
      favorites.removeWhere((favoriteItems) => favoriteItems.id == item.id);
      // Remove o item da lista de favoritos do controller
      currentCategory!.favorites
          .removeWhere((favItem) => favItem.id == item.id);
      // Atualiza a tela
      getAllFavoritesItems();
      update();
      //   await getFavoritesItems();
      utilsServices.showToast(
        message: 'história removida de seus favoritos',
      );
    } else {
      utilsServices.showToast(
        message: 'ocorreu um erro ao desfavoritar a história',
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

    final FavoritesResult<List<FavoritesItemModel>> result =
        await favoritesRepository.getFavoritesItems(
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
        currentCategory!.favorites.addAll(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<List<FavoritesCountItemModel>> getAllFavoritesItems() async {
    final FavoritesResult<List<FavoritesCountItemModel>> result =
        await favoritesRepository.getAllFavoritesItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    return result.when(
      success: (data) {
        favoritesCount = data;
        update();
        //  print('favoritos $favoritesCount');
        return data; // Retorna a lista de favoritos
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        return []; // Retorna uma lista vazia em caso de erro
      },
    );
  }

  /* Future<List<ItemModel>> getAllProducts() async {
    final HomeResult<ItemModel> result = await homeRepository.getProducts();

    return result.when(
      success: (data) {
        update();
        //  print('favoritos $favoritesCount');
        return data; // Retorna a lista de favoritos
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        return []; // Retorna uma lista vazia em caso de erro
      },
    );
  }*/

  Future<void> addItemToFavorites({
    required ItemModel item,
    // required String categoryId,
  }) async {
    // Obtenha a categoria correspondente ao ID
    CategoryModelFavorite? category = allCategories.firstWhereOrNull(
        (cat) => cat.id == homeController.currentCategory!.id);

    if (category != null) {
      final FavoritesResult<String> result =
          await favoritesRepository.addItemToFavorites(
        token: authController.user.token!,
        userId: authController.user.id!,
        productId: item.id,
      );

      result.when(
        success: (favoriteItemId) {
          // Adiciona o novo item aos favoritos locais
          final newFavoriteItem = FavoritesItemModel(
            id: favoriteItemId,
            item: item,
            pagination: 0,
          );
          getAllCategory();

          // Adiciona o novo item à lista de favoritos da categoria correspondente
          category.favorites.add(newFavoriteItem);

          getAllFavoritesItems();
          update();
        },
        error: (message) {
          utilsServices.showToast(
            message: message,
            isError: true,
          );
        },
      );
    } else {
      utilsServices.showToast(
        message: 'Categoria não encontrada',
        isError: true,
      );
    }
  }

  Future<bool> isItemFavorite(ItemModel item) async {
    List<FavoritesCountItemModel> favoritesCount = await getAllFavoritesItems();
    // print('favoritados ${favoriteItems.length}');
    // print('items $item');

    bool isFavorite = favoritesCount
        .any((favoriteItem) => favoriteItem.product.id == item.id);
    //print('isFavorite: $isFavorite');

    return isFavorite;
  }

  /* Future<bool> isItemFavorite() async {
    List<FavoritesItemModel> favoriteItems =
        await getAllFavoritesItems(); // Espera pela conclusão da função
    List<ItemModel> items = await getAllProducts();

    update();
    print('favoritados ${favoriteItems.length}');
    print('items ${items.length}');
    return items.any((item) =>
        favoriteItems.any((favoriteItem) => item.id == favoriteItem.item.id));
  }*/
}
