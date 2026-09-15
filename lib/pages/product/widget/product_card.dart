import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/product/widget/increment_and_decrement.dart';
import 'package:cashier/pages/product/widget/product_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductController productController;
  final bool compact;

  const ProductCard({
    super.key,
    required this.product,
    required this.productController,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return compact ? _buildListCard() : _buildGridCard();
  }

  // ================================================================
  // GRID CARD
  // ================================================================

  Widget _buildGridCard() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MyColors.border),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ProductImage(image: product.photo1, borderRadius: 0),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductName(name: product.productName),

                const SizedBox(height: 4),

                _ProductDescription(description: product.description),

                const SizedBox(height: 9),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _ProductPrice(price: product.price)),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 82,
                      child: IncrementAndDecrement(dataProduct: product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LIST CARD
  // ================================================================

  Widget _buildListCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.border),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ProductImage(image: product.photo1, size: 82, borderRadius: 13),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProductName(name: product.productName, fontSize: 14),

                const SizedBox(height: 4),

                _ProductDescription(
                  description: product.description,
                  fontSize: 11,
                ),

                const SizedBox(height: 9),

                _ProductPrice(price: product.price),
              ],
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 104,
            child: IncrementAndDecrement(dataProduct: product),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// PRODUCT NAME
// ==================================================================

class _ProductName extends StatelessWidget {
  final String? name;
  final double fontSize;

  const _ProductName({required this.name, this.fontSize = 13.5});

  @override
  Widget build(BuildContext context) {
    final value = name?.trim();

    return Text(
      value?.isNotEmpty == true ? value! : 'Produk',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: MyColors.textPrimary,
        height: 1.15,
      ),
    );
  }
}

// ==================================================================
// PRODUCT DESCRIPTION
// ==================================================================

class _ProductDescription extends StatelessWidget {
  final String? description;
  final double fontSize;

  const _ProductDescription({required this.description, this.fontSize = 10.5});

  @override
  Widget build(BuildContext context) {
    final value = description?.trim();

    return Text(
      value?.isNotEmpty == true ? value! : 'Produk pilihan',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: MyColors.textSecondary,
      ),
    );
  }
}

// ==================================================================
// PRODUCT PRICE
// ==================================================================

class _ProductPrice extends StatelessWidget {
  final int? price;

  const _ProductPrice({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatPrice(price),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
        color: MyColors.primaryDark,
      ),
    );
  }

  String _formatPrice(int? price) {
    if (price == null) return 'Rp 0';

    final value = price.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      final position = value.length - i;

      buffer.write(value[i]);

      if (position > 1 && position % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString()}';
  }
}
