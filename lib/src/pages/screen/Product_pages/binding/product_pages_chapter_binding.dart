import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';

class ProductPagesChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductPagesChapterController());
  }
}
