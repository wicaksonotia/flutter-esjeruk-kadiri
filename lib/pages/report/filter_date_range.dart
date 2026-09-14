import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterDateRange extends StatefulWidget {
  final TransactionController transactionController;

  const FilterDateRange({super.key, required this.transactionController});

  @override
  State<FilterDateRange> createState() => _FilterDateRangeState();
}

class _FilterDateRangeState extends State<FilterDateRange> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.transactionController.showDialogDateRangePicker();
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: MyColors.primary.withValues(alpha: .06),
          highlightColor: MyColors.primary.withValues(alpha: .03),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.date_range_rounded,
                  size: 18,
                  color: MyColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('dd MMM yyyy').format(widget.transactionController.startDate.value)}'
                  ' - '
                  '${DateFormat('dd MMM yyyy').format(widget.transactionController.endDate.value)}',
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
