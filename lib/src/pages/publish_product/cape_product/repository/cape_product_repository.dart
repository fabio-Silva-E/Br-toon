//import 'dart:io';

import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/result/cape_product_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class CapeProductRepository {
  final HttpManager _httpManager = HttpManager();

  Future<CapeProductResult<List<CategoryModel>>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return CapeProductResult.success(data);
    } else {
      return CapeProductResult.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<CapeProductResult<String>> publishCover({
    required String userId,
    required String token,
    required String title,
    required String cape,
    required String description,
    required String category,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.publishCape,
        method: HttpMethods.post,
        body: {
          'user': userId,
          "title": title,
          "cape": cape,
          "description": description,
          "category": category
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      return CapeProductResult.success(result['result']['id']);
      //   print('id ');
    } else {
      return CapeProductResult.error(
          'Não foi posivel publicar esta capa para historia');
    }
  }
}
