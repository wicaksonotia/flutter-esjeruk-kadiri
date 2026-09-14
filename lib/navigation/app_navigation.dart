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
import 'package:get/get.dart';
import 'package:cashier/pages/product/product_page.dart';

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
  static String sopDocument = "/sop_document";

  static List<GetPage> routes = [
    GetPage(page: () => const LoginPage(), name: login),
    GetPage(
      page: () => const ProductPage(),
      name: product,
      binding: BindingsBuilder(() {
        KasirBinding().dependencies();
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
    GetPage(page: () => const SopPage(), name: sopDocument),
  ];
}
