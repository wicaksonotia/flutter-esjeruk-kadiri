import 'package:cashier/bindings/kasir_binding.dart';
import 'package:cashier/login_page.dart';
import 'package:cashier/bluetooth_setting.dart';
import 'package:cashier/pages/checkout/checkout_page.dart';
import 'package:cashier/pages/report/transaction_daily_page.dart';
import 'package:cashier/pages/report/transaction_history_page.dart';
import 'package:cashier/pages/sop/sop_page.dart';
import 'package:cashier/pages/user/change_password_page.dart';
import 'package:cashier/pages/user/profile_page.dart';
import 'package:cashier/pages/user/user_setting.dart';
import 'package:cashier/pages/product/product_page.dart';
import 'package:cashier/controllers/splash_controller.dart';
import 'package:cashier/splash_page.dart';
import 'package:get/get.dart';

class RouterClass {
  static String splash = "/splash";
  static String login = "/login";
  static String product = "/product";
  static String dailytransactions = "/dailytransactions";
  static String transactionhistories = "/transactionhistories";
  static String bluetoothSetting = "/bluetooth_setting";
  static String checkoutPage = '/checkout_page';

  // USER SETTING
  static String userSetting = "/user_setting";
  static String changePassword = "/change_password";
  static String profile = "/profile";
  static String sopDocument = "/sop_document";

  static List<GetPage> routes = [
    // ============================================================
    // SPLASH
    // ============================================================

    GetPage(
      page: () => const SplashPage(),
      name: splash,
      binding: BindingsBuilder(() {
        Get.put<SplashController>(SplashController(), permanent: true);
      }),
    ),

    // ============================================================
    // LOGIN
    // ============================================================
    GetPage(page: () => const LoginPage(), name: login),

    // ============================================================
    // PRODUCT
    // ============================================================
    GetPage(
      page: () => const ProductPage(),
      name: product,
      binding: BindingsBuilder(() {
        KasirBinding().dependencies();
      }),
    ),

    // ============================================================
    // TRANSACTIONS
    // ============================================================
    GetPage(page: () => const TransactionDailyPage(), name: dailytransactions),

    GetPage(
      page: () => const TransactionHistoryPage(),
      name: transactionhistories,
    ),

    // ============================================================
    // BLUETOOTH
    // ============================================================
    GetPage(page: () => const BluetoothSetting(), name: bluetoothSetting),

    // ============================================================
    // CHECKOUT
    // ============================================================
    GetPage(page: () => const CheckoutPage(), name: checkoutPage),

    // ============================================================
    // USER SETTING
    // ============================================================
    GetPage(page: () => const UserSetting(), name: userSetting),

    GetPage(page: () => const ChangePassword(), name: changePassword),

    GetPage(page: () => const ProfilePage(), name: profile),

    GetPage(page: () => const SopPage(), name: sopDocument),
  ];
}
