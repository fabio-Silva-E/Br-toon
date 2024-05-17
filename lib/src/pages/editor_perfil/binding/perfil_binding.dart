import 'package:brasiltoon/src/pages/editor_perfil/controller/perfil_controller.dart';
import 'package:get/get.dart';

class PerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PerfilController());
  }
}
