import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/result/pages_product_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class PageRepository {
  final HttpManager _httpManager = HttpManager();
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
