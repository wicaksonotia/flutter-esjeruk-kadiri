import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var productCategoryItems = <ProductCategoryModel>[].obs;
  var productItems = <ProductModel>[].obs;
  var idProductCategory = 0.obs;
  var isLoadingProductCategory = true.obs;
  var isLoadingProduct = true.obs;
  var showListGrid = true.obs;
  var isEmptyValue = true.obs;
  final searchTextFieldController = TextEditingController();

  @override
  void onInit() {
    fetchProductCategory();
    super.onInit();
  }

  void fetchProductCategory() async {
    var bluetoothStatus = await Permission.bluetoothConnect.status;
    var locationStatus = await Permission.location.status;

    if (!bluetoothStatus.isGranted || !locationStatus.isGranted) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.bluetoothConnect, Permission.location].request();

      if (!statuses[Permission.bluetoothConnect]!.isGranted ||
          !statuses[Permission.location]!.isGranted) {
        Get.snackbar(
          'Permission Required',
          'Bluetooth and Location permissions are needed to print.',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    }

    try {
      isLoadingProductCategory(true);
      var result = await RemoteDataSource.getProductCategories();
      if (result != null) {
        // idProductCategory.value = result.first.categoryId ?? 0;
        productCategoryItems.assignAll(result);
        fetchProduct();
      }
    } finally {
      isLoadingProductCategory(false);
    }
  }

  void fetchProduct() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoadingProduct(true);
      var rawFormat = {
        'search': searchTextFieldController.text,
        'category_id': idProductCategory.value,
        'id_kios': prefs.getInt('id_kios') ?? 0,
      };
      var result = await RemoteDataSource.getProduct(rawFormat);
      if (result != null) {
        productItems.assignAll(result);
      }
    } finally {
      isLoadingProduct(false);
    }
  }

  toggleShowListGrid() {
    showListGrid(!showListGrid.value);
  }

  void toggleFavorite(int index) async {
    var product = productItems[index];
    product.favorite = !(product.favorite ?? false);
    productItems[index] = product;
    try {
      await RemoteDataSource.updateFavorite(productItems[index].toJson());
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
    if (idProductCategory.value == 1) {
      productItems.removeAt(index);
    }
  }
}
