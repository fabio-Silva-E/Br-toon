import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/controller/product_chapter_controller.dart';

class ProductChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductChapterController());
  }
}
