import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/controller/cape_product_controller.dart';

class CapeProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CapeProductController());
  }
}
