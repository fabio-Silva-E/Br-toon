import 'package:brasiltoon/src/models/cart_coin_models.dart';
import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:brasiltoon/src/models/order_model.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/cart/cart_result/cart_result.dart';
import 'package:brasiltoon/src/pages/cart/repository/cart_repository.dart';
import 'package:brasiltoon/src/pages/common_widgets/payment_dialog.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();
  List<CartCoinModel> cartCoins = [];
  bool isCheckoutLoading = false;
  @override
  void onInit() {
    super.onInit();
    getCarCoins();
  }

  double cartTotalPrice() {
    double total = 0;
    for (final item in cartCoins) {
      total += item.totalPrice();
    }
    return total;
  }

  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }

  Future checkoutCart() async {
    setCheckoutLoading(true);

    CartResult<OrderModel> result = await cartRepository.checkoutCart(
      token: authController.user.token!,
      total: cartTotalPrice(),
    );

    setCheckoutLoading(false);

    result.when(
      success: (order) {
        cartCoins.clear();
        update();

        showDialog(
          context: Get.context!,
          builder: (_) {
            return PaymentDialog(
              order: order,
            );
          },
        );
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
        );
      },
    );
  }

  Future<bool> changeCoinQuantity({
    required CartCoinModel coin,
    required int quantity,
  }) async {
    final result = await cartRepository.changeCoinQuantity(
      token: authController.user.token!,
      cartItemId: coin.id,
      quantity: quantity,
    );
    if (result) {
      if (quantity == 0) {
        cartCoins.removeWhere((cartCoin) => cartCoin.id == coin.id);
      } else {
        cartCoins.firstWhere((cartCoin) => cartCoin.id == coin.id).quantity =
            quantity;
      }
      update();
    } else {
      utilsServices.showToast(
        message: 'Ocorreu um erro ao alterar a quantidade das moedas',
        isError: true,
      );
    }
    return result;
  }

  Future<void> getCarCoins() async {
    final CartResult<List<CartCoinModel>> result =
        await cartRepository.getCartCoins(
      token: authController.user.token!,
      userId: authController.user.id!,
    );
    result.when(
      success: (data) {
        cartCoins = data;
        update();
        //  print(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  int getCoinIndex(CoinModel coin) {
    return cartCoins.indexWhere((coinInList) => coinInList.coin.id == coin.id);
  }

  Future<void> addCoinToCart(
      {required CoinModel coin, int quantity = 1}) async {
    int coinIndex = getCoinIndex(coin);
    if (coinIndex >= 0) {
      final coin = cartCoins[coinIndex];
      await changeCoinQuantity(
          coin: coin, quantity: (coin.quantity + quantity));

      //cartCoins[coinIndex].quantity += quantity;
    } else {
      final CartResult<String> result = await cartRepository.addCoinToCard(
        token: authController.user.token!,
        userId: authController.user.id!,
        quantity: quantity,
        coinId: coin.id,
      );
      result.when(success: (cartCoinId) {
        cartCoins.add(
          CartCoinModel(
            id: cartCoinId,
            coin: coin,
            quantity: quantity,
          ),
        );
      }, error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      });
    }
    update();
  }

  int getCartTotalCoins() {
    return cartCoins.isEmpty
        ? 0
        : cartCoins.map((e) => e.quantity).reduce((a, b) => a + b);
  }
}
