import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  final ProductController productController;

  const SearchBarContainer({super.key, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: TextField(
        controller: productController.searchTextFieldController,

        textInputAction: TextInputAction.search,

        onChanged: (value) {
          productController.isEmptyValue.value = value.trim().isEmpty;
        },

        onSubmitted: (value) {
          productController.searchProduct(value);
        },

        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: 'Cari produk...',
          hintStyle: const TextStyle(color: Color(0xFF9AA0A6), fontSize: 13),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: MyColors.primary,
            size: 22,
          ),

          suffixIcon: Obx(() {
            if (productController.isEmptyValue.value) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.close_rounded, size: 19),
              color: Colors.grey.shade600,

              onPressed: productController.clearSearch,
            );
          }),

          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
