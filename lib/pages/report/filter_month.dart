import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterMonth extends StatefulWidget {
  final TransactionController transactionController;

  const FilterMonth({super.key, required this.transactionController});

  @override
  State<FilterMonth> createState() => _FilterMonthState();
}

class _FilterMonthState extends State<FilterMonth> {
  int enableMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ==========================================================
        // PREVIOUS MONTH
        // ==========================================================

        IconButton(
          iconSize: MySizes.iconSm,
          splashRadius: 20,
          color: MyColors.textSecondary,
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            widget.transactionController.nextOrPreviousMonth(false);
            widget.transactionController.fetchTransaction();
          },
        ),

        // ==========================================================
        // CURRENT MONTH
        // ==========================================================
        Expanded(
          child: Center(
            child: Obx(
              () => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    showMonthPicker(
                      context,
                      onSelected: (selectedMonth, selectedYear) {
                        widget.transactionController.initMonth.value =
                            selectedMonth;

                        widget.transactionController.initYear.value =
                            selectedYear;

                        widget.transactionController.fetchTransaction();
                      },
                      initialSelectedMonth:
                          widget.transactionController.initMonth.value,
                      initialSelectedYear:
                          widget.transactionController.initYear.value,
                      firstEnabledMonth: 1,
                      lastEnabledMonth: enableMonth,
                      firstYear: widget.transactionController.initYear.value,
                      lastYear: widget.transactionController.initYear.value,
                      selectButtonText: 'OK',
                      cancelButtonText: 'Cancel',

                      // ==================================================
                      // MONTH PICKER COLORS
                      // ==================================================
                      highlightColor: MyColors.accent,
                      textColor: MyColors.textPrimary,
                      contentBackgroundColor: MyColors.surface,
                      dialogBackgroundColor: MyColors.background,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  splashColor: MyColors.accent.withValues(alpha: .08),
                  highlightColor: MyColors.accent.withValues(alpha: .04),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MyColors.accent.withValues(alpha: .22),
                      ),
                    ),
                    child: Text(
                      '${DateFormat('MMMM', 'id_ID').format(DateTime(0, widget.transactionController.initMonth.value))} ${widget.transactionController.initYear.value}',
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeMd,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ==========================================================
        // NEXT MONTH
        // ==========================================================
        IconButton(
          iconSize: MySizes.iconSm,
          splashRadius: 20,
          color: MyColors.textSecondary,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          onPressed: () {
            if (widget.transactionController.initYear.value <
                    DateTime.now().year ||
                (widget.transactionController.initYear.value ==
                        DateTime.now().year &&
                    widget.transactionController.initMonth.value <
                        DateTime.now().month)) {
              widget.transactionController.nextOrPreviousMonth(true);
              widget.transactionController.fetchTransaction();
            }
          },
        ),
      ],
    );
  }
}
