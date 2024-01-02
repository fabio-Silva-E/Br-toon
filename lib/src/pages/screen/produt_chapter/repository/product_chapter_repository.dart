import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/result/product_chapter_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class ProductChapterRepository {
  final HttpManager _httpManager = HttpManager();
  Future<ProductChapterResult<ItemModel>> getAllProductId() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllProducts,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();
      return ProductChapterResult<ItemModel>.success(data);
    } else {
      return ProductChapterResult.error(
          'ocorreu um erro inesperado ao recuperar a historia');
    }
  }

  Future<ProductChapterResult<ChapterItemModel>> getAllChapter(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllChapters,
      method: HttpMethods.post,
      body: body,
    );
    if (result['result'] != null) {
      List<ChapterItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(ChapterItemModel.fromJson)
              .toList();
      return ProductChapterResult<ChapterItemModel>.success(data);
    } else {
      return ProductChapterResult.error(
          'ocorreu um erro inesperado ao recuperar os capitulos');
    }
  }
}
