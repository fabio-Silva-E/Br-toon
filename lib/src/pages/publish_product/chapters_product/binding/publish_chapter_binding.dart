import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/controller/publish_chapter_controller.dart';

class ChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishChapterController(productId: ''));
  }
}
