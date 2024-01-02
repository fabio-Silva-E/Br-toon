import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publishers/controller/publishers_contoller.dart';

class PublishersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublisherController());
  }
}
