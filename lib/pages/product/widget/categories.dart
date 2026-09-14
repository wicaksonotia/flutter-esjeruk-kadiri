import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_category_target.dart';
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

      final selectedId = controller.selectedCategoryId.value;

      return SizedBox(
        height: 50,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, __) {
            return const SizedBox(width: 8);
          },
          itemBuilder: (context, index) {
            final category = categories[index];

            final id = category.categoryId;
            final name = category.categoryName?.trim();

            if (id == null || name == null || name.isEmpty) {
              return const SizedBox.shrink();
            }

            final selected = selectedId == id;

            return _CategoryChip(
              title: name,
              selected: selected,
              onTap: () {
                onCategorySelected(ProductCategoryTarget(id: id));
              },
            );
          },
        ),
      );
    });
  }
}

// ================================================================
// CATEGORY CHIP
// ================================================================

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
        borderRadius: BorderRadius.circular(12),
        splashColor: MyColors.primary.withValues(alpha: .08),
        highlightColor: MyColors.primary.withValues(alpha: .04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,

          height: 40,

          padding: const EdgeInsets.symmetric(horizontal: 16),

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: selected ? MyColors.primary : Colors.white,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: selected ? MyColors.primary : const Color(0xFFE3E7EC),
            ),

            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: MyColors.primary.withValues(alpha: .18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .025),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
          ),

          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,

            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF4B5563),

              fontSize: 12,

              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,

              height: 1.0,
            ),

            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}
