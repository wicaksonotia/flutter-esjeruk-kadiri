import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/product/increment_and_decrement.dart';
import 'package:cashier/pages/product/product_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;
  final bool compact;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    this.compact = false,
  });

  ProductController get controller => Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EBEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: compact ? _buildListCard() : _buildGridCard(),
    );
  }

  Widget _buildGridCard() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(
            favorite: product.favorite ?? false,
            onFavorite: () {
              controller.toggleFavorite(index);
            },
            height: 120,
          ),

          const SizedBox(height: 11),

          Text(
            product.productName ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202124),
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Text(
              product.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: Color(0xFF7A8088),
              ),
            ),
          ),

          const SizedBox(height: 5),

          ProductPrice(dataPrice: product.price!),

          const SizedBox(height: 9),

          SizedBox(
            width: double.infinity,
            child: Center(child: IncrementAndDecrement(dataProduct: product)),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _ProductImage(
            favorite: product.favorite ?? false,
            onFavorite: () {
              controller.toggleFavorite(index);
            },
            width: 82,
            height: 82,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Expanded(
                    child: Text(
                      product.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A8088),
                      ),
                    ),
                  ),

                  ProductPrice(dataPrice: product.price!),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          IncrementAndDecrement(dataProduct: product),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final bool favorite;
  final VoidCallback onFavorite;
  final double? width;
  final double height;

  const _ProductImage({
    required this.favorite,
    required this.onFavorite,
    this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/orange_ice.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.local_drink_outlined,
                    size: 40,
                    color: Color(0xFFB8BEC7),
                  );
                },
              ),
            ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.white.withValues(alpha: .94),
              shape: const CircleBorder(),
              elevation: 1,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onFavorite,
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 17,
                    color:
                        favorite ? Colors.redAccent : const Color(0xFF7A8088),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
