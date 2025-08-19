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
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int enableMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: MySizes.iconSm,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            widget.transactionController.nextOrPreviousMonth(false);
            widget.transactionController.fetchTransaction();
          },
        ),
        Center(
          child: Obx(
            () => GestureDetector(
              onTap: () async {
                showMonthPicker(
                  context,
                  onSelected: (month, year) {
                    month = month;
                    year = year;
                    widget.transactionController.initMonth.value = month;
                    widget.transactionController.initYear.value = year;
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
                  highlightColor: MyColors.primary,
                  textColor: Colors.black,
                  contentBackgroundColor: Colors.white,
                  dialogBackgroundColor: Colors.grey[200],
                );
              },
              child: Text(
                "${DateFormat('MMMM', 'id_ID').format(DateTime(0, widget.transactionController.initMonth.value))} ${widget.transactionController.initYear.value}",
                style: const TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          iconSize: MySizes.iconSm,
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (widget.transactionController.initYear.value <
                    DateTime.now().year ||
                (widget.transactionController.initYear.value ==
                        DateTime.now().year &&
                    widget.transactionController.initMonth.value <
                        DateTime.now().month)) {
              widget.transactionController.nextOrPreviousMonth(true);
              widget.transactionController.fetchTransaction();
              month = widget.transactionController.initMonth.value;
              year = widget.transactionController.initYear.value;
            }
          },
        ),
      ],
    );
  }
}
