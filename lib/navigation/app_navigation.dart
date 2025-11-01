import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/login_page.dart';
import 'package:cashier/bluetooth_setting.dart';
import 'package:cashier/pages/product/checkout_page.dart';
import 'package:cashier/pages/report/transaction_daily_page.dart';
import 'package:cashier/pages/report/transaction_history_page.dart';
import 'package:cashier/pages/user/change_password_page.dart';
import 'package:cashier/pages/user/profile_page.dart';
import 'package:cashier/pages/user/user_setting.dart';
import 'package:get/get.dart';
import 'package:cashier/pages/product/product.dart';

class RouterClass {
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

  static List<GetPage> routes = [
    GetPage(page: () => const LoginPage(), name: login),
    GetPage(
      page: () => const ProductPage(),
      name: product,
      binding: BindingsBuilder(() {
        Get.put<ProductController>(ProductController());
        Get.put<CartController>(CartController());
        Get.put<KasirController>(KasirController());
      }),
    ),
    GetPage(page: () => const TransactionDailyPage(), name: dailytransactions),
    GetPage(
      page: () => const TransactionHistoryPage(),
      name: transactionhistories,
    ),
    GetPage(page: () => const BluetoothSetting(), name: bluetoothSetting),
    GetPage(page: () => const CheckoutPage(), name: checkoutPage),
    // USER SETTING
    GetPage(page: () => const UserSetting(), name: userSetting),
    GetPage(page: () => const ChangePassword(), name: changePassword),
    GetPage(page: () => const ProfilePage(), name: profile),
  ];
}
