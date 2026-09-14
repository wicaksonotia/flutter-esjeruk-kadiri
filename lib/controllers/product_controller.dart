import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final productCategoryItems = <ProductCategoryModel>[].obs;

  final productItems = <ProductModel>[].obs;

  final idProductCategory = 0.obs;

  final isLoadingProductCategory = true.obs;

  final isLoadingProduct = true.obs;

  final showListGrid = true.obs;

  final isEmptyValue = true.obs;

  final searchTextFieldController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProductCategory();
  }

  Future<void> fetchProductCategory() async {
    final bluetoothStatus = await Permission.bluetoothConnect.status;

    final locationStatus = await Permission.location.status;

    if (!bluetoothStatus.isGranted || !locationStatus.isGranted) {
      final statuses =
          await [Permission.bluetoothConnect, Permission.location].request();

      if (!statuses[Permission.bluetoothConnect]!.isGranted ||
          !statuses[Permission.location]!.isGranted) {
        Get.snackbar(
          'Permission Required',
          'Bluetooth and Location permissions are needed to print.',
          icon: const Icon(Icons.error_outline_rounded),
          snackPosition: SnackPosition.TOP,
        );

        return;
      }
    }

    try {
      isLoadingProductCategory(true);

      final result = await RemoteDataSource.getProductCategories();

      if (result != null) {
        productCategoryItems.assignAll(result);
      }

      await fetchProduct();
    } finally {
      isLoadingProductCategory(false);
    }
  }

  Future<void> fetchProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoadingProduct(true);

      final rawFormat = {
        'search': searchTextFieldController.text.trim(),
        'category_id': idProductCategory.value,
        'id_kios': prefs.getInt('id_kios') ?? 0,
      };

      final result = await RemoteDataSource.getProduct(rawFormat);

      if (result != null) {
        productItems.assignAll(result);
      }
    } finally {
      isLoadingProduct(false);
    }
  }

  void toggleShowListGrid() {
    showListGrid.toggle();
  }

  Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= productItems.length) {
      return;
    }

    final product = productItems[index];

    product.favorite = !(product.favorite ?? false);

    productItems[index] = product;

    try {
      await RemoteDataSource.updateFavorite(product.toJson());
    } catch (error) {
      product.favorite = !(product.favorite ?? false);

      productItems[index] = product;

      Get.snackbar(
        'Gagal',
        error.toString(),
        icon: const Icon(Icons.error_outline_rounded),
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    if (idProductCategory.value == 1) {
      productItems.removeAt(index);
    }
  }

  @override
  void onClose() {
    searchTextFieldController.dispose();
    super.onClose();
  }
}
