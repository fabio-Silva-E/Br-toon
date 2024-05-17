import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:brasiltoon/src/models/coin_of_user_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/coin/repository/coin_repository.dart';
import 'package:brasiltoon/src/pages/coin/result/coin_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

const int itemPerPage = 6;

class CoinController extends GetxController {
  final cointRepository = CoinRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();
  List<CoinModel> coins = [];
  List<CoinOfUserModel> coinsUser = [];
  // RxBool isloading = false.obs;
  void setLoading(bool value) {}
  @override
  void onInit() {
    super.onInit();
    getAllCoins();
    getCoinOfUser();
  }

  Future<void> getAllCoins() async {
    setLoading(true);
    Map<String, dynamic> body = {'itemsPerPage': itemPerPage};
    CoinResult<CoinModel> result = await cointRepository.getAllCoins(body);
    setLoading(false);
    result.when(
      success: (data) {
        // print(data);
        coins = data;
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> getCoinOfUser() async {
    setLoading(true);
    final CoinResult<CoinOfUserModel> result =
        await cointRepository.getCoinOfUser(
      token: authController.user.token!,
      userId: authController.user.id!,
    );
    setLoading(false);
    result.when(
      success: (data) {
        //  print('moedas do usuario $data');
        coinsUser = data;
        update();
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
