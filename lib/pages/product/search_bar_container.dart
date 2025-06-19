import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  final dynamic productController;
  const SearchBarContainer({super.key, required this.productController});

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
                        productController.isEmptyValue.value
                            ? null
                            : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                productController.searchTextFieldController
                                    .clear();
                                productController.isEmptyValue.value = true;
                                productController.fetchProduct();
                              },
                            ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: productController.searchTextFieldController,
                  onChanged: (value) {
                    value.isEmpty
                        ? productController.isEmptyValue.value = true
                        : productController.isEmptyValue.value = false;
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      productController.isEmptyValue.value = false;
                      productController.fetchProduct();
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
            //       productController.showListGrid.value =
            //           !productController.showListGrid.value;
            //     },
            //     child: Icon(
            //       (productController.showListGrid.value)
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
