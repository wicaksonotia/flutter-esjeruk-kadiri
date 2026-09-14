import 'package:cashier/commons/currency.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/models/cart_model.dart';
import 'package:cashier/pages/checkout/component/quantity_badge.dart';
import 'package:cashier/pages/product/widget/product_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutCartSection extends StatelessWidget {
  final CartController cartController;

  const CheckoutCartSection({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cartList = cartController.cartList;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.shopping_bag_outlined,
            title: 'Pesanan',
          ),

          const SizedBox(height: 14),

          if (cartList.isEmpty)
            const _EmptyCart()
          else
            Column(
              children: [
                for (final cart in cartList)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CheckoutCartItem(
                      cart: cart,
                      onRemove: () {
                        cartController.removeProduct(cart.productModel);
                      },
                    ),
                  ),
              ],
            ),
        ],
      );
    });
  }
}

class _CheckoutCartItem extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onRemove;

  const _CheckoutCartItem({required this.cart, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final product = cart.productModel;

    final price = product.price ?? 0;
    final quantity = cart.quantity;
    final total = price * quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEFF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProductImage(image: product.photo1, size: 64, borderRadius: 14),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  CurrencyFormat.convertToIdr(price, 0),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A808A),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    QuantityBadge(quantity: quantity),

                    const SizedBox(width: 8),

                    Text(
                      CurrencyFormat.convertToIdr(total, 0),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202124),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          _RemoveButton(onTap: onRemove),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: Color(0xFFEF4444),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF475569)),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202124),
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 28,
              color: Color(0xFF9CA3AF),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4B5563),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Tambahkan produk terlebih dahulu',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
