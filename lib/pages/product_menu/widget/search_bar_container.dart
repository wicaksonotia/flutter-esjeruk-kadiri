import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  final ProductController productController;

  const SearchBarContainer({super.key, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () => Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EAED)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .035),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
              final query = value.trim();

              if (query.isEmpty) {
                productController.idProductCategory.value = 0;
              }

              productController.fetchProduct();
            },
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              hintStyle: const TextStyle(
                color: Color(0xFF9AA0A6),
                fontSize: 14,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 14, right: 8),
                child: Icon(
                  Icons.search_rounded,
                  size: 21,
                  color: MyColors.primary,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 43),
              suffixIcon:
                  productController.isEmptyValue.value
                      ? null
                      : IconButton(
                        tooltip: 'Hapus pencarian',
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 19,
                          color: Color(0xFF8A8F98),
                        ),
                        onPressed: () {
                          productController.searchTextFieldController.clear();

                          productController.isEmptyValue.value = true;

                          productController.idProductCategory.value = 0;

                          productController.fetchProduct();
                        },
                      ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
