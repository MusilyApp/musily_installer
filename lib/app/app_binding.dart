import 'package:get/get.dart';
import 'modules/installer/installer_controller.dart';
import 'modules/updater/updater_controller.dart';
import 'modules/uninstaller/uninstaller_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InstallerController());
    Get.lazyPut(() => UpdaterController());
    Get.lazyPut(() => UninstallerController());
  }
}
