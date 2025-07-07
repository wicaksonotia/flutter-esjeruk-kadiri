import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/models/transaction_history_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
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
      Get.snackbar(
        'Notification',
        'Printer not connected',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
      // var macPrinterAddress = "86:67:7A:49:4E:11";
      // PrintBluetoothThermal.pairedBluetooths.then((devices) {
      //   PrintBluetoothThermal.connect(
      //     macPrinterAddress: macPrinterAddress,
      //   ).then((connected) {
      //     // if (!connected) {
      //     //   Get.snackbar('Notification', 'Failed to connect to printer',
      //     //       icon: const Icon(Icons.error),
      //     //       snackPosition: SnackPosition.TOP);
      //     // } else {
      //     PrintBluetoothThermal.writeBytes(nota);
      //     // PrintBluetoothThermal.writeBytes(nota).then((result) {
      //     //   if (!result) {
      //     //     Get.snackbar('Notification', 'Failed to print',
      //     //         icon: const Icon(Icons.error),
      //     //         snackPosition: SnackPosition.TOP);
      //     //   }
      //     // });
      //     // }
      //   });
      //   // for (var device in devices) {
      //   //   if (device.name == macPrinterAddress) {
      //   //     PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress)
      //   //         .then((connected) {
      //   //       if (connected) {
      //   //         PrintBluetoothThermal.writeBytes(nota);
      //   //       } else {
      //   //         print('Failed to connect to printer');
      //   //       }
      //   //     });
      //   //     break;
      //   //   }
      //   // }
      // });
    }
  }

  Future<List<int>> printPurchaseOrder(int transactionId) async {
    List<int> bytes = [];
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
    String? kiosName = prefs.getString('kios')?.replaceAll(r'\n', '\n');
    bytes += generator.text(
      '$kiosName',
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
        bold: true,
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
    bytes += generator.feed(1);

    var result = await RemoteDataSource.getDetailTransaction({
      "id_transaction": transactionId,
    });
    transactionDetailItems.value = result!.details ?? [];
    for (var cartItem in transactionDetailItems) {
      bytes += generator.row([
        PosColumn(
          text: cartItem.productName ?? 'Unknown Product',
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
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.feed(1);
    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    // bytes += generator.qrcode('https://www.instagram.com/esjeruk.kadiri/');
    bytes += generator.hr();
    bytes += generator.text(
      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Kasir: ${prefs.getString('nama_kasir')}',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(2);

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
