import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put<LoginController>(LoginController());
  }
}
