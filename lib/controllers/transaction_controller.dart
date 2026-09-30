import 'package:cashier/commons/colors.dart';
import 'package:cashier/models/cart_model.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:cashier/widgets/delete_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  // ============================================================
  // DATA
  // ============================================================

  final dailyTransactionItems = <TransactionModel>[].obs;

  final transactionItems = <TransactionModel>[].obs;

  List<CartModel> cartList = <CartModel>[].obs;

  // ============================================================
  // LOADING
  // ============================================================

  final isLoadingDailyTransaction = true.obs;

  final isLoadingTransactionHistory = true.obs;

  final isLoadingDetail = true.obs;

  // ============================================================
  // DAILY SUMMARY
  // ============================================================

  final dailyTotal = 0.obs;

  final dailyTotalCup = 0.obs;

  // ============================================================
  // HISTORY SUMMARY
  // ============================================================

  final historyTotal = 0.obs;

  final historyTotalCup = 0.obs;

  // ============================================================
  // FILTER
  // ============================================================

  final startDate = DateTime.now().obs;

  final endDate = DateTime.now().obs;

  final filterBy = 'bulan'.obs;

  final initMonth = DateTime.now().month.obs;

  final initYear = DateTime.now().year.obs;

  // ============================================================
  // OTHER
  // ============================================================

  final isSideBarOpen = false.obs;

  final namaKasir = ''.obs;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    getNamaKasir();
  }

  // ============================================================
  // GET NAMA KASIR
  // ============================================================

  Future<void> getNamaKasir() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      namaKasir.value = prefs.getString('nama_kasir') ?? '';
    } catch (error) {
      debugPrint('TransactionController.getNamaKasir: $error');
    }
  }

  // ============================================================
  // REFRESH SETELAH GANTI OUTLET
  // ============================================================

  Future<void> refreshAfterOutletChanged() async {
    try {
      // ========================================================
      // CLEAR DATA OUTLET LAMA
      // ========================================================

      dailyTransactionItems.clear();

      transactionItems.clear();

      dailyTotal.value = 0;

      dailyTotalCup.value = 0;

      historyTotal.value = 0;

      historyTotalCup.value = 0;

      // ========================================================
      // REFRESH NAMA KASIR
      // ========================================================

      await getNamaKasir();

      // ========================================================
      // LOAD DAILY + HISTORY BERSAMAAN
      // ========================================================

      await Future.wait([fetchDailyTransactions(), fetchTransaction()]);
    } catch (error) {
      debugPrint('TransactionController.refreshAfterOutletChanged: $error');
    }
  }

  // ============================================================
  // DAILY TRANSACTIONS
  // ============================================================

  Future<void> fetchDailyTransactions() async {
    try {
      isLoadingDailyTransaction(true);

      final prefs = await SharedPreferences.getInstance();

      final kios = prefs.getInt('id_kios') ?? 0;

      final cabang = prefs.getInt('id_cabang') ?? 0;

      final kasir = prefs.getInt('id_kasir') ?? 0;

      // ========================================================
      // REQUEST
      // ========================================================

      final data = {
        'startDate': DateTime.now().toString(),
        'endDate': DateTime.now().toString(),
        'id_kios': kios,
        'id_cabang': cabang,
        'id_kasir': kasir,
      };

      final result = await RemoteDataSource.transactionHistoryByDateRange(data);

      // ========================================================
      // RESULT
      // ========================================================

      if (result != null && result.data != null) {
        dailyTransactionItems.assignAll(result.data!);

        dailyTotalCup.value = result.totalCup ?? 0;

        dailyTotal.value = dailyTransactionItems
            .where((item) => item.deleteStatus == false)
            .fold(0, (sum, item) => sum + (item.grandTotal ?? 0));
      } else {
        dailyTransactionItems.clear();

        dailyTotal.value = 0;

        dailyTotalCup.value = 0;
      }
    } catch (error) {
      debugPrint('TransactionController.fetchDailyTransactions: $error');

      // ========================================================
      // JANGAN TINGGALKAN DATA LAMA SAAT REQUEST GAGAL
      // ========================================================

      dailyTransactionItems.clear();

      dailyTotal.value = 0;

      dailyTotalCup.value = 0;

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

  // ============================================================
  // TRANSACTION HISTORY
  // ============================================================

  Future<void> fetchTransaction() async {
    try {
      isLoadingTransactionHistory(true);

      final prefs = await SharedPreferences.getInstance();

      final kios = prefs.getInt('id_kios') ?? 0;

      final cabang = prefs.getInt('id_cabang') ?? 0;

      final kasir = prefs.getInt('id_kasir') ?? 0;

      TransactionHistoryModel? result;

      // ========================================================
      // FILTER BULAN
      // ========================================================

      if (filterBy.value == 'bulan') {
        final data = {
          'monthYear': '${initMonth.value}-${initYear.value}',
          'id_kios': kios,
          'id_cabang': cabang,
          'id_kasir': kasir,
        };

        result = await RemoteDataSource.transactionHistoryByMonth(data);
      }
      // ========================================================
      // FILTER RANGE TANGGAL
      // ========================================================
      else {
        final data = {
          'startDate': startDate.value.toString(),
          'endDate': endDate.value.toString(),
          'id_kios': kios,
          'id_cabang': cabang,
          'id_kasir': kasir,
        };

        result = await RemoteDataSource.transactionHistoryByDateRange(data);
      }

      // ========================================================
      // RESULT
      // ========================================================

      if (result != null && result.data != null) {
        transactionItems.assignAll(result.data!);

        historyTotalCup.value = result.totalCup ?? 0;

        historyTotal.value = transactionItems
            .where((item) => item.deleteStatus == false)
            .fold(0, (sum, item) => sum + (item.grandTotal ?? 0));
      } else {
        transactionItems.clear();

        historyTotal.value = 0;

        historyTotalCup.value = 0;
      }
    } catch (error) {
      debugPrint('TransactionController.fetchTransaction: $error');

      // ========================================================
      // CLEAR DATA HISTORY JIKA REQUEST GAGAL
      // ========================================================

      transactionItems.clear();

      historyTotal.value = 0;

      historyTotalCup.value = 0;

      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingTransactionHistory(false);
    }
  }

  // ============================================================
  // REMOVE TRANSACTION
  // ============================================================

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

  // ============================================================
  // DELETE TRANSACTION
  // ============================================================

  Future<void> _deleteTransaction({
    required int transactionId,
    required String reason,
  }) async {
    try {
      isLoadingDailyTransaction(true);

      final rawFormat = {'id_transaction': transactionId, 'reason': reason};

      final result = await RemoteDataSource.deleteTransaction(rawFormat);

      if (result) {
        // ======================================================
        // DAILY
        // ======================================================

        await fetchDailyTransactions();

        // ======================================================
        // HISTORY JUGA REFRESH
        // ======================================================

        await fetchTransaction();

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

  // ============================================================
  // SNACKBAR SUCCESS
  // ============================================================

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: MyColors.surface,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyColors.primary,
      colorText: MyColors.surface,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  // ============================================================
  // SNACKBAR ERROR
  // ============================================================

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal',
      message,
      icon: const Icon(Icons.error_outline_rounded, color: MyColors.surface),
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyColors.error,
      colorText: MyColors.surface,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
    );
  }

  // ============================================================
  // MONTH FILTER
  // ============================================================

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

  // ============================================================
  // DATE RANGE FILTER
  // ============================================================

  Future<void> showDialogDateRangePicker() async {
    final pickedDate = await showDateRangePicker(
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
              onPrimary: MyColors.surface,
              outlineVariant: Colors.grey.shade200,
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

      await fetchTransaction();
    }
  }
}
