import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:get/get.dart';

class KasirBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<KasirController>(() => KasirController(), fenix: true);
  }
}
