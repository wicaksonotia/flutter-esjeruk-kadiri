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
  final bool enableDelete;
  final bool enablePrint;
  final bool showSummary;
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
  // GROUP
  // ==============================================================

  Map<String, List<dynamic>> _groupData() {
    final Map<String, List<dynamic>> grouped = {};

    for (final item in items) {
      final date = DateTime.parse(item.transactionDate);

      final key = DateFormat('dd MMMM yyyy', 'id_ID').format(date);

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
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        itemCount: 5,
        itemBuilder: (_, index) {
          return _buildLoadingCard(index);
        },
      ),
    );
  }

  Widget _buildLoadingCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: index.isEven ? 170 : 130,
                      height: 14,
                      color: Colors.white,
                    ),
                    const Gap(8),
                    Container(width: 110, height: 10, color: Colors.white),
                  ],
                ),
              ),
              Container(width: 75, height: 15, color: Colors.white),
            ],
          ),
          const Gap(16),
          Container(width: double.infinity, height: 1, color: Colors.white),
          const Gap(12),
          Row(
            children: [
              Container(width: 100, height: 10, color: Colors.white),
              const Gap(15),
              Container(width: 90, height: 10, color: Colors.white),
            ],
          ),
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
            height: Get.height * .68,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/images/empty_cart.png'),
                ),

                const Gap(20),

                const Text(
                  'No transaction yet',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeXl,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Gap(6),

                const Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    color: MyColors.grey,
                    fontSize: MySizes.fontSizeSm,
                  ),
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
        // HEADER
        // ==========================================================
        groupHeaderBuilder: (_, section) {
          final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(keys[section]);

          final dayItems = values[section];

          return _buildDateHeader(date, dayItems);
        },

        // ==========================================================
        // ITEM
        // ==========================================================
        itemBuilder: (_, index) {
          final item = values[index.section][index.index];

          return _buildTransactionItem(item);
        },

        separatorBuilder: (_, _) {
          return const Gap(8);
        },

        sectionSeparatorBuilder: (_, _) {
          return const Gap(16);
        },
      ),
    );
  }

  // ==============================================================
  // DATE HEADER
  // ==============================================================

  Widget _buildDateHeader(DateTime date, List<dynamic> transactions) {
    final totalItem = _calculateTotalItem(transactions);
    final totalOmzet = _calculateTotalOmzet(transactions);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DATE BADGE
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('MMM', 'id_ID').format(date).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // DATE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE', 'id_ID').format(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('d MMMM yyyy', 'id_ID').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalItem item',
                  style: TextStyle(
                    fontSize: 11,
                    color: MyColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // DAILY TOTAL
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormat.convertToIdr(totalOmzet, 0),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total hari ini',
                style: TextStyle(fontSize: 10, color: MyColors.grey),
              ),
            ],
          ),
        ],
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

      final detailQty = details.fold<int>(0, (detailSum, detail) {
        final qty = (detail.quantity as num?)?.toInt() ?? 0;

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
      final grandTotal = (item.grandTotal as num?)?.toInt() ?? 0;

      return sum + grandTotal;
    });
  }

  // ==============================================================
  // TRANSACTION ITEM
  // ==============================================================

  Widget _buildTransactionItem(dynamic item) {
    final canDelete =
        enableDelete && !item.deleteStatus && item.cashierName == cashierName;

    final canPrint = enablePrint;

    final canSlide = canDelete || canPrint;

    final tile = _transactionCard(item);

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

    final actions = <Widget>[];

    if (canDelete) {
      actions.add(
        SlidableAction(
          onPressed: (_) {
            trxController.removeTransaction(item.id);
          },
          backgroundColor: MyColors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete_outline_rounded,
          label: 'Delete',
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(16),
          ),
        ),
      );
    }

    if (canPrint) {
      actions.add(
        SlidableAction(
          onPressed: (_) {
            printController.printTransaction(item.id);
          },
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.print_outlined,
          label: 'Print',
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(16),
          ),
        ),
      );
    }

    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: actions.length == 1 ? .24 : .48,
        children: actions,
      ),
      child: tile,
    );
  }

  // ==============================================================
  // TRANSACTION CARD
  // ==============================================================

  Widget _transactionCard(dynamic item) {
    final isDeleted = item.deleteStatus == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDeleted
                  ? MyColors.red.withValues(alpha: .18)
                  : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 8, 14, 8),
          childrenPadding: EdgeInsets.zero,
          iconColor: MyColors.primary,
          collapsedIconColor: MyColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: _buildTransactionHeader(item, isDeleted),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: _buildTransactionMeta(item),
          ),

          trailing: _buildTransactionAmount(item, isDeleted),

          children: [_buildTransactionDetails(item, isDeleted)],
        ),
      ),
    );
  }

  // ==============================================================
  // TRANSACTION HEADER
  // ==============================================================

  Widget _buildTransactionHeader(dynamic item, bool isDeleted) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color:
                isDeleted
                    ? MyColors.red.withValues(alpha: .08)
                    : MyColors.primary.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            isDeleted
                ? Icons.receipt_long_outlined
                : Icons.receipt_long_rounded,
            size: 20,
            color: isDeleted ? MyColors.red : MyColors.primary,
          ),
        ),

        const Gap(10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HIMALAYA/'
                '${item.branchCode}/'
                '${item.numerator.toString().padLeft(4, '0')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  fontWeight: FontWeight.w800,
                ),
              ),

              if (isDeleted) ...[
                const Gap(4),
                _buildStatusBadge('DIBATALKAN', MyColors.red),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // META
  // ==============================================================

  Widget _buildTransactionMeta(dynamic item) {
    return Wrap(
      spacing: 12,
      runSpacing: 5,
      children: [
        _buildMetaItem(Icons.shopping_bag_outlined, '${item.totalItem} item'),

        _buildMetaItem(
          Icons.schedule_outlined,
          DateFormat(
            'HH:mm',
            'id_ID',
          ).format(DateTime.parse(item.transactionDate)),
        ),

        _buildMetaItem(Icons.person_outline_rounded, item.cashierName ?? '-'),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: MyColors.grey),
        const Gap(4),
        Text(
          text,
          style: const TextStyle(
            color: MyColors.grey,
            fontSize: MySizes.fontSizeSm,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // AMOUNT
  // ==============================================================

  Widget _buildTransactionAmount(dynamic item, bool isDeleted) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            CurrencyFormat.convertToIdr(item.grandTotal, 0),
            style: TextStyle(
              fontSize: MySizes.fontSizeMd,
              fontWeight: FontWeight.w800,
              color: isDeleted ? MyColors.red : MyColors.primary,
            ),
          ),

          const Gap(4),

          _buildPaymentBadge(item.paymentMethod ?? 'Cash'),
        ],
      ),
    );
  }

  // ==============================================================
  // PAYMENT BADGE
  // ==============================================================

  Widget _buildPaymentBadge(String paymentMethod) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        paymentMethod,
        style: const TextStyle(
          color: MyColors.grey,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==============================================================
  // STATUS BADGE
  // ==============================================================

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: .3,
        ),
      ),
    );
  }

  // ==============================================================
  // DETAILS
  // ==============================================================

  Widget _buildTransactionDetails(dynamic item, bool isDeleted) {
    final details = item.details as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.notionBgGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt_rounded, size: 17, color: MyColors.primary),
              const Gap(7),
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MySizes.fontSizeSm,
                ),
              ),
            ],
          ),

          const Gap(12),

          _buildDetailHeader(),

          const Gap(4),

          if (details.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tidak ada detail transaksi',
                style: TextStyle(color: MyColors.grey),
              ),
            )
          else
            ..._buildDetails(details),

          if (isDeleted) _buildDeleteStatus(item),
        ],
      ),
    );
  }

  Widget _buildDetailHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Produk',
            style: TextStyle(
              color: MyColors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Qty',
              style: TextStyle(
                color: MyColors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total',
              style: TextStyle(
                color: MyColors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetails(List<dynamic> details) {
    return details.map<Widget>((detail) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                detail.productName ?? '-',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: MySizes.fontSizeSm,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(minWidth: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${detail.quantity ?? 0}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  CurrencyFormat.convertToIdr(detail.totalPrice, 0),
                  style: const TextStyle(
                    fontSize: MySizes.fontSizeSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.red.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: MyColors.red.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: MyColors.red),

          const Gap(8),

          Expanded(
            child: Text(
              'Transaksi dibatalkan\n'
              'Alasan: ${item.deleteReason ?? '-'}',
              style: const TextStyle(
                color: MyColors.red,
                fontSize: MySizes.fontSizeSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
