import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/publishers/result/publishers_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class PublisherRepository {
  final HttpManager _httpManager = HttpManager();

  Future<PublishersResult<List<CategoryModel>>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return PublishersResult.success(data);
    } else {
      return PublishersResult.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<PublishersResult<List<ItemModel>>> getPublishersItems({
    required int itemPerPage,
    required int page,
    required String token,
    required String userId,
    String? categoryId, // Adicionando categoryId como um parâmetro opcional
    String? title, // Adicionando title como um parâmetro opcional
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getPublishersItems,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'page': page,
        'itemsPerPage': itemPerPage,
        'user': userId,
        'categoryId': categoryId, // Passando o categoryId, se disponível
        'title': title, // Passando o title, se disponível
      },
    );

    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();

      return PublishersResult.success(data);
    } else {
      return PublishersResult.error(
          'Ocorreu um erro ao recuperar suas publicações');
    }
  }
}
