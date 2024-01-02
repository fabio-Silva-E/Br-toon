import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/result/product_pages_chapter_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class ProductPagesChapterRepository {
  final HttpManager _httpManager = HttpManager();
  Future<ProductPagesChapterResult<ChapterItemModel>> getAllChapterId() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllChapters,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      List<ChapterItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(ChapterItemModel.fromJson)
              .toList();
      return ProductPagesChapterResult<ChapterItemModel>.success(data);
    } else {
      return ProductPagesChapterResult.error(
          'ocorreu um erro inesperado ao recuperar os capitulos da historia');
    }
  }

  Future<ProductPagesChapterResult<PagesChapterItemModel>> getAllPages(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllPages,
      method: HttpMethods.post,
      body: body,
    );
    if (result['result'] != null) {
      List<PagesChapterItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(PagesChapterItemModel.fromJson)
              .toList();
      return ProductPagesChapterResult<PagesChapterItemModel>.success(data);
    } else {
      return ProductPagesChapterResult.error(
          'ocorreu um erro inesperado ao recuperar as paginas do capitulo');
    }
  }
}
