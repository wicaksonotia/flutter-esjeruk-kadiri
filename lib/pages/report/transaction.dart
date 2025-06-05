import 'package:chips_choice/chips_choice.dart';
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/lists.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/pages/report/filter_date_range.dart';
import 'package:esjerukkadiri/pages/report/filter_month.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/controllers/transaction_controller.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  final TransactionController _transactionController =
      Get.put(TransactionController());
  final PrintNotaController _printNotaController =
      Get.find<PrintNotaController>();
  final LoginController _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const FooterReport(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'Report',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primary,
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
                      _loginController.logout();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.white,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ChipsChoice.single(
                      wrapped: true,
                      padding: EdgeInsets.zero,
                      value: _transactionController.filterBy.value,
                      onChanged: (val) =>
                          _transactionController.filterBy.value = val,
                      choiceItems:
                          C2Choice.listFrom<String, Map<String, dynamic>>(
                        source: filterKategori,
                        value: (i, v) => v['value'] as String,
                        label: (i, v) => v['nama'] as String,
                      ),
                      choiceStyle: C2ChipStyle.filled(
                        foregroundStyle: const TextStyle(
                          fontSize: MySizes.fontSizeSm,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey[200],
                        selectedStyle: const C2ChipStyle(
                          backgroundColor: MyColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    if (_transactionController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: MySizes.fontSizeLg,
                            color: MyColors.primary,
                          ),
                        ),
                      );
                    } else {
                      return RichText(
                        text: TextSpan(
                          text: 'Total: ',
                          style: const TextStyle(
                            fontSize: MySizes.fontSizeLg,
                            color: MyColors.primary,
                          ),
                          children: [
                            TextSpan(
                              text: CurrencyFormat.convertToIdr(
                                  _transactionController.total.value, 0),
                              style: const TextStyle(
                                fontSize: MySizes.fontSizeXl,
                                color: MyColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: context.height * 0.05,
              child: Obx(
                () => _transactionController.filterBy.value == 'bulan'
                    ? FilterMonth(transactionController: _transactionController)
                    : FilterDateRange(
                        transactionController: _transactionController),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_transactionController.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: _transactionController.transactionItems.length,
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
                if (_transactionController.transactionItems.isEmpty) {
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
                for (var item in _transactionController.transactionItems) {
                  String formattedDate = DateFormat('dd MMMM yyyy')
                      .format(DateTime.parse(item.transactionDate!));
                  if (!resultDataMap.containsKey(formattedDate)) {
                    resultDataMap[formattedDate] = [];
                  }
                  resultDataMap[formattedDate]!.add(item);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _transactionController.fetchTransaction();
                  },
                  child: GroupListView(
                    sectionsCount: resultDataMap.keys.toList().length,
                    countOfItemInSection: (int section) {
                      return resultDataMap.values.toList()[section].length;
                    },
                    itemBuilder: (BuildContext context, IndexPath index) {
                      var items = resultDataMap.values.toList()[index.section]
                          [index.index];
                      return Slidable(
                        key: Key('${items.numerator}_${items.kios}'),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _transactionController.removeTransaction(
                                    items.numerator, items.kios);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _printNotaController.printTransaction(
                                    items.numerator, items.kios);
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
                            title: Text(
                              '${items.kios.toUpperCase()}-${items.numerator.toString().padLeft(4, '0').toUpperCase()}',
                              style:
                                  const TextStyle(fontSize: MySizes.fontSizeMd),
                            ),
                            subtitle: Text(
                              DateFormat('dd MMM yyyy HH:mm').format(
                                  DateTime.parse(items.transactionDate)),
                              style: const TextStyle(
                                color: MyColors.grey,
                                fontSize: MySizes.fontSizeSm,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      items.grandTotal, 0),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySizes.fontSizeMd,
                                      color: MyColors.primary),
                                ),
                                Text(
                                  items.deleteStatus! ? 'Deleted' : '',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: MySizes.fontSizeSm,
                                  ),
                                ),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(items
                                                      .details[detailIndex]
                                                      .productName ??
                                                  'Unknown Product'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              child: Text(
                                                  '${items.details[detailIndex].quantity}'),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  CurrencyFormat.convertToIdr(
                                                      items.details[detailIndex]
                                                          .totalPrice,
                                                      0)),
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
                        ),
                      );
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
                            bottom:
                                BorderSide(color: Colors.grey[100]!, width: 1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd').format(
                                DateFormat('dd MMMM yyyy').parse(
                                    resultDataMap.keys.toList()[section]),
                              ),
                              style: const TextStyle(
                                  fontSize: 33, fontWeight: FontWeight.bold),
                            ),
                            const Gap(10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE').format(
                                    DateFormat('dd MMMM yyyy').parse(
                                        resultDataMap.keys.toList()[section]),
                                  ),
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMMM yyyy').format(
                                    DateFormat('dd MMMM yyyy').parse(
                                        resultDataMap.keys.toList()[section]),
                                  ),
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeSm,
                                    color: MyColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: MyColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                CurrencyFormat.convertToIdr(
                                  _transactionController.transactionItems
                                      .where((element) =>
                                          DateFormat('dd MMMM yyyy').format(
                                                  DateTime.parse(element
                                                      .transactionDate!)) ==
                                              resultDataMap.keys
                                                  .toList()[section] &&
                                          !element.deleteStatus!)
                                      .fold<int>(
                                        0,
                                        (sum, element) =>
                                            sum + element.grandTotal!,
                                      ),
                                  0,
                                ),
                                style: const TextStyle(
                                  fontSize: MySizes.fontSizeLg,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                    sectionSeparatorBuilder: (context, section) =>
                        const SizedBox(height: 20),
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
