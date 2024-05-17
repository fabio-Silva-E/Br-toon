import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/cart_coin_models.dart';
import 'package:brasiltoon/src/models/order_model.dart';
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
          'ocorreu um erro ao recuperar as moedas do carrinho');
    }
  }

  Future<bool> changeCoinQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changeCoinQuantity,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'cartItemId': cartItemId,
          'quantity': quantity,
        });
    return result.isEmpty;
  }

  Future<CartResult<String>> addCoinToCard({
    required String token,
    required String userId,
    required int quantity,
    required String coinId,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.addCoinToCart,
      method: HttpMethods.post,
      body: {
        'user': userId,
        'quantity': quantity,
        'coinId': coinId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      return CartResult<String>.success(result['result']['id']);
    } else {
      return CartResult.error('oNão foi possivel adicionar moedas ao carrinho');
    }
  }

  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.checkout,
      method: HttpMethods.post,
      body: {
        'total': total,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      final order = OrderModel.fromJson(result['result']);

      return CartResult<OrderModel>.success(order);
    } else {
      return CartResult.error('Não possível realizar o pedido');
    }
  }
}
