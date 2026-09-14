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
    if (compact) {
      return _buildListCard();
    }

    return _buildGridCard();
  }

  // ============================================================
  // GRID
  // ============================================================

  Widget _buildGridCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFE9EBEF)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .045),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ProductImage(image: product.photo1, size: 150, borderRadius: 20),

          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  product.productName ?? 'Produk',

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  product.description?.trim().isNotEmpty == true
                      ? product.description!
                      : 'Produk pilihan',

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8F98),
                  ),
                ),

                const SizedBox(height: 11),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Expanded(
                      child: Text(
                        _formatPrice(product.price),

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: MyColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 104,

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

  // ============================================================
  // LIST
  // ============================================================

  Widget _buildListCard() {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE9EBEF)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          ProductImage(image: product.photo1, size: 86, borderRadius: 14),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  product.productName ?? 'Produk',

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  product.description?.trim().isNotEmpty == true
                      ? product.description!
                      : 'Produk pilihan',

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8F98),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _formatPrice(product.price),

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: MyColors.primary,
                  ),
                ),
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

  String _formatPrice(int? price) {
    if (price == null) {
      return 'Rp 0';
    }

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
