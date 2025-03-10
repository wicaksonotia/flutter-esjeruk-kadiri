import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
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
  final LoginController loginController = Get.find<LoginController>();

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
          actions: [
            PopupMenuButton(
              color: Colors.white,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: (dynamic value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                      leading: const Icon(Icons.bluetooth_searching),
                      title: const Text('Setting Bluetooth'),
                      onTap: () {
                        Get.back();
                        Get.toNamed('/bluetooth_setting');
                      }),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      loginController.logout();
                    },
                  ),
                ),
              ],
            ),
          ],
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
              var details = transactionItem.details;

              return Slidable(
                key: Key(numerator.toString()),
                endActionPane: ActionPane(
                  // extentRatio: 0.4,
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
                    SlidableAction(
                      onPressed: (context) {
                        transactionController.printTransaction(numerator, kios);
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.print,
                      label: 'Print',
                    ),
                  ],
                ),
                child: ExpansionTile(
                  title: Text(
                    '${kios.toUpperCase()}-${numerator.toString().padLeft(4, '0').toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(DateFormat('dd MMM yyyy HH:mm')
                      .format(DateTime.parse(transactionDate))),
                  trailing: Column(
                    children: [
                      Text(
                        CurrencyFormat.convertToIdr(grandtotal, 0),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: MyColors.green),
                      ),
                      Text(
                        transactionItem.deleteStatus! ? 'Deleted' : '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  leading: const Icon(Icons.receipt),
                  iconColor: MyColors.green,
                  children: [
                    ListTile(
                      title: const Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: details!.length,
                            itemBuilder: (context, detailIndex) {
                              return Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                        details[detailIndex].productName ??
                                            'Unknown Product'),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Text(
                                        '${details[detailIndex].quantity}'),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    alignment: Alignment.centerRight,
                                    child: Text(CurrencyFormat.convertToIdr(
                                        details[detailIndex].totalPrice, 0)),
                                  ),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
