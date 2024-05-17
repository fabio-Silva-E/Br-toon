import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/gallery_models.dart';
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

  Future<ProductChapterResult<GalleryModel>> getAllGalleryChapter() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllGalleryChapter,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      //lista
      List<GalleryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(GalleryModel.fromJson)
              .toList();
      return ProductChapterResult<GalleryModel>.success(data);
    } else {
      //Erro
      return ProductChapterResult.error(
          'ocorreu um erro inesperado ao recuperar as capas');
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

  Future<int> chapterCount({
    required String user,
    required String token,
    required String productId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getChapterCount,
      method: HttpMethods.post,
      body: {
        'user': user,
        'productId': productId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );
    if (result['result'] != null) {
      return result['result']['itemCount'];
    } else {
      throw Exception('erro ao recuperar  as paginas');
    }
  }
}
