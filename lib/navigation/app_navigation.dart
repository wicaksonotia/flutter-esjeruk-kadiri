import 'package:esjerukkadiri/login_page.dart';
import 'package:esjerukkadiri/bluetooth_setting.dart';
import 'package:esjerukkadiri/pages/product/checkout_page.dart';
import 'package:esjerukkadiri/pages/report/transaction.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/pages/product/product.dart';

class RouterClass {
  static String login = "/login";
  static String product = "/product";
  static String reporttransaction = "/reporttransaction";
  static String bluetoothSetting = "/bluetooth_setting";
  static String checkoutPage = '/checkout_page';

  static List<GetPage> routes = [
    GetPage(page: () => const LoginPage(), name: login),
    GetPage(page: () => const ProductPage(), name: product),
    GetPage(page: () => const TransactionPage(), name: reporttransaction),
    GetPage(page: () => const BluetoothSetting(), name: bluetoothSetting),
    GetPage(page: () => const CheckoutPage(), name: checkoutPage),
  ];
}
