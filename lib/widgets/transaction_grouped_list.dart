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
  final bool enableSlidable;
  final bool showSummary;
  final String cashierName;
  final Future<void> Function() onRefresh;

  const TransactionGroupedList({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    this.enableSlidable = false,
    this.showSummary = false,
    this.cashierName = '',
  });

  Map<String, List<dynamic>> _groupData() {
    final Map<String, List<dynamic>> grouped = {};

    for (final item in items) {
      final key = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(DateTime.parse(item.transactionDate));

      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final printController = Get.find<PrintNotaController>();
    final trxController = Get.find<TransactionController>();

    // ============================================================
    // LOADING
    // ============================================================
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(width: 50, height: 50, color: Colors.white),

                  const Gap(12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        3,
                        (_) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ============================================================
    // EMPTY
    // ============================================================
    if (items.isEmpty) {
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

    // ============================================================
    // GROUP DATA
    // ============================================================
    final grouped = _groupData();

    final keys = grouped.keys.toList();
    final values = grouped.values.toList();

    // ============================================================
    // DATA
    // ============================================================
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GroupListView(
        physics: const AlwaysScrollableScrollPhysics(),

        sectionsCount: keys.length,

        countOfItemInSection: (section) {
          return values[section].length;
        },

        // ========================================================
        // GROUP HEADER
        // ========================================================
        groupHeaderBuilder: (_, section) {
          final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(keys[section]);

          final dayItems = values[section];

          // ------------------------------------------------------
          // TOTAL ITEM
          // ------------------------------------------------------
          final int totalItem = dayItems
              .where((e) => !e.deleteStatus)
              .fold<int>(0, (int sum, e) {
                final details = e.details as List<dynamic>? ?? [];

                final int detailQty = details.fold<int>(0, (int dSum, detail) {
                  final int qty = (detail.quantity as num?)?.toInt() ?? 0;

                  return dSum + qty;
                });

                return sum + detailQty;
              });

          // ------------------------------------------------------
          // TOTAL OMZET
          // ------------------------------------------------------
          final int totalOmzet = dayItems
              .where((e) => !e.deleteStatus)
              .fold<int>(0, (int sum, e) {
                final int grandTotal = (e.grandTotal as num?)?.toInt() ?? 0;

                return sum + grandTotal;
              });

          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Row(
              children: [
                // ------------------------------------------------
                // DATE
                // ------------------------------------------------
                Text(
                  DateFormat('dd').format(date),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(10),

                // ------------------------------------------------
                // DAY + MONTH
                // ------------------------------------------------
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

                // ------------------------------------------------
                // OMZET
                // ------------------------------------------------
                if (showSummary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                  ),
              ],
            ),
          );
        },

        // ========================================================
        // ITEM SEPARATOR
        // ========================================================
        separatorBuilder: (_, _) {
          return const SizedBox(height: 2);
        },

        // ========================================================
        // SECTION SEPARATOR
        // ========================================================
        sectionSeparatorBuilder: (_, _) {
          return const SizedBox(height: 20);
        },

        // ========================================================
        // TRANSACTION ITEM
        // ========================================================
        itemBuilder: (_, index) {
          final item = values[index.section][index.index];

          final bool canSlide =
              enableSlidable &&
              !item.deleteStatus &&
              item.cashierName == cashierName;

          final Widget tile = _transactionTile(item);

          if (!canSlide) {
            return tile;
          }

          return Slidable(
            key: Key('${item.id}'),

            endActionPane: ActionPane(
              motion: const ScrollMotion(),

              children: [
                // DELETE
                SlidableAction(
                  onPressed: (_) {
                    trxController.removeTransaction(item.id);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),

                // PRINT
                SlidableAction(
                  onPressed: (_) {
                    printController.printTransaction(item.id);
                  },
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.print,
                  label: 'Print',
                ),
              ],
            ),

            child: tile,
          );
        },
      ),
    );
  }

  // ==============================================================
  // TRANSACTION TILE
  // ==============================================================

  Widget _transactionTile(dynamic item) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        iconColor: MyColors.primary,

        // ----------------------------------------------------------
        // TITLE
        // ----------------------------------------------------------
        title: Text(
          'HIMALAYA/${item.branchCode}/${item.numerator.toString().padLeft(4, '0')}',
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
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormat.convertToIdr(item.grandTotal, 0),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.deleteStatus ? MyColors.red : MyColors.primary,
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
        ),

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

                // ==================================================
                // DETAIL LIST
                // ==================================================
                ..._buildDetails(item),

                // ==================================================
                // DELETE STATUS
                // ==================================================
                if (item.deleteStatus)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Transaksi dibatalkan\n'
                      'Alasan: ${item.deleteReason ?? '-'}',
                      style: const TextStyle(
                        color: MyColors.red,
                        fontWeight: FontWeight.bold,
                      ),
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
  // DETAIL TRANSACTIONS
  // ==============================================================

  List<Widget> _buildDetails(dynamic item) {
    final details = item.details as List<dynamic>? ?? [];

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
  // INFO ROW
  // ==============================================================

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MyColors.grey),

        const Gap(5),

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
}
