import 'dart:typed_data';

import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/transaction_detail_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

class TransactionController extends GetxController {
  var transactionItems = <TransactionModel>[].obs;
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoading = true.obs;
  var isLoadingDetail = true.obs;
  var expandedIndex = (-1).obs;
  var transactionDetailItems = <TransactionDetailModel>[].obs;
  var total = 0.obs;
  var singleDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var textSingleDate = ''.obs;
  var textStartDate = ''.obs;
  var textEndDate = ''.obs;
  var checkSingleDate = true.obs;

  @override
  void onInit() {
    fetchTransaction();
    super.onInit();
  }

  void fetchTransaction() async {
    try {
      isLoading(true);
      var result = await RemoteDataSource.getTransactions(
        startDate.value,
        endDate.value,
        singleDate.value,
        checkSingleDate.value,
      );
      if (result != null) {
        transactionItems.assignAll(result);
        total.value = transactionItems
            .where((e) => e.deleteStatus == false)
            .map((e) => e.grandTotal ?? 0)
            .fold(0, (value, element) => value + element);
      }
    } finally {
      isLoading(false);
    }
  }

  void getTransactionDetails(int numerator, String kios) async {
    try {
      isLoadingDetail(true);
      var result =
          await RemoteDataSource.getTransactionDetails(numerator, kios);
      if (result != null) {
        transactionDetailItems.assignAll(result);
      }
    } finally {
      isLoadingDetail(false);
    }
  }

  void removeTransaction(int numerator, String kios) async {
    try {
      isLoading(true);
      var result = await RemoteDataSource.deleteTransaction(numerator, kios);
      if (result) {
        fetchTransaction();
        Get.snackbar('Notification', 'Transaction deleted',
            icon: const Icon(Icons.info), snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Notification', 'Error delete transaction',
            icon: const Icon(Icons.info), snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading(false);
    }
  }

  /// ===================================
  /// PRINT TRANSACTION
  /// ===================================
  void printTransaction(int numerator, String kios) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      List<int> nota = await printPurchaseOrder(numerator, kios);
      var resultPrint = await PrintBluetoothThermal.writeBytes(nota);
      if (!resultPrint) {
        Get.snackbar('Notification', 'Failed to print',
            icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Notification', 'Bluetooth not connected',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<int>> printPurchaseOrder(int numerator, String kios) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    // IMAGE
    final ByteData data = await rootBundle.load('assets/images/logo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    final image = decodeImage(bytesImg);
    final resizedImage = copyResize(image!, width: 250);
    bytes += generator.image(resizedImage);

    var result = await RemoteDataSource.getTransactionDetails(numerator, kios);
    transactionDetailItems.assignAll(result!);
    // CART LIST
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
          text: (cartItem.totalPrice).toString(),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: CurrencyFormat.convertToIdr(
            transactionDetailItems
                .map((e) => e.totalPrice)
                .fold(0, (value, element) => value + element!),
            0),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('https://www.instagram.com/esjeruk.kadiri/');
    bytes += generator.text(
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.feed(1);

    // IMAGE
    final ByteData _dataHastag =
        await rootBundle.load('assets/images/hastag.jpg');
    final Uint8List _bytesImgHastag = _dataHastag.buffer.asUint8List();
    final _imageHastag = decodeImage(_bytesImgHastag);
    final _resizedImageHastag = copyResize(_imageHastag!, width: 300);
    bytes += generator.image(_resizedImageHastag);

    bytes += generator.feed(2);
    // bytes += generator.cut();
    return bytes;
  }

  /// ===================================
  /// FILTER DATE
  /// ===================================
  bool disableDate(DateTime day) {
    if ((day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  chooseDate(singleOrstartOrend) async {
    var initialDate = DateTime.now();
    if (singleOrstartOrend == 'single') {
      initialDate = singleDate.value;
    } else if (singleOrstartOrend == 'start') {
      initialDate = startDate.value;
    } else {
      initialDate = endDate.value;
    }
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      cancelText: 'Close',
      confirmText: 'Confirm',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter valid date range',
      fieldHintText: 'Month/Date/Year',
      selectableDayPredicate: disableDate,
    );
    if (pickedDate != null) {
      if (singleOrstartOrend == 'single') {
        if (pickedDate != singleDate.value) {
          singleDate.value = pickedDate;
          textSingleDate.value =
              DateFormat('dd MMMM yyyy').format(singleDate.value);
        }
      } else if (singleOrstartOrend == 'start') {
        if (pickedDate != startDate.value) {
          startDate.value = pickedDate;
          textStartDate.value =
              DateFormat('dd MMMM yyyy').format(startDate.value);
        }
      } else {
        if (pickedDate != endDate.value) {
          endDate.value = pickedDate;
          textEndDate.value = DateFormat('dd MMMM yyyy').format(endDate.value);
        }
      }
    }
  }
}
