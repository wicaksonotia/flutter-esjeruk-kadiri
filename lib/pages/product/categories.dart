import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/controllers/product_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({super.key});

  @override
  State<CategoriesMenu> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  final ProductCategoryController productCategoryController =
      Get.find<ProductCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productCategoryController.isLoadingProductCategory.value) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                productCategoryController.productCategoryItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // Prepare the list with "All" and "Favorite" at the beginning
      final items = [
        {'id': 0, 'name': 'All'},
        {'id': 1, 'name': 'Favorite'},
        ...productCategoryController.productCategoryItems.map(
          (item) => {
            'id': item.categoryId ?? 0,
            'name': item.categoryName ?? "",
          },
        ),
      ];

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CupertinoSlidingSegmentedControl(
          backgroundColor: Colors.transparent,
          thumbColor: MyColors.primary,
          padding: const EdgeInsets.all(5),
          groupValue: productCategoryController.idProductCategory.value,
          children: Map<int, Widget>.fromEntries(
            items.map(
              (item) => MapEntry(
                item['id'] as int,
                Text(
                  item['name'] as String,
                  style: TextStyle(
                    color:
                        productCategoryController.idProductCategory.value ==
                                item['id']
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          onValueChanged: (value) {
            setState(() {
              productCategoryController.idProductCategory.value = value!;
              productCategoryController.fetchProduct();
            });
          },
        ),
      );
    });
  }
}
