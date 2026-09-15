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

      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: () {
            if (isList) {
              controller.setGridView();
            } else {
              controller.setListView();
            }
          },
          borderRadius: BorderRadius.circular(9),
          splashColor: MyColors.primary.withValues(alpha: .08),
          highlightColor: MyColors.primary.withValues(alpha: .04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: MyColors.border.withValues(alpha: .7)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                isList ? Icons.grid_view_rounded : Icons.view_list_rounded,
                key: ValueKey(isList),
                size: 17,
                color: MyColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    });
  }
}
