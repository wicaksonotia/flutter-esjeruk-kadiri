import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final RxBool isLoading = true.obs;

  final RxDouble progress = 0.0.obs;

  final RxString loadingText = 'Menyiapkan aplikasi...'.obs;

  @override
  void onReady() {
    super.onReady();

    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      isLoading.value = true;

      // ==========================================================
      // 1. CHECK SESSION
      // ==========================================================

      loadingText.value = 'Memeriksa sesi...';

      progress.value = 0.15;

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final bool isLogin = prefs.getBool('statusLogin') ?? false;

      await Future.delayed(const Duration(milliseconds: 150));

      // ==========================================================
      // BELUM LOGIN
      // ==========================================================

      if (!isLogin) {
        progress.value = 1.0;

        await Future.delayed(const Duration(milliseconds: 200));

        Get.offAllNamed(RouterClass.login);

        return;
      }

      // ==========================================================
      // 2. LOAD PROFILE
      // ==========================================================

      loadingText.value = 'Memuat data kasir...';

      progress.value = 0.35;

      final LoginController loginController = Get.find<LoginController>();

      await loginController.checkProfile();

      await Future.delayed(const Duration(milliseconds: 150));

      // ==========================================================
      // 3. LOAD PRODUCT
      // ==========================================================

      loadingText.value = 'Memuat menu produk...';

      progress.value = 0.55;

      final ProductController productController = Get.find<ProductController>();

      await productController.loadInitialData();

      progress.value = 0.85;

      // ==========================================================
      // 4. FINISH
      // ==========================================================

      loadingText.value = 'Menyiapkan kasir...';

      await Future.delayed(const Duration(milliseconds: 250));

      progress.value = 1.0;

      await Future.delayed(const Duration(milliseconds: 250));

      // ==========================================================
      // 5. PRODUCT PAGE
      // ==========================================================

      Get.offAllNamed(RouterClass.product);
    } catch (error, stackTrace) {
      debugPrint('========================================');

      debugPrint('SPLASH INITIALIZATION ERROR');

      debugPrint('ERROR: $error');

      debugPrint('STACK: $stackTrace');

      debugPrint('========================================');

      // ==========================================================
      // FAIL SAFE
      // ==========================================================

      Get.offAllNamed(RouterClass.login);
    } finally {
      isLoading.value = false;
    }
  }
}
