import 'package:cashier/commons/currency.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CheckoutSummarySection extends StatelessWidget {
  final CartController cartController;

  const CheckoutSummarySection({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: CurrencyFormat.convertToIdr(
              cartController.subTotal.value,
              0,
            ),
          ),

          const SizedBox(height: 12),

          _DiscountRow(
            controller: cartController.discountController,
            onChanged: _handleDiscountChanged,
          ),

          const SizedBox(height: 16),

          _SummaryRow(
            label: 'Total (${cartController.totalAllQuantity.value} item)',
            value: CurrencyFormat.convertToIdr(
              cartController.totalBayar.value,
              0,
            ),
            emphasized: true,
          ),
        ],
      );
    });
  }

  void _handleDiscountChanged(String value) {
    final numericValue = _parseCurrency(value);
    final maxDiscount = cartController.subTotal.value;

    if (numericValue > maxDiscount) {
      final formatted = CurrencyFormat.convertToIdr(maxDiscount, 0);

      cartController.discountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    cartController.applyDiscount();
  }

  int _parseCurrency(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: emphasized ? 14 : 13,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
              color:
                  emphasized
                      ? const Color(0xFF202124)
                      : const Color(0xFF6B7280),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 17 : 13,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w700,
            color:
                emphasized ? const Color(0xFF202124) : const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}

class _DiscountRow extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _DiscountRow({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Row(
            children: [
              Icon(Icons.discount_outlined, size: 17, color: Color(0xFF6B7280)),
              SizedBox(width: 7),
              Text(
                'Diskon',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 130,
          height: 38,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280),
              ),
              hintText: '0',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),
        ),
      ],
    );
  }
}
