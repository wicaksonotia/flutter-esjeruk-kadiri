import 'package:cashier/commons/colors.dart';
import 'package:cashier/models/cart_model.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:cashier/widgets/delete_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  var dailyTransactionItems = <TransactionModel>[].obs;
  var transactionItems = <TransactionModel>[].obs;
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoadingDailyTransaction = true.obs;
  var isLoadingTransactionHistory = true.obs;
  var isLoadingDetail = true.obs;
  var total = 0.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var filterBy = 'bulan'.obs;
  var initMonth = DateTime.now().month.obs;
  var initYear = DateTime.now().year.obs;
  var isSideBarOpen = false.obs;
  var totalCup = 0.obs;
  var namaKasir = ''.obs;

  @override
  void onInit() {
    getNamaKasir();
    super.onInit();
  }

  void getNamaKasir() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    namaKasir.value = prefs.getString('nama_kasir')!;
  }

  Future<void> fetchDailyTransactions() async {
    try {
      isLoadingDailyTransaction(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var kios = prefs.getInt('id_kios');
      var cabang = prefs.getInt('id_cabang');
      var kasir = prefs.getInt('id_kasir');
      TransactionHistoryModel? result;
      var data = {
        'startDate': DateTime.now().toString(),
        'endDate': DateTime.now().toString(),
        'id_kios': kios,
        'id_cabang': cabang,
        'id_kasir': kasir,
      };
      result = await RemoteDataSource.transactionHistoryByDateRange(data);
      if (result != null && result.data != null) {
        totalCup.value = result.totalCup ?? 0;
        dailyTransactionItems.assignAll(result.data!);

        total.value = dailyTransactionItems
            .where((item) => item.deleteStatus == false)
            .fold(0, (sum, item) => sum + (item.grandTotal ?? 0));
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingDailyTransaction(false);
    }
  }

  Future<void> fetchTransaction() async {
    try {
      isLoadingTransactionHistory(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var kios = prefs.getInt('id_kios');
      var cabang = prefs.getInt('id_cabang');
      var kasir = prefs.getInt('id_kasir');
      TransactionHistoryModel? result;
      if (filterBy.value == 'bulan') {
        var data = {
          'monthYear': '${initMonth.value}-${initYear.value}',
          'id_kios': kios,
          'id_cabang': cabang,
          'id_kasir': kasir,
        };
        result = await RemoteDataSource.transactionHistoryByMonth(data);
      } else {
        var data = {
          'startDate': startDate.value.toString(),
          'endDate': endDate.value.toString(),
          'id_kios': kios,
          'id_cabang': cabang,
          'id_kasir': kasir,
        };
        result = await RemoteDataSource.transactionHistoryByDateRange(data);
      }
      if (result != null && result.data != null) {
        totalCup.value = result.totalCup ?? 0;
        transactionItems.assignAll(result.data!);
        total.value = transactionItems
            .where((item) => item.deleteStatus == false)
            .fold(0, (sum, item) => sum + (item.grandTotal ?? 0));
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
      isLoadingTransactionHistory(false);
    } finally {
      isLoadingTransactionHistory(false);
    }
  }

  Future<void> removeTransaction(int transactionId) async {
    final String? reason = await Get.dialog<String>(
      const DeleteTransactionDialog(),
      barrierDismissible: true,
    );

    if (reason == null || reason.trim().isEmpty) {
      return;
    }

    await _deleteTransaction(
      transactionId: transactionId,
      reason: reason.trim(),
    );
  }
  // ==============================================================
  // DELETE CONFIRMATION
  // ==============================================================

  // ==============================================================
  // DELETE TRANSACTION
  // ==============================================================

  Future<void> _deleteTransaction({
    required int transactionId,
    required String reason,
  }) async {
    try {
      isLoadingDailyTransaction(true);

      final rawFormat = {'id_transaction': transactionId, 'reason': reason};

      final result = await RemoteDataSource.deleteTransaction(rawFormat);

      if (result) {
        await fetchDailyTransactions();

        _showSuccessSnackbar('Transaksi berhasil dibatalkan');
      } else {
        _showErrorSnackbar('Transaksi gagal dibatalkan');
      }
    } catch (error) {
      _showErrorSnackbar(error.toString());
    } finally {
      isLoadingDailyTransaction(false);
    }
  }

  // ==============================================================
  // SNACKBAR
  // ==============================================================

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal',
      message,
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyColors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
    );
  }

  /// ===================================
  /// FILTER DATE, MONTH
  /// ===================================
  void nextOrPreviousMonth(bool isNext) {
    if (isNext) {
      initMonth.value++;
      if (initMonth.value > 12) {
        initMonth.value = 1;
        initYear.value++;
      }
    } else {
      initMonth.value--;
      if (initMonth.value < 1) {
        initMonth.value = 12;
        initYear.value--;
      }
    }
  }

  void showDialogDateRangePicker() async {
    var pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              // onSurfaceVariant: MyColors.green,
              outline: Colors.grey.shade300,
              secondaryContainer: Colors.green.shade50,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      startDate.value = pickedDate.start;
      endDate.value = pickedDate.end;
      fetchTransaction();
    }
  }
}
