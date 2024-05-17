import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/home/result/home_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      //lista
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return HomeResult<CategoryModel>.success(data);
    } else {
      //Erro
      return HomeResult.error(
          'ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<HomeResult<GalleryModel>> getAllGallery() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllGallery,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      //lista
      List<GalleryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(GalleryModel.fromJson)
              .toList();
      return HomeResult<GalleryModel>.success(data);
    } else {
      //Erro
      return HomeResult.error(
          'ocorreu um erro inesperado ao recuperar as capas');
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllProducts,
      method: HttpMethods.post,
      body: body,
    );
    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();
      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error(
          'ocorreu um erro inesperado ao recuperar os itens');
    }
  }

  Future<HomeResult<ItemModel>> getProducts() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllProducts,
      method: HttpMethods.post,
      body: {
        "page": 0,
        "itemsPerPage": null,
        "title": null,
        "categoryId": null
      },
    );
    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();
      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error(
          'ocorreu um erro inesperado ao recuperar os itens');
    }
  }
}
