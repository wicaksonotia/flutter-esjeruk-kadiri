import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/pages/report/footer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/controllers/transaction_controller.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:esjerukkadiri/drawer/nav_drawer.dart' as custom_drawer;

class TransactionDailyPage extends StatefulWidget {
  const TransactionDailyPage({super.key});

  @override
  TransactionDailyPageState createState() => TransactionDailyPageState();
}

class TransactionDailyPageState extends State<TransactionDailyPage> {
  int? groupValue = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      bottomNavigationBar: const FooterReport(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'Transaksi Harian',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primary,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                if (_transactionController.isLoadingDailyTransaction.value) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount:
                          _transactionController.dailyTransactionItems.length,
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
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 8),
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
                if (_transactionController.dailyTransactionItems.isEmpty) {
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
                Map<String, List<dynamic>> resultDataMap = {};
                for (var item in _transactionController.dailyTransactionItems) {
                  String formattedDate = DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(DateTime.parse(item.transactionDate!));
                  if (!resultDataMap.containsKey(formattedDate)) {
                    resultDataMap[formattedDate] = [];
                  }
                  resultDataMap[formattedDate]!.add(item);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _transactionController.fetchDailyTransactions();
                  },
                  child: GroupListView(
                    sectionsCount: resultDataMap.keys.toList().length,
                    countOfItemInSection: (int section) {
                      return resultDataMap.values.toList()[section].length;
                    },
                    itemBuilder: (BuildContext context, IndexPath index) {
                      var items =
                          resultDataMap.values.toList()[index.section][index
                              .index];
                      if (items.deleteStatus == true) {
                        return Container(
                          color: Colors.white,
                          child: ExpansionTile(
                            leading: const Icon(Icons.receipt),
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: items.numerator.toString().padLeft(
                                      4,
                                      '0',
                                    ),
                                    style: const TextStyle(
                                      fontSize: MySizes.fontSizeMd,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: '  '),
                                  TextSpan(
                                    text: '(${items.paymentMethod})',
                                    style: const TextStyle(
                                      fontSize: MySizes.fontSizeSm,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy HH:mm',
                                'id_ID',
                              ).format(DateTime.parse(items.transactionDate)),
                              style: const TextStyle(
                                color: MyColors.grey,
                                fontSize: MySizes.fontSizeSm,
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormat.convertToIdr(
                                    items.grandTotal,
                                    0,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MySizes.fontSizeMd,
                                    color: MyColors.primary,
                                  ),
                                ),
                                if (items.deleteStatus!) ...[
                                  const Text(
                                    'Deleted',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: MySizes.fontSizeSm,
                                    ),
                                  ),
                                  Text(
                                    '( ${items.deleteReason} )',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: MySizes.fontSizeXsm,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            iconColor: MyColors.primary,
                            children: [
                              ListTile(
                                title: const Text(
                                  'Transaction Details',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: items.details!.length,
                                      itemBuilder: (context, detailIndex) {
                                        return Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.5,
                                              child: Text(
                                                items
                                                        .details[detailIndex]
                                                        .productName ??
                                                    'Unknown Product',
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.1,
                                              child: Text(
                                                '${items.details[detailIndex].quantity}',
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.25,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                CurrencyFormat.convertToIdr(
                                                  items
                                                      .details[detailIndex]
                                                      .totalPrice,
                                                  0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Slidable(
                          key: Key('${items.id}'),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _transactionController.removeTransaction(
                                    items.id,
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  _printNotaController.printTransaction(
                                    items.id,
                                  );
                                },
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.print,
                                label: 'Print',
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ExpansionTile(
                              leading: const Icon(Icons.receipt),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: items.numerator.toString().padLeft(
                                        4,
                                        '0',
                                      ),
                                      style: const TextStyle(
                                        fontSize: MySizes.fontSizeMd,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: '  '),
                                    TextSpan(
                                      text: '(${items.paymentMethod})',
                                      style: const TextStyle(
                                        fontSize: MySizes.fontSizeSm,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd MMM yyyy HH:mm',
                                  'id_ID',
                                ).format(DateTime.parse(items.transactionDate)),
                                style: const TextStyle(
                                  color: MyColors.grey,
                                  fontSize: MySizes.fontSizeSm,
                                ),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormat.convertToIdr(
                                      items.grandTotal,
                                      0,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySizes.fontSizeMd,
                                      color: MyColors.primary,
                                    ),
                                  ),
                                  if (items.deleteStatus!) ...[
                                    const Text(
                                      'Deleted',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: MySizes.fontSizeSm,
                                      ),
                                    ),
                                    Text(
                                      '( ${items.deleteReason} )',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: MySizes.fontSizeXsm,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              iconColor: MyColors.primary,
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Transaction Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: items.details!.length,
                                        itemBuilder: (context, detailIndex) {
                                          return Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.5,
                                                child: Text(
                                                  items
                                                          .details[detailIndex]
                                                          .productName ??
                                                      'Unknown Product',
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.1,
                                                child: Text(
                                                  '${items.details[detailIndex].quantity}',
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.25,
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  CurrencyFormat.convertToIdr(
                                                    items
                                                        .details[detailIndex]
                                                        .totalPrice,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    groupHeaderBuilder: (BuildContext context, int section) {
                      return Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.only(left: 16, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey[100]!, width: 1),
                            bottom: BorderSide(
                              color: Colors.grey[100]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd').format(
                                DateFormat(
                                  'dd MMMM yyyy',
                                  'id_ID',
                                ).parse(resultDataMap.keys.toList()[section]),
                              ),
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
                                  DateFormat('EEEE', 'id_ID').format(
                                    DateFormat('dd MMMM yyyy', 'id_ID').parse(
                                      resultDataMap.keys.toList()[section],
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMMM yyyy', 'id_ID').format(
                                    DateFormat('dd MMMM yyyy', 'id_ID').parse(
                                      resultDataMap.keys.toList()[section],
                                    ),
                                  ),
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
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 2),
                    sectionSeparatorBuilder:
                        (context, section) => const SizedBox(height: 20),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
