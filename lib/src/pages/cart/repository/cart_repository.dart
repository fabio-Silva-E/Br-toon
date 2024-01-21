import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();
  Future gettCartCoins({
    required String token,
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getCartCoins,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'user': userId,
        });

    if (result['result'] != null) {
    } else {}
  }
}
