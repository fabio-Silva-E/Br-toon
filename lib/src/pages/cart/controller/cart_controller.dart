import 'package:brasiltoon/src/models/cart_coin_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/cart/cart_result/cart_result.dart';
import 'package:brasiltoon/src/pages/cart/repository/cart_repository.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();
  List<CartCoinModel> cartCoins = [];
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
        print(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
