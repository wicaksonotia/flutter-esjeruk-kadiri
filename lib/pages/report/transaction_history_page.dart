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

  // ==============================================================
  // PRINT PDF
  // ==============================================================

  Future<void> _printPdf() async {
    try {
      final controller = _transactionController;

      if (controller.transactionItems.isEmpty) {
        Get.snackbar(
          'Report',
          'Tidak ada transaksi untuk dicetak',
          icon: const Icon(Icons.info_outline_rounded, color: MyColors.info),
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: MyColors.primary)),
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

      await Printing.layoutPdf(
        onLayout: (format) async {
          return pdf.save();
        },
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Gagal membuat PDF: $e',
        icon: const Icon(Icons.error_outline_rounded, color: MyColors.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),

      backgroundColor: MyColors.background,

      bottomNavigationBar: const FooterReport(),

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        foregroundColor: MyColors.textOnPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,

        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: MyColors.textOnPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -.15,
          ),
        ),

        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: 'Menu',
              splashRadius: 22,
              icon: const Icon(
                Icons.menu_rounded,
                color: MyColors.textOnPrimary,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        actions: [
          IconButton(
            tooltip: 'Cetak PDF',
            splashRadius: 22,
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
              color: MyColors.textOnPrimary,
            ),
            onPressed: _printPdf,
          ),
          const SizedBox(width: 4),
        ],

        // ========================================================
        // TERRACOTTA ACCENT
        // ========================================================
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 34,
              height: 3,
              decoration: BoxDecoration(
                color: MyColors.accent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ),

      // ==========================================================
      // CONTENT
      // ==========================================================
      body: SafeArea(
        child: Column(
          children: [
            _buildFilter(),

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

  // ==============================================================
  // FILTER
  // ==============================================================

  Widget _buildFilter() {
    return Container(
      color: MyColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        children: [
          _buildFilterCategory(),

          const SizedBox(height: 8),

          _buildFilterDate(),
        ],
      ),
    );
  }

  // ==============================================================
  // FILTER CATEGORY
  // ==============================================================

  Widget _buildFilterCategory() {
    return Obx(
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
          // ======================================================
          // NORMAL CHIP
          // ======================================================

          foregroundStyle: const TextStyle(
            color: MyColors.textSecondary,
            fontSize: MySizes.fontSizeSm,
            fontWeight: FontWeight.w600,
          ),

          color: MyColors.surfaceSoft,

          borderRadius: BorderRadius.circular(12),

          // ======================================================
          // SELECTED CHIP
          // ======================================================
          selectedStyle: C2ChipStyle(
            backgroundColor: MyColors.accentLight,

            borderRadius: BorderRadius.circular(12),

            foregroundStyle: const TextStyle(
              color: MyColors.accentDark,
              fontSize: MySizes.fontSizeSm,
              fontWeight: FontWeight.w700,
            ),

            borderColor: MyColors.accent.withValues(alpha: .30),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // FILTER DATE
  // ==============================================================

  Widget _buildFilterDate() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Obx(() {
        final filterBy = _transactionController.filterBy.value;

        return filterBy == 'bulan'
            ? FilterMonth(transactionController: _transactionController)
            : FilterDateRange(transactionController: _transactionController);
      }),
    );
  }
}
