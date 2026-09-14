import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductViewToggle extends StatelessWidget {
  final ProductController controller;

  const ProductViewToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,

      padding: const EdgeInsets.all(3),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Obx(() {
        final isList = controller.showListGrid.value;

        return Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            _ToggleButton(
              icon: Icons.view_list_rounded,
              active: isList,
              onTap: controller.setListView,
            ),

            _ToggleButton(
              icon: Icons.grid_view_rounded,
              active: !isList,
              onTap: controller.setGridView,
            ),
          ],
        );
      }),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),

          width: 36,
          height: 32,

          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,

            borderRadius: BorderRadius.circular(9),
          ),

          child: Icon(
            icon,
            size: 19,

            color: active ? MyColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
