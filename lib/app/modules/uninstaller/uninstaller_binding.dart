import 'package:get/get.dart';
import 'uninstaller_controller.dart';

class UninstallerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UninstallerController>(() => UninstallerController());
  }
}
