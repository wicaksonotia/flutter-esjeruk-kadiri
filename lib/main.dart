import 'package:esjerukkadiri/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:esjerukkadiri/navigation/app_navigation.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Get.put(prefs);
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
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Automatically attempt to connect to RPP02N on app start
          PrintBluetoothThermal.connectionStatus.then((bool connected) {
            if (!connected) {
              PrintBluetoothThermal.pairedBluetooths.then((devices) {
                for (var device in devices) {
                  if (device.name == "RPP02N") {
                    PrintBluetoothThermal.connect(
                        macPrinterAddress: device.macAdress);
                    break;
                  }
                }
              });
            }
          });
        });
        return child!;
      },
    );
  }
}
