import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/transaction_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  var transactionItems = <Data>[].obs;
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoading = true.obs;
  var isLoadingDetail = true.obs;
  var total = 0.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var filterBy = 'bulan'.obs;
  var initMonth = DateTime.now().month.obs;
  var initYear = DateTime.now().year.obs;
  var isSideBarOpen = false.obs;
  var totalCup = 0.obs;

  @override
  void onInit() {
    fetchTransaction();
    super.onInit();
  }

  void fetchTransaction() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var kios = prefs.getString('username');
      TransactionModel? result;
      if (filterBy.value == 'bulan') {
        var data = {
          'monthYear': '${initMonth.value}-${initYear.value}',
          'kios': kios,
        };
        result = await RemoteDataSource.transactionHistoryByMonth(data);
      } else {
        var data = {
          'startDate': startDate.value,
          'endDate': endDate.value,
          'kios': kios,
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
      isLoading(false);
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
    // monthYear.value =
    //     "${startMonth.value.month.toString()}-${startMonth.value.year.toString()}";
    // fetchData();
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
