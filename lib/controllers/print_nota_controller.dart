import 'package:cashier/commons/currency.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintNotaController extends GetxController {
  var transactionDetailItems = <ListDetailTransactionModel>[].obs;

  /// ===================================
  /// PRINT TRANSACTION
  /// ===================================
  void printTransaction(int transactionId) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    List<int> nota = await printPurchaseOrder(transactionId);
    if (connectionStatus) {
      PrintBluetoothThermal.writeBytes(nota);
      // if (!resultPrint) {
      //   Get.snackbar('Notification', 'Failed to print',
      //       icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      // }
    } else {
      // Get.snackbar(
      //   'Notification',
      //   'Printer not connected',
      //   icon: const Icon(Icons.error),
      //   snackPosition: SnackPosition.TOP,
      // );
      var printerName = "RPP02N";
      // Get all paired devices with the name "RPP02N"
      final pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      final rpp02nDevices =
          pairedDevices.where((device) => device.name == printerName).toList();

      // Try to connect to the first available/active device
      bool connected = false;
      for (var device in rpp02nDevices) {
        connected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress,
        );
        if (connected) {
          PrintBluetoothThermal.writeBytes(nota);
          break;
        }
      }

      if (!connected) {
        Get.snackbar(
          'Notification',
          'No active RPP02N printer found or unable to connect.',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<List<int>> printPurchaseOrder(int transactionId) async {
    List<int> bytes = [];
    var result = await RemoteDataSource.getDetailTransaction({
      "id_transaction": transactionId,
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    // IMAGE
    // final ByteData data = await rootBundle.load('assets/images/logo.jpg');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // final image = img.decodeImage(bytesImg);
    // final resizedImage = img.copyResize(image!, width: 300);
    // bytes += generator.image(resizedImage);

    // HEADER
    String? kiosName = prefs
        .getString('kios')
        ?.toUpperCase()
        .replaceAll(r'\n', '\n');
    bytes += generator.text(
      '$kiosName',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    );
    String? keteranganPrint = prefs
        .getString('keterangan_print')
        ?.replaceAll(r'\n', '\n');
    bytes += generator.text(
      '$keteranganPrint',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: true,
      ),
    );
    String? cabangKios = prefs.getString('cabang')?.replaceAll(r'\n', '\n');
    bytes += generator.text(
      'cabang - $cabangKios',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: false,
      ),
    );
    bytes += generator.feed(1);

    // ALAMAT
    String? kiosAddress = prefs
        .getString('alamat_cabang')
        ?.replaceAll(r'\n', '\n');
    bytes += generator.text(
      '$kiosAddress',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(2);

    bytes += generator.row([
      PosColumn(
        text: 'Numerator',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: result!.numerator.toString().padLeft(4, '0'),
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Waktu',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Operator',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: prefs.getString('nama_kasir') ?? '-',
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();

    transactionDetailItems.value = result.details ?? [];
    for (var cartItem in transactionDetailItems) {
      bytes += generator.row([
        PosColumn(
          text: cartItem.productName ?? '-',
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: cartItem.quantity.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text:
              (CurrencyFormat.convertToIdr(cartItem.totalPrice, 0)).toString(),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Subtotal',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.convertToIdr(
          transactionDetailItems
              .map((e) => e.totalPrice ?? 0)
              .fold<int>(0, (value, element) => value + element),
          0,
        ),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Discount',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.convertToIdr((result.discount ?? 0), 0),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.convertToIdr((result.grandTotal ?? 0), 0),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
    ]);
    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    // bytes += generator.qrcode('https://www.instagram.com/esjeruk.kadiri/');
    bytes += generator.hr();
    bytes += generator.feed(1);
    bytes += generator.text(
      'Pendapat Anda sangat penting',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'bagi kami. Untuk kritik & saran',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'silakan hubungi :',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      '0857-5512-4535',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.feed(3);

    // IMAGE
    // final ByteData dataHastag = await rootBundle.load(
    //   'assets/images/hastag.jpg',
    // );
    // final Uint8List bytesImgHastag = dataHastag.buffer.asUint8List();
    // final imageHastag = img.decodeImage(bytesImgHastag);
    // final resizedImageHastag = img.copyResize(imageHastag!, width: 300);
    // bytes += generator.image(resizedImageHastag);
    // bytes += generator.cut();
    return bytes;
  }
}
