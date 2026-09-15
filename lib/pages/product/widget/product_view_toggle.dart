import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductViewToggle extends StatelessWidget {
  final ProductController controller;

  const ProductViewToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isList = controller.showListGrid.value;

      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: MyColors.surfaceSoft,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: MyColors.border.withValues(alpha: .7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ViewButton(
              icon: Icons.view_list_rounded,
              selected: isList,
              onTap: controller.setListView,
            ),
            _ViewButton(
              icon: Icons.grid_view_rounded,
              selected: !isList,
              onTap: controller.setGridView,
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================================
// VIEW BUTTON
// ============================================================================

class _ViewButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ViewButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: MyColors.primary.withValues(alpha: .08),
        highlightColor: MyColors.primary.withValues(alpha: .04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: selected ? MyColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: selected ? MyColors.primaryDark : MyColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
