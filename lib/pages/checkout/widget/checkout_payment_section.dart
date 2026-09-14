import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/pages/checkout/component/cash_suggestion_chip.dart';
import 'package:cashier/pages/checkout/component/payment_method_selector.dart';
import 'package:flutter/material.dart';

class CheckoutPaymentSection extends StatefulWidget {
  final CartController cartController;

  const CheckoutPaymentSection({super.key, required this.cartController});

  @override
  State<CheckoutPaymentSection> createState() => _CheckoutPaymentSectionState();
}

class _CheckoutPaymentSectionState extends State<CheckoutPaymentSection> {
  List<int> _paymentSuggestions = [];

  CartController get cartController => widget.cartController;

  @override
  void initState() {
    super.initState();

    _generatePaymentSuggestions();
  }

  @override
  void didUpdateWidget(covariant CheckoutPaymentSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cartController != widget.cartController) {
      _generatePaymentSuggestions();
    }
  }

  void _generatePaymentSuggestions() {
    final total = cartController.totalBayar.value;

    if (total <= 0) {
      _paymentSuggestions = [];
      return;
    }

    final suggestions = <int>[];

    final closest5000 = ((total + 4999) ~/ 5000) * 5000;

    suggestions.add(closest5000);

    final closest50000 = ((total + 49999) ~/ 50000) * 50000;

    if (closest5000 != closest50000) {
      suggestions.add(closest50000);
      suggestions.add(closest50000 + 50000);
    } else {
      suggestions.add(closest50000 + 50000);
      suggestions.add(closest50000 + 100000);
    }

    _paymentSuggestions = suggestions.toSet().toList();
  }

  void _setCashAmount(int amount) {
    final formatted = CurrencyFormat.convertToIdr(amount, 0);

    cartController.bayarTunai.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    setState(() {});
  }

  int _parseCurrency(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  int _getChange() {
    final cashAmount = _parseCurrency(cartController.bayarTunai.text);

    final total = cartController.totalBayar.value;

    return cashAmount > total ? cashAmount - total : 0;
  }

  bool _isCashEnough() {
    final cashAmount = _parseCurrency(cartController.bayarTunai.text);

    return cashAmount >= cartController.totalBayar.value;
  }

  @override
  Widget build(BuildContext context) {
    _generatePaymentSuggestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(icon: Icons.payments_outlined, title: 'Pembayaran'),

        const SizedBox(height: 14),

        PaymentMethodSelector(
          value: cartController.paymentMethod.value,
          onChanged: (value) {
            cartController.paymentMethod.value = value;

            setState(() {});
          },
        ),

        if (cartController.paymentMethod.value == 'Cash') ...[
          const SizedBox(height: 16),

          _CashPaymentSection(
            controller: cartController.bayarTunai,
            suggestions: _paymentSuggestions,
            total: cartController.totalBayar.value,
            onAmountChanged: (_) {
              setState(() {});
            },
            onSuggestionSelected: _setCashAmount,
          ),

          const SizedBox(height: 14),

          _ChangeRow(
            cashAmount: _parseCurrency(cartController.bayarTunai.text),
            total: cartController.totalBayar.value,
            change: _getChange(),
            enough: _isCashEnough(),
          ),
        ],
      ],
    );
  }
}

class _CashPaymentSection extends StatelessWidget {
  final TextEditingController controller;
  final List<int> suggestions;
  final int total;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<int> onSuggestionSelected;

  const _CashPaymentSection({
    required this.controller,
    required this.suggestions,
    required this.total,
    required this.onAmountChanged,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uang diterima',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onAmountChanged,
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202124),
            ),
            hintText: 'Masukkan nominal',
            hintStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: MyColors.primary),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202124),
          ),
        ),

        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 10),

          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, index) {
                final amount = suggestions[index];

                return CashSuggestionChip(
                  amount: amount,
                  onTap: () {
                    onSuggestionSelected(amount);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final int cashAmount;
  final int total;
  final int change;
  final bool enough;

  const _ChangeRow({
    required this.cashAmount,
    required this.total,
    required this.change,
    required this.enough,
  });

  @override
  Widget build(BuildContext context) {
    final missing = total - cashAmount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: enough ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: enough ? const Color(0xFFDCFCE7) : const Color(0xFFFED7AA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            enough
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 18,
            color: enough ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              enough ? 'Kembalian' : 'Uang kurang',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    enough ? const Color(0xFF15803D) : const Color(0xFFC2410C),
              ),
            ),
          ),

          Text(
            CurrencyFormat.convertToIdr(enough ? change : missing, 0),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: enough ? const Color(0xFF15803D) : const Color(0xFFC2410C),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF475569)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202124),
          ),
        ),
      ],
    );
  }
}
