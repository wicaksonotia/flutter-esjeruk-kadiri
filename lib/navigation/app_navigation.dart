import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/controllers/product_controller.dart';
import 'package:esjerukkadiri/login_page.dart';
import 'package:esjerukkadiri/bluetooth_setting.dart';
import 'package:esjerukkadiri/pages/product/checkout_page.dart';
import 'package:esjerukkadiri/pages/report/transaction_daily_page.dart';
import 'package:esjerukkadiri/pages/report/transaction_history_page.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/pages/product/product.dart';

class RouterClass {
  static String login = "/login";
  static String product = "/product";
  static String dailytransactions = "/dailytransactions";
  static String transactionhistories = "/transactionhistories";
  static String bluetoothSetting = "/bluetooth_setting";
  static String checkoutPage = '/checkout_page';

  static List<GetPage> routes = [
    GetPage(page: () => const LoginPage(), name: login),
    GetPage(
      page: () => const ProductPage(),
      name: product,
      binding: BindingsBuilder(() {
        Get.put<ProductController>(ProductController());
        Get.put<CartController>(CartController());
      }),
    ),
    GetPage(page: () => const TransactionDailyPage(), name: dailytransactions),
    GetPage(
      page: () => const TransactionHistoryPage(),
      name: transactionhistories,
    ),
    GetPage(page: () => const BluetoothSetting(), name: bluetoothSetting),
    GetPage(page: () => const CheckoutPage(), name: checkoutPage),
  ];
}
