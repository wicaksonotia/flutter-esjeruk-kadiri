import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  final dynamic productCategoryController;
  const SearchBarContainer({
    super.key,
    required this.productCategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Search produk ...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixIcon:
                        productCategoryController.isEmptyValue.value
                            ? null
                            : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                productCategoryController
                                    .searchTextFieldController
                                    .clear();
                                productCategoryController.isEmptyValue.value =
                                    true;
                                productCategoryController.fetchProduct();
                              },
                            ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller:
                      productCategoryController.searchTextFieldController,
                  onChanged: (value) {
                    value.isEmpty
                        ? productCategoryController.isEmptyValue.value = true
                        : productCategoryController.isEmptyValue.value = false;
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      productCategoryController.isEmptyValue.value = false;
                      productCategoryController.fetchProduct();
                    }
                  },
                ),
              ),
            ),
            // Container(
            //   color: Colors.white,
            //   width: 40, // Fixed width for the icon button
            //   child: GestureDetector(
            //     onTap: () {
            //       productCategoryController.showListGrid.value =
            //           !productCategoryController.showListGrid.value;
            //     },
            //     child: Icon(
            //       (productCategoryController.showListGrid.value)
            //           ? Icons.grid_view_rounded
            //           : Icons.format_list_bulleted_rounded,
            //       color: Colors.black54,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
