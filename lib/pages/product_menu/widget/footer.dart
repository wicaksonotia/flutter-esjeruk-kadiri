import 'package:badges/badges.dart' as badges;
import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterProduct extends StatelessWidget {
  final CartController cartController;

  const FooterProduct({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quantity = cartController.totalAllQuantity.value;

      final subtotal = cartController.subTotal.value;

      final disabled = cartController.isButtonDisabled.value;

      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: Color(0xFFE8EAED))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              _CartSummary(quantity: quantity, subtotal: subtotal),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        disabled
                            ? null
                            : () {
                              cartController.applyDiscount();

                              Get.toNamed(RouterClass.checkoutPage);
                            },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: MyColors.primary,
                      disabledBackgroundColor: const Color(0xFFD5D8DD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_checkout_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _CartSummary extends StatelessWidget {
  final int quantity;
  final num subtotal;

  const _CartSummary({required this.quantity, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badges.Badge(
          badgeContent: Text(
            quantity.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: MyColors.primary,
            padding: EdgeInsets.all(5),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 21,
              color: MyColors.primary,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF8A8F98),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Rp ${CurrencyFormat.convertToIdr(subtotal, 0)}',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF202124),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
