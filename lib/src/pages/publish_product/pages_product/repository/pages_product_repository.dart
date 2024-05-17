import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/result/pages_product_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class PageRepository {
  final HttpManager _httpManager = HttpManager();
  Future<PageResult<List<PagesChapterItemModel>>> getAllPages(
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
      return PageResult.success(data);
    } else {
      return PageResult.error(
          'ocorreu um erro inesperado ao recuperar as paginas do capitulo');
    }
  }

  Future<PageResult<List<ChapterItemModel>>> getAllChapterId() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllChapters,
      method: HttpMethods.post,
    );
    if (result['result'] != null) {
      List<ChapterItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(ChapterItemModel.fromJson)
              .toList();
      return PageResult<List<ChapterItemModel>>.success(data);
    } else {
      return PageResult.error(
          'ocorreu um erro inesperado ao recuperar os capitulos da historia');
    }
  }

  Future<PageResult<String>> publishPages({
    required String userId,
    required String token,
    required String page,
    required String chapterId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.publishPages,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'page': page,
          'chapter': chapterId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      return PageResult.success(result['result']['id']);
      //   print('id ');
    } else {
      return PageResult.error('Não foi posivel publicar as paginas');
    }
  }
}
