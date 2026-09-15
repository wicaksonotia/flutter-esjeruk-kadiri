import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:flutter/material.dart';

class CashSuggestionChip extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const CashSuggestionChip({
    super.key,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: MyColors.selectedBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.selectedBorder),
          ),
          alignment: Alignment.center,
          child: Text(
            CurrencyFormat.convertToIdr(amount, 0),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: MyColors.selectedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
