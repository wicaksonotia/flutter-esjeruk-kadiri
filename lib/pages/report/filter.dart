import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/lists.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:cashier/pages/report/filter_date_range.dart';
import 'package:cashier/pages/report/filter_month.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
        return Material(
          color: MyColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // ==========================================================
              // DRAG HANDLE
              // ==========================================================

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MyColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              // ==========================================================
              // FILTER CATEGORY
              // ==========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: Obx(
                  () => ChipsChoice<String>.single(
                    wrapped: true,
                    padding: EdgeInsets.zero,
                    value: _transactionController.filterBy.value,
                    onChanged: (value) {
                      _transactionController.filterBy.value = value;
                    },
                    choiceItems:
                        C2Choice.listFrom<String, Map<String, dynamic>>(
                          source: filterKategori,
                          value: (_, item) => item['value'] as String,
                          label: (_, item) => item['nama'] as String,
                        ),
                    choiceStyle: C2ChipStyle.filled(
                      // ==================================================
                      // NORMAL
                      // ==================================================

                      foregroundStyle: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textSecondary,
                      ),

                      color: MyColors.surfaceSoft,

                      borderRadius: BorderRadius.circular(12),

                      // ==================================================
                      // SELECTED
                      // ==================================================
                      selectedStyle: C2ChipStyle(
                        backgroundColor: MyColors.accentLight,

                        borderRadius: BorderRadius.circular(12),

                        borderColor: MyColors.accent.withValues(alpha: .30),

                        foregroundStyle: const TextStyle(
                          color: MyColors.accentDark,
                          fontSize: MySizes.fontSizeSm,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Gap(4),

              // ==========================================================
              // DATE / MONTH FILTER
              // ==========================================================
              Container(
                width: double.infinity,
                height: context.height * 0.05,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: MyColors.surface,
                child: Obx(() {
                  final filterBy = _transactionController.filterBy.value;

                  return filterBy == 'bulan'
                      ? FilterMonth(
                        transactionController: _transactionController,
                      )
                      : FilterDateRange(
                        transactionController: _transactionController,
                      );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
