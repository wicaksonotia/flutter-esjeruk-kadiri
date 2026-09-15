import 'package:cashier/commons/colors.dart';
import 'package:flutter/material.dart';

class QuantityBadge extends StatelessWidget {
  final int quantity;

  const QuantityBadge({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: MyColors.accentLight,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: MyColors.accent.withValues(alpha: .25)),
      ),
      child: Text(
        '${quantity}x',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: MyColors.accentDark,
        ),
      ),
    );
  }
}
