import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/print_nota_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/database/app_database.dart';
import 'package:cashier/services/sync_service.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // ==========================================================
    // LOCAL DATABASE
    // ==========================================================

    Get.put<AppDatabase>(AppDatabase(), permanent: true);

    // ==========================================================
    // SYNC SERVICE
    // ==========================================================

    Get.put<SyncService>(SyncService(), permanent: true);

    // ==========================================================
    // PRINT NOTA
    // ==========================================================

    Get.put<PrintNotaController>(PrintNotaController(), permanent: true);

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
