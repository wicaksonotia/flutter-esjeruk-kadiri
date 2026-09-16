import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // ============================================================
    // CART
    // ============================================================

    Get.put<CartController>(CartController(), permanent: true);

    // ============================================================
    // PRODUCT
    // ============================================================

    Get.put<ProductController>(ProductController(), permanent: true);

    // ============================================================
    // LOGIN
    // ============================================================

    Get.put<LoginController>(LoginController(), permanent: true);
  }
}
