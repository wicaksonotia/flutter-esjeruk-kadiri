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
    final cartController = Get.find<CartController>();

    return Obx(() {
      final quantity = cartController.getProductQuantity(dataProduct);

      return _QuantityControl(
        quantity: quantity,
        onDecrement:
            quantity > 0
                ? () {
                  cartController.decrementProductQuantity(dataProduct);
                }
                : null,
        onIncrement: () {
          cartController.incrementProductQuantity(dataProduct);
        },
      );
    });
  }
}

// ============================================================
// QUANTITY CONTROL
// ============================================================

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      height: 36,
      radius: 10,
      showBorder: true,
      borderColor: const Color(0xFFE5E7EB),
      shadow: false,
      child: Row(
        children: [
          _QuantityButton(icon: Icons.remove_rounded, onPressed: onDecrement),

          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202124),
                  height: 1,
                ),
              ),
            ),
          ),

          _QuantityButton(icon: Icons.add_rounded, onPressed: onIncrement),
        ],
      ),
    );
  }
}

// ============================================================
// QUANTITY BUTTON
// ============================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: const Color(0xFF2563EB).withValues(alpha: .10),
          highlightColor: const Color(0xFF2563EB).withValues(alpha: .05),
          child: Center(
            child: Icon(
              icon,
              size: 17,
              color:
                  enabled ? const Color(0xFF202124) : const Color(0xFFD1D5DB),
            ),
          ),
        ),
      ),
    );
  }
}
