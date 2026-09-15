import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:get/get.dart';

class KasirBinding implements Bindings {
  @override
  void dependencies() {
    // ============================================================
    // CART
    // ============================================================
    Get.put<CartController>(CartController(), permanent: false);
    // ============================================================
    // KASIR
    // ============================================================
    Get.put<KasirController>(KasirController(), permanent: false);
    // ============================================================
    // PRODUCT
    // ============================================================
    Get.put<ProductController>(ProductController(), permanent: false);
  }
}
