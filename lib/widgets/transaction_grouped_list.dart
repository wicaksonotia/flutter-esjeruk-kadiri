import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/print_nota_controller.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class TransactionGroupedList extends StatelessWidget {
  final List<dynamic> items;
  final bool isLoading;

  /// Mengaktifkan aksi hapus transaksi.
  ///
  /// Biasanya:
  /// - Daily = true
  /// - History = false
  final bool enableDelete;

  /// Mengaktifkan aksi print transaksi.
  ///
  /// Biasanya:
  /// - Daily = true
  /// - History = true
  final bool enablePrint;

  /// Menampilkan jumlah item dan omzet pada header tanggal.
  ///
  /// Biasanya:
  /// - Daily = false
  /// - History = true
  final bool showSummary;

  /// Nama kasir yang sedang login.
  ///
  /// Digunakan untuk menentukan apakah transaksi boleh dihapus.
  final String cashierName;

  final Future<void> Function() onRefresh;

  const TransactionGroupedList({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    this.enableDelete = false,
    this.enablePrint = false,
    this.showSummary = false,
    this.cashierName = '',
  });

  // ==============================================================
  // GROUP DATA
  // ==============================================================

  Map<String, List<dynamic>> _groupData() {
    final Map<String, List<dynamic>> grouped = {};

    for (final item in items) {
      final transactionDate = DateTime.parse(item.transactionDate);

      final key = DateFormat('dd MMMM yyyy', 'id_ID').format(transactionDate);

      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped;
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoading();
    }

    if (items.isEmpty) {
      return _buildEmpty();
    }

    final grouped = _groupData();

    final keys = grouped.keys.toList();
    final values = grouped.values.toList();

    return _buildGroupedList(keys, values);
  }

  // ==============================================================
  // LOADING
  // ==============================================================

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5,
        itemBuilder: (_, index) {
          return _buildLoadingItem(index);
        },
      ),
    );
  }

  Widget _buildLoadingItem(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: index.isEven ? 180 : 140,
                  height: 14,
                  color: Colors.white,
                ),

                const Gap(10),

                Container(width: 120, height: 11, color: Colors.white),

                const Gap(7),

                Container(width: 160, height: 11, color: Colors.white),
              ],
            ),
          ),

          const Gap(10),

          Container(width: 80, height: 14, color: Colors.white),
        ],
      ),
    );
  }

  // ==============================================================
  // EMPTY
  // ==============================================================

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: Get.height * .70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty_cart.png', height: 100),

                const Gap(16),

                const Text(
                  'No transaction yet',
                  style: TextStyle(fontSize: MySizes.fontSizeXl),
                ),

                const Gap(8),

                const Text(
                  'Pull down to refresh',
                  style: TextStyle(color: MyColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // GROUPED LIST
  // ==============================================================

  Widget _buildGroupedList(List<String> keys, List<List<dynamic>> values) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GroupListView(
        physics: const AlwaysScrollableScrollPhysics(),

        sectionsCount: keys.length,

        countOfItemInSection: (section) {
          return values[section].length;
        },

        // ==========================================================
        // GROUP HEADER
        // ==========================================================
        groupHeaderBuilder: (_, section) {
          final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(keys[section]);

          final dayItems = values[section];

          return _buildDateHeader(date: date, dayItems: dayItems);
        },

        // ==========================================================
        // ITEM SEPARATOR
        // ==========================================================
        separatorBuilder: (_, _) {
          return const SizedBox(height: 2);
        },

        // ==========================================================
        // SECTION SEPARATOR
        // ==========================================================
        sectionSeparatorBuilder: (_, _) {
          return const SizedBox(height: 20);
        },

        // ==========================================================
        // ITEM
        // ==========================================================
        itemBuilder: (_, index) {
          final item = values[index.section][index.index];

          return _buildTransactionItem(item);
        },
      ),
    );
  }

  // ==============================================================
  // DATE HEADER
  // ==============================================================

  Widget _buildDateHeader({
    required DateTime date,
    required List<dynamic> dayItems,
  }) {
    final int totalItem = _calculateTotalItem(dayItems);

    final int totalOmzet = _calculateTotalOmzet(dayItems);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          // --------------------------------------------------------
          // DATE NUMBER
          // --------------------------------------------------------

          Text(
            DateFormat('dd').format(date),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const Gap(10),

          // --------------------------------------------------------
          // DAY + MONTH
          // --------------------------------------------------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('EEEE', 'id_ID').format(date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    if (showSummary) ...[
                      const Gap(5),

                      Text(
                        '[$totalItem items]',
                        style: const TextStyle(
                          color: MyColors.grey,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ],
                ),

                Text(
                  DateFormat('MMMM yyyy', 'id_ID').format(date),
                  style: const TextStyle(
                    color: MyColors.grey,
                    fontSize: MySizes.fontSizeSm,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------------
          // OMZET
          // --------------------------------------------------------
          if (showSummary) _buildOmzetBadge(totalOmzet),
        ],
      ),
    );
  }

  Widget _buildOmzetBadge(int totalOmzet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        CurrencyFormat.convertToIdr(totalOmzet, 0),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==============================================================
  // SUMMARY
  // ==============================================================

  int _calculateTotalItem(List<dynamic> dayItems) {
    return dayItems.where((item) => !item.deleteStatus).fold<int>(0, (
      sum,
      item,
    ) {
      final details = item.details as List<dynamic>? ?? [];

      final int detailQty = details.fold<int>(0, (detailSum, detail) {
        final int qty = (detail.quantity as num?)?.toInt() ?? 0;

        return detailSum + qty;
      });

      return sum + detailQty;
    });
  }

  int _calculateTotalOmzet(List<dynamic> dayItems) {
    return dayItems.where((item) => !item.deleteStatus).fold<int>(0, (
      sum,
      item,
    ) {
      final int grandTotal = (item.grandTotal as num?)?.toInt() ?? 0;

      return sum + grandTotal;
    });
  }

  // ==============================================================
  // TRANSACTION ITEM
  // ==============================================================

  Widget _buildTransactionItem(dynamic item) {
    final bool canDelete =
        enableDelete && !item.deleteStatus && item.cashierName == cashierName;

    final bool canPrint = enablePrint;

    final bool canSlide = canDelete || canPrint;

    final Widget tile = _transactionTile(item);

    if (!canSlide) {
      return tile;
    }

    return _buildSlidable(
      item: item,
      tile: tile,
      canDelete: canDelete,
      canPrint: canPrint,
    );
  }

  // ==============================================================
  // SLIDABLE
  // ==============================================================

  Widget _buildSlidable({
    required dynamic item,
    required Widget tile,
    required bool canDelete,
    required bool canPrint,
  }) {
    final printController = Get.find<PrintNotaController>();

    final trxController = Get.find<TransactionController>();

    final List<Widget> actions = [];

    // ------------------------------------------------------------
    // DELETE
    // ------------------------------------------------------------

    if (canDelete) {
      actions.add(
        SlidableAction(
          onPressed: (_) {
            trxController.removeTransaction(item.id);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      );
    }

    // ------------------------------------------------------------
    // PRINT
    // ------------------------------------------------------------

    if (canPrint) {
      actions.add(
        SlidableAction(
          onPressed: (_) {
            printController.printTransaction(item.id);
          },
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.print,
          label: 'Print',
        ),
      );
    }

    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: actions,
      ),
      child: tile,
    );
  }

  // ==============================================================
  // TRANSACTION TILE
  // ==============================================================

  Widget _transactionTile(dynamic item) {
    final bool isDeleted = item.deleteStatus == true;

    return Container(
      color: Colors.white,
      child: ExpansionTile(
        iconColor: MyColors.primary,

        // ----------------------------------------------------------
        // TITLE
        // ----------------------------------------------------------
        title: Text(
          'HIMALAYA/'
          '${item.branchCode}/'
          '${item.numerator.toString().padLeft(4, '0')}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // ----------------------------------------------------------
        // SUBTITLE
        // ----------------------------------------------------------
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info(Icons.shopping_cart, 'Total Item: ${item.totalItem}'),

            _info(
              Icons.calendar_month,
              DateFormat(
                'dd MMM yyyy HH:mm',
                'id_ID',
              ).format(DateTime.parse(item.transactionDate)),
            ),

            _info(Icons.person, item.cashierName ?? '-'),
          ],
        ),

        // ----------------------------------------------------------
        // TOTAL
        // ----------------------------------------------------------
        trailing: _buildTransactionTotal(item, isDeleted),

        // ----------------------------------------------------------
        // DETAILS
        // ----------------------------------------------------------
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(10),

                ..._buildDetails(item),

                if (isDeleted) _buildDeleteStatus(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // TRANSACTION TOTAL
  // ==============================================================

  Widget _buildTransactionTotal(dynamic item, bool isDeleted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyFormat.convertToIdr(item.grandTotal, 0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDeleted ? MyColors.red : MyColors.primary,
          ),
        ),

        Text(
          item.paymentMethod ?? 'Cash',
          style: const TextStyle(
            color: MyColors.grey,
            fontSize: MySizes.fontSizeSm,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // DETAILS
  // ==============================================================

  List<Widget> _buildDetails(dynamic item) {
    final details = item.details as List<dynamic>? ?? [];

    if (details.isEmpty) {
      return [
        const Text(
          'Tidak ada detail transaksi',
          style: TextStyle(color: MyColors.grey),
        ),
      ];
    }

    return details.map<Widget>((detail) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            // ------------------------------------------------------
            // PRODUCT
            // ------------------------------------------------------

            Expanded(flex: 5, child: Text(detail.productName ?? '-')),

            // ------------------------------------------------------
            // QTY
            // ------------------------------------------------------
            Expanded(
              flex: 1,
              child: Center(child: Text('${detail.quantity ?? 0}')),
            ),

            // ------------------------------------------------------
            // PRICE
            // ------------------------------------------------------
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(CurrencyFormat.convertToIdr(detail.totalPrice, 0)),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // ==============================================================
  // DELETE STATUS
  // ==============================================================

  Widget _buildDeleteStatus(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MyColors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MyColors.red.withValues(alpha: 0.25)),
        ),
        child: Text(
          'Transaksi dibatalkan\n'
          'Alasan: ${item.deleteReason ?? '-'}',
          style: const TextStyle(
            color: MyColors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // INFO ROW
  // ==============================================================

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MyColors.grey),

        const Gap(5),

        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: MyColors.grey,
              fontSize: MySizes.fontSizeSm,
            ),
          ),
        ),
      ],
    );
  }
}
