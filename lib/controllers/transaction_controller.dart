import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  var transactionItems = <TransactionModel>[].obs;
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoading = true.obs;
  var isLoadingDetail = true.obs;
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
      var result = await RemoteDataSource.getHistoryTransactions(
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

  void removeTransaction(int numerator, String kios) async {
    try {
      isLoading(true);
      var result = await RemoteDataSource.deleteTransaction(numerator, kios);
      if (result) {
        fetchTransaction();
        Get.snackbar('Notification', 'Transaction deleted',
            icon: const Icon(Icons.info), snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Notification', 'Error delete transaction',
            icon: const Icon(Icons.info), snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading(false);
    }
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
