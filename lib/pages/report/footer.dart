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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: MediaQuery.of(context).size.height * .07,
      decoration: BoxDecoration(
        color: MyColors.surface,
        border: Border(
          top: BorderSide(
            color: MyColors.border.withValues(alpha: .9),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            // ==========================================================
            // TOTAL ITEM
            // ==========================================================

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: MyColors.accentLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: MyColors.accent.withValues(alpha: .25),
                ),
              ),
              child: Text(
                'Total Item: ${_transactionController.totalCup.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: MySizes.fontSizeSm,
                  fontWeight: FontWeight.w700,
                  color: MyColors.accentDark,
                ),
              ),
            ),

            const Spacer(),

            // ==========================================================
            // TOTAL TRANSAKSI
            // ==========================================================
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                text: 'Total  ',
                style: const TextStyle(
                  fontSize: MySizes.fontSizeSm,
                  color: MyColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: CurrencyFormat.convertToIdr(
                      _transactionController.total.value,
                      0,
                    ),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeXl,
                      color: MyColors.primaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
