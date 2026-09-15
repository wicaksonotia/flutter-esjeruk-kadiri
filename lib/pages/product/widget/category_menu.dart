import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_category_target.dart';
import 'package:cashier/pages/product/widget/product_view_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesMenu extends StatelessWidget {
  final Future<void> Function(ProductCategoryTarget target) onCategorySelected;

  const CategoriesMenu({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      final categories = controller.productCategoryItems.toList();

      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      // ============================================================
      // DEFAULT SELECTED = CATEGORY INDEX 0
      // ============================================================

      final firstCategoryId = categories.first.categoryId;

      final selectedId =
          controller.selectedCategoryId.value == 0
              ? firstCategoryId
              : controller.selectedCategoryId.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
        decoration: BoxDecoration(
          color: MyColors.background,
          border: Border(
            bottom: BorderSide(color: MyColors.border.withValues(alpha: .45)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 15,
                  color: MyColors.primary,
                ),

                const SizedBox(width: 7),

                const Expanded(
                  child: Text(
                    'Pilih Menu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: MyColors.textPrimary,
                      letterSpacing: -.1,
                    ),
                  ),
                ),

                // ==================================================
                // LIST / GRID TOGGLE
                // ==================================================
                ProductViewToggle(controller: controller),
              ],
            ),

            const SizedBox(height: 9),

            // ======================================================
            // CATEGORY LIST
            // ======================================================
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  final id = category.categoryId;
                  final name = category.categoryName?.trim();

                  if (id == null || name == null || name.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return _CategoryChip(
                    title: name,
                    selected: selectedId == id,
                    onTap: () {
                      onCategorySelected(ProductCategoryTarget(categoryId: id));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ==================================================================
// CATEGORY CHIP
// ==================================================================

class _CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: MyColors.primary.withValues(alpha: .07),
        highlightColor: MyColors.primary.withValues(alpha: .03),
        child: AnimatedScale(
          scale: selected ? 1.0 : .98,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              // ==================================================
              // SOFT SELECTED BACKGROUND
              // ==================================================

              color:
                  selected
                      ? MyColors.primary.withValues(alpha: .075)
                      : Colors.white,

              borderRadius: BorderRadius.circular(14),

              border: Border.all(
                color:
                    selected
                        ? MyColors.primary.withValues(alpha: .18)
                        : MyColors.border.withValues(alpha: .85),
                width: selected ? 1.1 : 1,
              ),

              // ==================================================
              // VERY SOFT LIFT
              // ==================================================
              boxShadow:
                  selected
                      ? [
                        BoxShadow(
                          color: MyColors.primary.withValues(alpha: .055),
                          blurRadius: 9,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // ICON
                // ==================================================

                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? MyColors.primary.withValues(alpha: .10)
                            : MyColors.primaryLight.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Icon(
                      _categoryIcon(title),
                      key: ValueKey('${title}_$selected'),
                      size: 14,
                      color:
                          selected
                              ? MyColors.primaryDark
                              : MyColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ==================================================
                // TITLE
                // ==================================================
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color:
                        selected ? MyColors.primaryDark : MyColors.textPrimary,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: -.1,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // ==================================================
                // SOFT ACTIVE INDICATOR
                // ==================================================
                AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  child:
                      selected
                          ? Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: MyColors.primaryDark.withValues(
                                  alpha: .65,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // CATEGORY ICON
  // ================================================================

  IconData _categoryIcon(String name) {
    final value = name.toLowerCase();

    if (value.contains('ayam')) {
      return Icons.egg_alt_rounded;
    }

    if (value.contains('bebek')) {
      return Icons.egg_rounded;
    }

    if (value.contains('booster')) {
      return Icons.bolt_rounded;
    }

    if (value.contains('susu')) {
      return Icons.local_drink_rounded;
    }

    if (value.contains('jahe')) {
      return Icons.spa_rounded;
    }

    if (value.contains('rempah')) {
      return Icons.grass_rounded;
    }

    if (value.contains('detox')) {
      return Icons.eco_rounded;
    }

    if (value.contains('ketan')) {
      return Icons.rice_bowl_rounded;
    }

    return Icons.restaurant_menu_rounded;
  }
}
