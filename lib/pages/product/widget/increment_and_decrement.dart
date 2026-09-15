import 'package:cashier/commons/colors.dart';
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

      if (quantity <= 0) {
        return _AddButton(
          onTap: () {
            cartController.incrementProductQuantity(dataProduct);
          },
        );
      }

      return _QuantityControl(
        quantity: quantity,
        onDecrement: () {
          cartController.decrementProductQuantity(dataProduct);
        },
        onIncrement: () {
          cartController.incrementProductQuantity(dataProduct);
        },
      );
    });
  }
}

// ==================================================================
// ADD BUTTON
// ==================================================================

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.selectedBackground,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        splashColor: MyColors.selectedForeground.withValues(alpha: .10),
        highlightColor: MyColors.selectedForeground.withValues(alpha: .05),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: MyColors.selectedBorder),
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              size: 20,
              color: MyColors.selectedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// QUANTITY CONTROL
// ==================================================================

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: MyColors.selectedBackground,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: MyColors.selectedBorder),
      ),
      child: Row(
        children: [
          _QuantityButton(icon: Icons.remove_rounded, onTap: onDecrement),

          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: MyColors.selectedForeground,
                  ),
                ),
              ),
            ),
          ),

          _QuantityButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

// ==================================================================
// QUANTITY BUTTON
// ==================================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 32,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          splashColor: MyColors.selectedForeground.withValues(alpha: .10),
          highlightColor: MyColors.selectedForeground.withValues(alpha: .05),
          child: Icon(icon, size: 16, color: MyColors.selectedForeground),
        ),
      ),
    );
  }
}
