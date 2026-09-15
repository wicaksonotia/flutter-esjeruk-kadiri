import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductLoadingShimmer extends StatefulWidget {
  const ProductLoadingShimmer({super.key});

  @override
  State<ProductLoadingShimmer> createState() => _ProductLoadingShimmerState();
}

class _ProductLoadingShimmerState extends State<ProductLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            final value = _controller.value;

            return LinearGradient(
              begin: Alignment(-1.5 + value * 3, 0),
              end: Alignment(-0.5 + value * 3, 0),
              colors: [
                MyColors.surface,
                MyColors.primaryLight,
                MyColors.surface,
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Obx(() {
        if (productController.showListGrid.value) {
          return const _ListShimmer();
        }

        return const _GridShimmer();
      }),
    );
  }
}

// ============================================================================
// LIST SHIMMER
// ============================================================================

class _ListShimmer extends StatelessWidget {
  const _ListShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
      child: Column(
        children: List.generate(
          8,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 9),
            child: _SkeletonListItem(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonListItem extends StatelessWidget {
  const _SkeletonListItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // ============================================================
          // IMAGE
          // ============================================================

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(11),
            ),
          ),

          const SizedBox(width: 12),

          // ============================================================
          // CONTENT
          // ============================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 13,
                  decoration: BoxDecoration(
                    color: MyColors.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: 90,
                  height: 11,
                  decoration: BoxDecoration(
                    color: MyColors.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: 75,
                  height: 14,
                  decoration: BoxDecoration(
                    color: MyColors.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ============================================================
          // ACTION
          // ============================================================
          Container(
            width: 74,
            height: 30,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// GRID SHIMMER
// ============================================================================

class _GridShimmer extends StatelessWidget {
  const _GridShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          int columns = 2;

          if (width >= 1200) {
            columns = 5;
          } else if (width >= 900) {
            columns = 4;
          } else if (width >= 650) {
            columns = 3;
          }

          const spacing = 11.0;

          final itemWidth = (width - (spacing * (columns - 1))) / columns;

          final itemHeight = itemWidth * 1.38;

          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: columns * 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              mainAxisExtent: itemHeight,
            ),
            itemBuilder: (_, _) {
              return const _SkeletonGridItem();
            },
          );
        },
      ),
    );
  }
}

class _SkeletonGridItem extends StatelessWidget {
  const _SkeletonGridItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // IMAGE
          // ============================================================

          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ============================================================
          // PRODUCT NAME
          // ============================================================
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 7),

          Container(
            width: 70,
            height: 11,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const Spacer(),

          // ============================================================
          // PRICE
          // ============================================================
          Container(
            width: 85,
            height: 14,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 8),

          // ============================================================
          // BUTTON
          // ============================================================
          Container(
            width: double.infinity,
            height: 28,
            decoration: BoxDecoration(
              color: MyColors.background,
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ],
      ),
    );
  }
}
