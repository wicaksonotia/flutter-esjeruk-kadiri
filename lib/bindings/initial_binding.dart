import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/controllers/product_category.dart';
import 'package:esjerukkadiri/controllers/product_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() async {
    // Get.lazyPut<LoginController>(() => LoginController());
    Get.put<LoginController>(LoginController());
    Get.put<ProductCategoryController>(ProductCategoryController());
    Get.put<ProductController>(ProductController());
    Get.put<CartController>(CartController());
    Get.put<PrintNotaController>(PrintNotaController());
  }
}
