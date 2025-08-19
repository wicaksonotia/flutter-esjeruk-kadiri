import 'package:cashier/commons/colors.dart';
import 'package:cashier/models/cart_model.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
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
        total.value = transactionItems.fold(
          0,
          (sum, item) => sum + (item.grandTotal ?? 0),
        );
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

  void removeTransaction(int transactionId) async {
    TextEditingController reasonController = TextEditingController();
    bool confirm =
        (await showDialog<bool>(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Hapus Transaksi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Apakah Anda yakin ingin menghapus transaksi ini?',
                  ),
                  TextField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Alasan penghapusan',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Konfirmasi'),
                ),
              ],
            );
          },
        )) ??
        false;

    if (confirm) {
      String reason = reasonController.text.trim();
      if (reason.isEmpty) {
        Get.snackbar(
          'Error',
          'Mohon isi alasan penghapusan',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      try {
        isLoadingDailyTransaction(true);
        var rawFormat = {'id_transaction': transactionId, 'reason': reason};
        var result = await RemoteDataSource.deleteTransaction(rawFormat);
        if (result) {
          fetchTransaction();
          Get.snackbar(
            'Notification',
            'Transaksi berhasil dihapus',
            icon: const Icon(Icons.info),
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            'Notification',
            'Error menghapus transaksi',
            icon: const Icon(Icons.info),
            snackPosition: SnackPosition.TOP,
          );
        }
      } finally {
        isLoadingDailyTransaction(false);
      }
    }
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
