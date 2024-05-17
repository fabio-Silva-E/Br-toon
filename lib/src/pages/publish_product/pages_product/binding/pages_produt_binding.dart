import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/controller/pages_product_controller.dart';

class PagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishPageController(chapterId: ''));
  }
}
