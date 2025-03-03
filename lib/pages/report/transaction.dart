import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/pages/report/footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/controllers/transaction_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const FooterReport(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'Report',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.green,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: Obx(() {
        if (transactionController.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              itemCount: transactionController.transactionItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey[300],
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        if (transactionController.transactionItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_cart.png',
                  height: 100,
                ),
                const Gap(16),
                const Text(
                  'No transaction yet',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeXl,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            transactionController.fetchTransaction();
          },
          child: ListView.builder(
            itemCount: transactionController.transactionItems.length,
            itemBuilder: (context, index) {
              var transactionItem =
                  transactionController.transactionItems[index];
              var numerator = transactionItem.numerator!;
              var transactionDate = transactionItem.transactionDate!;
              var kios = transactionItem.kios!;
              var grandtotal = transactionItem.grandTotal;

              return Slidable(
                key: Key(numerator.toString()),
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        transactionController.removeTransaction(
                            numerator, kios);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      '${kios.toUpperCase()}-${numerator.toString().padLeft(4, '0').toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(transactionDate))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Rp ',
                                    style: TextStyle(
                                      fontSize: MySizes.fontSizeMd,
                                    ),
                                  ),
                                  TextSpan(
                                    text: CurrencyFormat.convertToIdr(
                                        grandtotal, 0),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: MyColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (transactionItem.deleteStatus)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  Text(
                                    'Deleted',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: MySizes.fontSizeSm,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.print, color: MyColors.green),
                          onPressed: () {
                            transactionController.printTransaction(
                                numerator, kios);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
