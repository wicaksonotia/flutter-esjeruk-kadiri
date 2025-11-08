import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/lists.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/pages/report/filter_date_range.dart';
import 'package:cashier/pages/report/filter_month.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:chips_choice/chips_choice.dart';

class FilterReport extends StatefulWidget {
  const FilterReport({super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  final TransactionController _transactionController =
      Get.put<TransactionController>(TransactionController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .4,
      maxChildSize: .5,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => ChipsChoice.single(
                  wrapped: true,
                  padding: EdgeInsets.zero,
                  value: _transactionController.filterBy.value,
                  onChanged:
                      (val) => _transactionController.filterBy.value = val,
                  choiceItems: C2Choice.listFrom<String, Map<String, dynamic>>(
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
            ),
            const Gap(5),
            Container(
              color: Colors.white,
              height: context.height * 0.05,
              child: Obx(
                () =>
                    _transactionController.filterBy.value == 'bulan'
                        ? FilterMonth(
                          transactionController: _transactionController,
                        )
                        : FilterDateRange(
                          transactionController: _transactionController,
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}
