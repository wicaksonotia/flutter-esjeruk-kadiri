import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/controllers/transaction_controller.dart';

class FilterReport extends StatefulWidget {
  const FilterReport({super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .4,
      maxChildSize: .5,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaction History Filter',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MySizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                children: [
                  Obx(() => _transactionController.checkSingleDate.value
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink()),
                  const Gap(5),
                  const Text(
                    'Filter by date',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    _transactionController.checkSingleDate.value = true;
                    _transactionController.textStartDate.value = '';
                    _transactionController.textEndDate.value = '';
                    _transactionController.chooseDate('single');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            _transactionController.textSingleDate.isNotEmpty
                                ? _transactionController.textSingleDate.value
                                : 'Date',
                            style: const TextStyle(
                              fontSize: MySizes.fontSizeMd,
                              color: Colors.black54,
                            ),
                          )),
                      const Icon(Icons.calendar_today, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Row(
                children: [
                  Obx(() => !_transactionController.checkSingleDate.value
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink()),
                  const Gap(5),
                  const Text(
                    'Filter by Range Date',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _transactionController.checkSingleDate.value = false;
                          _transactionController.textSingleDate.value = '';
                          _transactionController.chooseDate('start');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  _transactionController
                                          .textStartDate.isNotEmpty
                                      ? _transactionController
                                          .textStartDate.value
                                      : 'Start date',
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    color: Colors.black54,
                                  ),
                                )),
                            const Icon(Icons.calendar_today,
                                color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _transactionController.checkSingleDate.value = false;
                          _transactionController.textSingleDate.value = '';
                          _transactionController.chooseDate('end');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  _transactionController.textEndDate.isNotEmpty
                                      ? _transactionController.textEndDate.value
                                      : 'End date',
                                  style: const TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    color: Colors.black54,
                                  ),
                                )),
                            const Icon(Icons.calendar_today,
                                color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _transactionController.fetchTransaction();
                  },
                  child: const Text(
                    'Apply Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
