import 'package:cashier/commons/colors.dart';
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

      return Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),

        decoration: BoxDecoration(
          color: Colors.white,

          border: const Border(top: BorderSide(color: Color(0xFFE8EAED))),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),

        child: SafeArea(
          top: false,

          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      '$quantity item',

                      style: const TextStyle(
                        color: Color(0xFF7A7F87),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _formatPrice(subtotal),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202124),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
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
                    backgroundColor: MyColors.primary,

                    disabledBackgroundColor: const Color(0xFFE1E4E8),

                    foregroundColor: Colors.white,

                    disabledForegroundColor: const Color(0xFF9AA0A6),

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(horizontal: 22),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: const [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(width: 8),

                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatPrice(int? price) {
    if (price == null) {
      return 'Rp 0';
    }

    final value = price.toString();
    final chars = value.split('');
    final result = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      result.write(chars[i]);

      final remaining = chars.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return 'Rp ${result.toString()}';
  }
}
