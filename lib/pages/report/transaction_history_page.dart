import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/lists.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/pages/report/filter_date_range.dart';
import 'package:cashier/pages/report/filter_month.dart';
import 'package:cashier/pages/report/footer.dart';
import 'package:cashier/pages/report/transaction_report_pdf_service.dart';
import 'package:cashier/widgets/transaction_grouped_list.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => TransactionHistoryPageState();
}

class TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TransactionController _transactionController = Get.put(
    TransactionController(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transactionController.fetchTransaction();
    });
  }

  Future<void> _refresh() async {
    await _transactionController.fetchTransaction();
  }

  Future<void> _printPdf() async {
    try {
      final controller = _transactionController;

      if (controller.transactionItems.isEmpty) {
        Get.snackbar(
          'Report',
          'Tidak ada transaksi untuk dicetak',
          icon: const Icon(Icons.info),
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final pdf = await TransactionReportPdfService.generate(
        transactions: controller.transactionItems.toList(),
        filterBy: controller.filterBy.value,
        month: controller.initMonth.value,
        year: controller.initYear.value,
        startDate: controller.startDate.value,
        endDate: controller.endDate.value,
      );

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Gagal membuat PDF: $e',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      bottomNavigationBar: const FooterReport(),
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cetak PDF',
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _printPdf,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterCategory(),
            _buildFilterDate(),
            Expanded(
              child: Obx(
                () => TransactionGroupedList(
                  items: _transactionController.transactionItems,
                  isLoading:
                      _transactionController.isLoadingTransactionHistory.value,

                  enableDelete: false,
                  enablePrint: true,
                  showSummary: true,

                  cashierName: _transactionController.namaKasir.value,

                  onRefresh: _refresh,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCategory() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
      child: Obx(
        () => ChipsChoice<String>.single(
          value: _transactionController.filterBy.value,
          wrapped: true,
          padding: EdgeInsets.zero,
          onChanged: (value) {
            _transactionController.filterBy.value = value;
            _transactionController.fetchTransaction();
          },
          choiceItems: C2Choice.listFrom<String, Map<String, dynamic>>(
            source: filterKategori,
            value: (_, item) => item['value'] as String,
            label: (_, item) => item['nama'] as String,
          ),
          choiceStyle: C2ChipStyle.filled(
            foregroundStyle: const TextStyle(fontSize: MySizes.fontSizeSm),
            color: MyColors.notionBgGrey,
            borderRadius: BorderRadius.circular(25),
            selectedStyle: const C2ChipStyle(
              backgroundColor: MyColors.red,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDate() {
    return Container(
      height: Get.height * .05,
      color: Colors.white,
      child: Obx(() {
        return _transactionController.filterBy.value == 'bulan'
            ? FilterMonth(transactionController: _transactionController)
            : FilterDateRange(transactionController: _transactionController);
      }),
    );
  }
}
