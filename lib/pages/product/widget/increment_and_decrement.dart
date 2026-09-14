import 'package:cashier/commons/containers/box_container.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncrementAndDecrement extends StatelessWidget {
  final ProductModel dataProduct;

  const IncrementAndDecrement({super.key, required this.dataProduct});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(() {
      final quantity = cartController.getProductQuantity(dataProduct);

      return BoxContainer(
        height: 36,
        radius: 10,
        showBorder: true,
        borderColor: const Color(0xFFE5E7EB),
        shadow: false,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            _QuantityButton(
              icon: Icons.remove_rounded,

              enabled: quantity > 0,

              onPressed:
                  quantity > 0
                      ? () {
                        cartController.decrementProductQuantity(dataProduct);

                        if (cartController.getProductQuantity(dataProduct) <
                            1) {
                          cartController.removeProduct(dataProduct);
                        }
                      }
                      : null,
            ),

            Expanded(
              child: Center(
                child: Text(
                  '$quantity',

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),
              ),
            ),

            _QuantityButton(
              icon: Icons.add_rounded,

              enabled: true,

              onPressed: () {
                cartController.incrementProductQuantity(dataProduct);
              },
            ),
          ],
        ),
      );
    });
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,

      child: IconButton(
        padding: EdgeInsets.zero,

        constraints: const BoxConstraints(),

        onPressed: enabled ? onPressed : null,

        icon: Icon(
          icon,
          size: 17,
          color: enabled ? Colors.black87 : Colors.grey.shade300,
        ),
      ),
    );
  }
}
