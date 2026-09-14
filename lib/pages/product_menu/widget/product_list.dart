import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/pages/product_menu/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingProduct.value) {
        return _buildLoading();
      }

      if (controller.productItems.isEmpty) {
        return const _EmptyListProduct();
      }

      return ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.productItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          return ProductCard(
            product: controller.productItems[index],
            index: index,
            compact: true,
          );
        },
      );
    });
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 102,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyListProduct extends StatelessWidget {
  const _EmptyListProduct();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 44, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'Produk tidak ditemukan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Coba gunakan kata kunci lain.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
