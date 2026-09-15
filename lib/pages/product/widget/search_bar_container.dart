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
      height: 54,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: MyColors.border.withValues(alpha: .75),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 14,
            offset: const Offset(0, 5),
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

        cursorColor: MyColors.primary,

        style: const TextStyle(
          color: MyColors.textPrimary,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),

        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,

          hintText: 'Cari menu atau produk...',

          hintStyle: const TextStyle(
            color: MyColors.textMuted,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 8),

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(9),
              ),

              child: const Icon(
                Icons.search_rounded,
                color: MyColors.primaryDark,
                size: 18,
              ),
            ),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 54,
            minHeight: 54,
          ),

          suffixIcon: Obx(() {
            if (productController.isEmptyValue.value) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(right: 6),

              child: IconButton(
                tooltip: 'Hapus pencarian',

                splashRadius: 18,

                icon: const Icon(Icons.close_rounded, size: 18),

                color: MyColors.textMuted,

                onPressed: productController.clearSearch,
              ),
            );
          }),

          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 54,
          ),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 4,
          ),
        ),
      ),
    );
  }
}
