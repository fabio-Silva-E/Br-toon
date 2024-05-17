import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/result/publish_chapter_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class ChapterRepository {
  final HttpManager _httpManager = HttpManager();

  Future<ChapterResult<String>> publishChapter({
    required String userId,
    required String token,
    required String title,
    required String cape,
    required String productId,
    required String description,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.publishChapter,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'title': title,
          'cape': cape,
          'product': productId,
          'description': description,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      return ChapterResult.success(result['result']['id']);
      //   print('id ');
    } else {
      return ChapterResult.error('Não foi posivel publicar este capitulo');
    }
  }
}
