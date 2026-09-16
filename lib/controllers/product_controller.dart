import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final CartController cartController = Get.find<CartController>();

  // ============================================================
  // DATA
  // ============================================================

  final productCategoryItems = <ProductCategoryModel>[].obs;

  final productItems = <ProductModel>[].obs;

  // ============================================================
  // STATE
  // ============================================================

  final isLoadingProductCategory = false.obs;

  final isLoadingProduct = false.obs;

  final showListGrid = true.obs;

  final isEmptyValue = true.obs;

  final selectedCategoryId = 0.obs;

  final selectedCategoryName = 'Semua'.obs;

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchTextFieldController =
      TextEditingController();

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<void> fetchProductCategory() async {
    try {
      isLoadingProductCategory(true);

      final result = await RemoteDataSource.getProductCategories();

      if (result != null) {
        productCategoryItems.assignAll(result);
      } else {
        productCategoryItems.clear();
      }

      // ----------------------------------------------------------
      // Setelah kategori berhasil / selesai,
      // ambil produk.
      // ----------------------------------------------------------

      await fetchProduct();
    } catch (error) {
      debugPrint('FETCH PRODUCT CATEGORY ERROR: $error');

      Get.snackbar(
        'Notification',
        error.toString(),
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

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final int idKios = prefs.getInt('id_kios') ?? 0;

      debugPrint('========== FETCH PRODUCT ==========');

      debugPrint('id_kios: $idKios');

      debugPrint('search: ${searchTextFieldController.text.trim()}');

      if (idKios == 0) {
        debugPrint('ID KIOS = 0');

        productItems.clear();

        return;
      }

      final rawFormat = {
        'search': searchTextFieldController.text.trim(),
        'category_id': 0,
        'id_kios': idKios,
      };

      final result = await RemoteDataSource.getProduct(rawFormat);

      debugPrint('PRODUCT RESULT: ${result?.length}');

      debugPrint('===================================');

      if (result != null) {
        productItems.assignAll(result);
      } else {
        productItems.clear();
      }
    } catch (error) {
      debugPrint('FETCH PRODUCT ERROR: $error');

      Get.snackbar(
        'Notification',
        error.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingProduct(false);
    }
  }

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  Future<void> loadInitialData() async {
    await fetchProductCategory();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshProducts() async {
    await fetchProductCategory();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> searchProduct(String value) async {
    final keyword = value.trim();

    isEmptyValue.value = keyword.isEmpty;

    await fetchProduct();
  }

  Future<void> clearSearch() async {
    searchTextFieldController.clear();

    isEmptyValue.value = true;

    await fetchProduct();
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
    final int index = productItems.indexWhere(
      (item) => item.idProduct == product.idProduct,
    );

    if (index < 0) {
      return;
    }

    final bool oldValue = productItems[index].favorite ?? false;

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
    final String name =
        categoryNameById(product.idCategory).toLowerCase().trim();

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
