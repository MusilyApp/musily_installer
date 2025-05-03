import 'package:get/get.dart';
import 'installer_controller.dart';

class InstallerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstallerController>(() => InstallerController());
  }
}
