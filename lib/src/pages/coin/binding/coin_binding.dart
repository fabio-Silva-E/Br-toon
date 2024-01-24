import 'package:brasiltoon/src/pages/coin/controller/coin_controller.dart';
import 'package:get/get.dart';

class CoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CoinController());
  }
}
