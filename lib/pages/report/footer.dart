import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterReport extends StatefulWidget {
  const FooterReport({super.key});

  @override
  State<FooterReport> createState() => _FooterReportState();
}

class _FooterReportState extends State<FooterReport> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * .07,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: MyColors.notionBgGrey,
            spreadRadius: 0,
            blurRadius: 7,
          ),
        ],
        color: Colors.white,
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total Item: ${_transactionController.totalCup.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: MySizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeLg,
                      color: MyColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: CurrencyFormat.convertToIdr(
                          _transactionController.total.value,
                          0,
                        ),
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeXl,
                          color: MyColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
