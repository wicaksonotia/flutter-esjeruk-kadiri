import 'package:cashier/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      getPages: RouterClass.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      initialRoute: RouterClass.login,
    );
  }
}
