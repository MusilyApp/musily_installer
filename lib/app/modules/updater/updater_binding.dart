import 'package:get/get.dart';
import 'updater_controller.dart';

class UpdaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdaterController>(() => UpdaterController());
  }
}
