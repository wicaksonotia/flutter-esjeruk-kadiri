import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/lists.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          paymentCategory.map((payment) {
            final paymentValue = payment['value']?.toString() ?? '';

            final paymentName = payment['nama']?.toString() ?? paymentValue;

            final selected = value == paymentValue;

            return _PaymentMethodItem(
              label: paymentName,
              selected: selected,
              icon: _getPaymentIcon(paymentValue),
              onTap: () {
                onChanged(paymentValue);
              },
            );
          }).toList(),
    );
  }

  IconData _getPaymentIcon(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return Icons.payments_outlined;

      case 'qris':
        return Icons.qr_code_2_rounded;

      case 'debit':
        return Icons.credit_card_outlined;

      case 'transfer':
        return Icons.account_balance_outlined;

      default:
        return Icons.payment_outlined;
    }
  }
}

class _PaymentMethodItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color:
                selected ? MyColors.selectedBackground : MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? MyColors.selectedBorder : MyColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17,
                color:
                    selected
                        ? MyColors.selectedForeground
                        : MyColors.textSecondary,
              ),

              const SizedBox(width: 7),

              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color:
                      selected
                          ? MyColors.selectedForeground
                          : MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
