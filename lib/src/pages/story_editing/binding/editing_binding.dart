import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:get/get.dart';

class EditingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditingController());
  }
}
