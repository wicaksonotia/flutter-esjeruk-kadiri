import 'package:esjerukkadiri/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:esjerukkadiri/navigation/app_navigation.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: RouterClass.product,
    );
  }
}
