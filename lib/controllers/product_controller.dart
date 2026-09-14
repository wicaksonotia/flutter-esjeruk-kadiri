import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  // ============================================================
  // DATA
  // ============================================================

  final productCategoryItems = <ProductCategoryModel>[].obs;

  final productItems = <ProductModel>[].obs;

  // ============================================================
  // STATE
  // ============================================================

  final isLoadingProductCategory = true.obs;
  final isLoadingProduct = true.obs;

  final showListGrid = true.obs;

  final isEmptyValue = true.obs;

  final selectedCategoryId = 0.obs;

  final selectedCategoryName = 'Semua'.obs;

  final searchTextFieldController = TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchProductCategory();
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<bool> _checkPermission() async {
    final bluetoothStatus = await Permission.bluetoothConnect.status;

    final locationStatus = await Permission.location.status;

    if (bluetoothStatus.isGranted && locationStatus.isGranted) {
      return true;
    }

    final statuses =
        await [Permission.bluetoothConnect, Permission.location].request();

    final bluetoothGranted =
        statuses[Permission.bluetoothConnect]?.isGranted ?? false;

    final locationGranted = statuses[Permission.location]?.isGranted ?? false;

    if (!bluetoothGranted || !locationGranted) {
      Get.snackbar(
        'Permission Required',
        'Bluetooth and Location permissions are needed to print.',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );

      return false;
    }

    return true;
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<void> fetchProductCategory() async {
    try {
      isLoadingProductCategory(true);

      final permissionGranted = await _checkPermission();

      if (!permissionGranted) {
        return;
      }

      final result = await RemoteDataSource.getProductCategories();

      if (result != null) {
        productCategoryItems.assignAll(result);
      }

      await fetchProduct();
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingProductCategory(false);
    }
  }

  // ============================================================
  // PRODUCT
  // ============================================================

  Future<void> fetchProduct() async {
    try {
      isLoadingProduct(true);

      final prefs = await SharedPreferences.getInstance();

      final rawFormat = {
        'search': searchTextFieldController.text.trim(),

        // IMPORTANT:
        // Jangan filter category di API lagi.
        'category_id': 0,

        'id_kios': prefs.getInt('id_kios') ?? 0,
      };

      final result = await RemoteDataSource.getProduct(rawFormat);

      if (result != null) {
        productItems.assignAll(result);
      } else {
        productItems.clear();
      }
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingProduct(false);
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> searchProduct(String value) async {
    final keyword = value.trim();

    isEmptyValue.value = keyword.isEmpty;

    await fetchProduct();
  }

  void clearSearch() {
    searchTextFieldController.clear();

    isEmptyValue.value = true;

    fetchProduct();
  }

  // ============================================================
  // VIEW MODE
  // ============================================================

  void setListView() {
    if (!showListGrid.value) {
      showListGrid.value = true;
    }
  }

  void setGridView() {
    if (showListGrid.value) {
      showListGrid.value = false;
    }
  }

  void toggleShowListGrid() {
    showListGrid.toggle();
  }

  // ============================================================
  // FAVORITE
  // ============================================================

  Future<void> toggleFavorite(ProductModel product) async {
    final index = productItems.indexWhere(
      (item) => item.idProduct == product.idProduct,
    );

    if (index < 0) {
      return;
    }

    final oldValue = productItems[index].favorite ?? false;

    productItems[index].favorite = !oldValue;

    productItems.refresh();

    try {
      await RemoteDataSource.updateFavorite(productItems[index].toJson());
    } catch (error) {
      productItems[index].favorite = oldValue;

      productItems.refresh();

      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ============================================================
  // CATEGORY HELPERS
  // ============================================================

  String categoryNameById(int? categoryId) {
    if (categoryId == null) {
      return 'Lainnya';
    }

    final category = productCategoryItems.firstWhereOrNull(
      (item) => item.categoryId == categoryId,
    );

    return category?.categoryName?.trim().isNotEmpty == true
        ? category!.categoryName!.trim()
        : 'Lainnya';
  }

  bool isCategoryName(ProductModel product, String keyword) {
    final name = categoryNameById(product.idCategory).toLowerCase().trim();

    return name == keyword.toLowerCase();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    searchTextFieldController.dispose();

    super.onClose();
  }
}
