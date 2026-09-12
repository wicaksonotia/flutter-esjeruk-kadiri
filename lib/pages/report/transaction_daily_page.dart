import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/pages/report/footer.dart';
import 'package:cashier/widgets/transaction_grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDailyPage extends StatefulWidget {
  const TransactionDailyPage({super.key});

  @override
  State<TransactionDailyPage> createState() => TransactionDailyPageState();
}

class TransactionDailyPageState extends State<TransactionDailyPage> {
  final TransactionController _transactionController = Get.put(
    TransactionController(),
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),

      backgroundColor: MyColors.notionBgGrey,

      bottomNavigationBar: const FooterReport(),

      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,

        title: const Text(
          'Daily Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      body: SafeArea(
        child: Obx(
          () => TransactionGroupedList(
            items: _transactionController.dailyTransactionItems,

            isLoading: _transactionController.isLoadingDailyTransaction.value,

            enableDelete: true,

            enablePrint: true,

            showSummary: false,

            cashierName: _transactionController.namaKasir.value,

            onRefresh: _refresh,
          ),
        ),
      ),
    );
  }
}
