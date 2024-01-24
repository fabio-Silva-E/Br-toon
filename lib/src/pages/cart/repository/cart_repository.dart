import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/cart_coin_models.dart';
import 'package:brasiltoon/src/pages/cart/cart_result/cart_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();
  Future<CartResult<List<CartCoinModel>>> getCartCoins({
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
      List<CartCoinModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartCoinModel.fromJson)
              .toList();
      return CartResult<List<CartCoinModel>>.success(data);
    } else {
      return CartResult.error(
          'ocorreu um erro ao recuperar as moedads do carrinho');
    }
  }
}
