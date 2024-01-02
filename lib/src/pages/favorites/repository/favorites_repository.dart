import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/favorites_models.dart';
import 'package:brasiltoon/src/pages/favorites/result/favorites_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class FavoritesRepository {
  final HttpManager _httpManager = HttpManager();

  Future<FavoritesResult<List<CategoryModel>>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return FavoritesResult.success(data);
    } else {
      return FavoritesResult.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<FavoritesResult<List<FavoritesItemModel>>> getFavoritesItems({
    required String token,
    required String userId,
    String? categoryId, // Adicionando categoryId como um parâmetro opcional
    String? title, // Adicionando title como um parâmetro opcional
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getFavoritesItems,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'user': userId,
        'categoryId': categoryId, // Passando o categoryId, se disponível
        'title': title, // Passando o title, se disponível
      },
    );

    if (result['result'] != null) {
      List<FavoritesItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(FavoritesItemModel.fromJson)
              .toList();

      return FavoritesResult.success(data);
    } else {
      return FavoritesResult.error(
          'Ocorreu um erro ao recuperar as histórias de seus favoritos');
    }
  }

  Future<bool> removeItemToFavorites({
    required String favoriteItemId,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.removeItemToFavorites,
      method: HttpMethods.post,
      body: {
        'favoriteItemId': favoriteItemId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );
    return result.isEmpty;
  }

  Future<FavoritesResult<String>> addItemToFavorites({
    required String userId,
    required String token,
    required String productId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.addItemToFavorites,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'productId': productId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      return FavoritesResult.success(result['result']['id']);
    } else {
      return FavoritesResult.error(
          'Não foi posivel adicionar a historia aos seus favoritos');
    }
  }
}
