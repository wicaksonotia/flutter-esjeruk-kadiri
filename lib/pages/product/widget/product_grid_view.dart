import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/product/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  final List<ProductModel> products;
  final ProductController productController;

  const ProductGridView({
    super.key,
    required this.products,
    required this.productController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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

        // Tinggi card agar tidak overflow
        final itemHeight = itemWidth * 1.38;

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: itemHeight,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],
              productController: productController,
            );
          },
        );
      },
    );
  }
}
