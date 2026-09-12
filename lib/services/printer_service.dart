import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterService {
  static const printerMacKey = 'selected_printer_mac';

  static Future<bool> ensureConnected() async {
    final connected = await PrintBluetoothThermal.connectionStatus;

    if (connected) return true;

    final prefs = await SharedPreferences.getInstance();
    final mac = prefs.getString(printerMacKey);

    if (mac == null) return false;

    return await PrintBluetoothThermal.connect(macPrinterAddress: mac);
  }

  static Future<void> print(List<int> bytes) async {
    final ready = await ensureConnected();

    if (!ready) {
      Get.snackbar(
        'Printer',
        'Printer belum dipilih atau tidak terhubung',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await PrintBluetoothThermal.writeBytes(bytes);
  }

  static Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }
}
