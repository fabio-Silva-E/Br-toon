import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/favorites/controller/favorietes_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoritesController());
  }
}
