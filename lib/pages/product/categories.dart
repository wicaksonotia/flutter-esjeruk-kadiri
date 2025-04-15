import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/lists.dart';
import 'package:esjerukkadiri/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({super.key});

  @override
  State<CategoriesMenu> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  int? segmentedControlGroupValue = 8;
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
        backgroundColor: Colors.transparent,
        thumbColor: MyColors.primary,
        padding: const EdgeInsets.all(5),
        groupValue: segmentedControlGroupValue,
        children: Map.fromEntries(
          kategori.map(
            (item) => MapEntry(
              item['value'] as int,
              Text(
                item['nama'] ?? "",
                style: TextStyle(
                  color: segmentedControlGroupValue == item['value']
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ),
        onValueChanged: (int? i) {
          if (i != null) {
            productController.idProductCategory.value = i;
            productController.fetchProduct();
            setState(() {
              segmentedControlGroupValue = i;
            });
          }
        });
  }
}
