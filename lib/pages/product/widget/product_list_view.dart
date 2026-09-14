import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/product/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final ProductController productController;

  const ProductListView({
    super.key,
    required this.products,
    required this.productController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 9),
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          productController: productController,
          compact: true,
        );
      },
    );
  }
}
