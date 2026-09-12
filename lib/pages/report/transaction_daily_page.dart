import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/print_nota_controller.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/pages/report/footer.dart';
import 'package:cashier/widgets/transaction_grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class TransactionDailyPage extends StatefulWidget {
  const TransactionDailyPage({super.key});

  @override
  State<TransactionDailyPage> createState() => TransactionDailyPageState();
}

class TransactionDailyPageState extends State<TransactionDailyPage> {
  final TransactionController _transactionController = Get.put(
    TransactionController(),
  );

  final PrintNotaController _printNotaController =
      Get.find<PrintNotaController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transactionController.fetchDailyTransactions();
    });
  }

  Future<void> _refresh() async {
    await _transactionController.fetchDailyTransactions();
  }

  Map<String, List<dynamic>> _groupTransactions() {
    final Map<String, List<dynamic>> grouped = {};

    for (final item in _transactionController.dailyTransactionItems) {
      final date = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(DateTime.parse(item.transactionDate!));

      grouped.putIfAbsent(date, () => []).add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      bottomNavigationBar: const FooterReport(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: MyColors.primary,
          title: const Text(
            'Daily Transactions',
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_transactionController.isLoadingDailyTransaction.value) {
            return _buildLoadingState();
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child:
                _transactionController.dailyTransactionItems.isEmpty
                    ? _buildEmptyState()
                    : _buildTransactionList(),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, _) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 50, height: 50, color: Colors.white),
                const Gap(12),
                Expanded(
                  child: Obx(
                    () => TransactionGroupedList(
                      items: _transactionController.dailyTransactionItems,
                      isLoading:
                          _transactionController
                              .isLoadingDailyTransaction
                              .value,

                      enableDelete: true,
                      enablePrint: true,
                      showSummary: false,

                      cashierName: _transactionController.namaKasir.value,

                      onRefresh:
                          () => _transactionController.fetchDailyTransactions(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: Get.height * 0.75,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty_cart.png', height: 100),
                const Gap(16),
                const Text(
                  'No transaction yet',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeXl,
                    color: Colors.black,
                  ),
                ),
                const Gap(8),
                const Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeSm,
                    color: MyColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final grouped = _groupTransactions();
    final keys = grouped.keys.toList();
    final values = grouped.values.toList();

    return GroupListView(
      physics: const AlwaysScrollableScrollPhysics(),
      sectionsCount: keys.length,
      countOfItemInSection: (section) => values[section].length,

      itemBuilder: (context, index) {
        final item = values[index.section][index.index];

        final canEdit =
            item.deleteStatus == false &&
            item.cashierName == _transactionController.namaKasir.value;

        if (!canEdit) return _transactionCard(item);

        return Slidable(
          key: Key('${item.id}'),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed:
                    (_) => _transactionController.removeTransaction(item.id),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed:
                    (_) => _printNotaController.printTransaction(item.id),
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.print,
                label: 'Print',
              ),
            ],
          ),
          child: _transactionCard(item),
        );
      },

      groupHeaderBuilder: (_, section) {
        final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(keys[section]);

        return Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade100),
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          child: Row(
            children: [
              Text(
                DateFormat('dd').format(date),
                style: const TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE', 'id_ID').format(date),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM yyyy', 'id_ID').format(date),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeSm,
                      color: MyColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },

      separatorBuilder: (_, _) => const SizedBox(height: 2),
      sectionSeparatorBuilder: (_, _) => const SizedBox(height: 20),
    );
  }

  Widget _transactionCard(dynamic item) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        iconColor: MyColors.primary,
        title: Text(
          "HIMALAYA/${item.branchCode}/${item.numerator.toString().padLeft(4, '0')}",
          style: const TextStyle(
            fontSize: MySizes.fontSizeMd,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          children: [
            _infoRow(Icons.shopping_cart, 'Total Item: ${item.totalItem}'),
            _infoRow(
              Icons.calendar_month,
              DateFormat(
                'dd MMM yyyy HH:mm',
                'id_ID',
              ).format(DateTime.parse(item.transactionDate)),
            ),
            _infoRow(Icons.person, item.cashierName ?? 'Unknown Cashier'),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormat.convertToIdr(item.grandTotal, 0),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MySizes.fontSizeMd,
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
        children: [
          ListTile(
            title: const Text(
              'Transaction Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MySizes.fontSizeMd,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: item.details.length,
                  itemBuilder: (_, i) {
                    final detail = item.details[i];

                    return Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.5,
                          child: Text(detail.productName ?? 'Unknown Product'),
                        ),
                        SizedBox(
                          width: Get.width * 0.1,
                          child: Center(child: Text('${detail.quantity}')),
                        ),
                        SizedBox(
                          width: Get.width * 0.25,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              CurrencyFormat.convertToIdr(detail.totalPrice, 0),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (item.deleteStatus)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Transaksi ini telah dibatalkan\nAlasan: ${item.deleteReason}',
                      style: const TextStyle(
                        color: MyColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: MySizes.fontSizeSm,
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

  Widget _infoRow(IconData icon, String text) {
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
