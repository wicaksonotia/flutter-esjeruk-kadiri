import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/controllers/transaction_controller.dart';
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.date_range, color: MyColors.primary),
        const SizedBox(width: 10),
        Obx(
          () => GestureDetector(
            onTap: () {
              widget.transactionController.showDialogDateRangePicker();
            },
            child: Text(
              '${DateFormat('dd MMM yyyy').format(widget.transactionController.startDate.value)} - ${DateFormat('dd MMM yyyy').format(widget.transactionController.endDate.value)}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
