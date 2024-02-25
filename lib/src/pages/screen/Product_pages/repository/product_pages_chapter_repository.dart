import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/repository/product_pages_error.dart'
    as Errors;
import 'package:brasiltoon/src/pages/screen/Product_pages/result/product_pages_chapter_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class ProductPagesChapterRepository {
  final HttpManager _httpManager = HttpManager();
  ProductPagesChapterResult<String> handleSucessOrError(
      Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      return ProductPagesChapterResult<String>.success(
        'Paginas liberadas com sucesso!',
      );
    } else {
      return ProductPagesChapterResult<String>.error(
          Errors.pagesErrorString(result['error']));
    }
  }

  Future<ProductPagesChapterResult<List<ChapterItemModel>>>
      getAllChapterId() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllChapters,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      List<ChapterItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(ChapterItemModel.fromJson)
              .toList();
      return ProductPagesChapterResult<List<ChapterItemModel>>.success(data);
    } else {
      return ProductPagesChapterResult.error(
          'ocorreu um erro inesperado ao recuperar os capitulos da historia');
    }
  }

  Future<ProductPagesChapterResult<List<PagesChapterItemModel>>> getAllPages(
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
      return ProductPagesChapterResult.success(data);
    } else {
      return ProductPagesChapterResult.error(
          'ocorreu um erro inesperado ao recuperar as paginas do capitulo');
    }
  }

  Future<Map<String, dynamic>> pagesCount({
    required String user,
    required String token,
    required String chapterId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getPageCount,
      method: HttpMethods.post,
      body: {
        'user': user,
        'chapterId': chapterId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );
    if (result['result'] != null) {
      return {
        'itemCount':
            result['result']['itemCount'] as int, // Retorna itemCount como int
        'message': result['result']['message']
            as String, // Retorna a mensagem separadamente
      };
    } else {
      throw Exception('erro ao recuperar as paginas');
    }
  }

  Future<ProductPagesChapterResult> addPagesCount({
    required String user,
    required String token,
    required String chapterId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.addPageCount,
      method: HttpMethods.post,
      body: {
        'user': user,
        'chapterId': chapterId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );
    return handleSucessOrError(result);
  }
}
