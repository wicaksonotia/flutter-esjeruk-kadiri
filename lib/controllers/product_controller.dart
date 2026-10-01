import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/database/repositories/product_repository.dart';
import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:cashier/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final CartController cartController = Get.find<CartController>();

  final ProductRepository _productRepository = ProductRepository();

  final SyncService _syncService = Get.find<SyncService>();

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
  // OFFLINE STATE
  // ============================================================

  final isOffline = false.obs;

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchTextFieldController =
      TextEditingController();

  // ============================================================
  // GET ID KIOS
  // ============================================================

  Future<int> _getIdKios() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('id_kios') ?? 0;
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<void> fetchProductCategory() async {
    try {
      isLoadingProductCategory(true);

      final int idKios = await _getIdKios();

      if (idKios == 0) {
        productCategoryItems.clear();
        productItems.clear();

        return;
      }

      // ========================================================
      // 1. LOAD LOCAL TERLEBIH DAHULU
      // ========================================================

      final localCategories = await _productRepository.getLocalCategories(
        idKios: idKios,
      );

      if (localCategories.isNotEmpty) {
        productCategoryItems.assignAll(localCategories);
      }

      // ========================================================
      // 2. COBA SERVER
      // ========================================================

      final result = await RemoteDataSource.getProductCategories();

      if (result != null) {
        // ======================================================
        // SERVER BERHASIL
        // ======================================================

        productCategoryItems.assignAll(result);

        isOffline(false);

        // Simpan ke local database
        await _productRepository.saveCategories(
          idKios: idKios,
          categories: result,
        );
      } else {
        // ======================================================
        // SERVER GAGAL
        // ======================================================

        isOffline(true);
      }

      // ========================================================
      // 3. SETELAH CATEGORY → PRODUCT
      // ========================================================

      await fetchProduct();
    } catch (error) {
      debugPrint('FETCH PRODUCT CATEGORY ERROR: $error');

      isOffline(true);

      // ========================================================
      // FALLBACK LOCAL
      // ========================================================

      try {
        final int idKios = await _getIdKios();

        final localCategories = await _productRepository.getLocalCategories(
          idKios: idKios,
        );

        productCategoryItems.assignAll(localCategories);

        await fetchProduct();
      } catch (localError) {
        debugPrint('LOCAL CATEGORY ERROR: $localError');
      }
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

      final int idKios = await _getIdKios();

      debugPrint('========== FETCH PRODUCT ==========');

      debugPrint('id_kios: $idKios');

      debugPrint(
        'search: '
        '${searchTextFieldController.text.trim()}',
      );

      if (idKios == 0) {
        debugPrint('ID KIOS = 0');

        productItems.clear();

        return;
      }

      // ========================================================
      // 1. LOCAL DATA DULU
      // ========================================================

      final localProducts = await _productRepository.getLocalProducts(
        idKios: idKios,
      );

      if (localProducts.isNotEmpty) {
        productItems.assignAll(_filterLocalProducts(localProducts));
      }

      // ========================================================
      // 2. SERVER
      // ========================================================

      final rawFormat = {
        'search': searchTextFieldController.text.trim(),
        'category_id': 0,
        'id_kios': idKios,
      };

      try {
        final result = await RemoteDataSource.getProduct(rawFormat);

        debugPrint('PRODUCT RESULT: ${result?.length}');

        if (result != null) {
          // ====================================================
          // SERVER BERHASIL
          // ====================================================

          await _productRepository.saveProducts(
            idKios: idKios,
            products: result,
          );

          // Ambil lagi dari database agar source data
          // tetap konsisten dengan local database.
          final freshProducts = await _productRepository.getLocalProducts(
            idKios: idKios,
          );

          productItems.assignAll(_filterLocalProducts(freshProducts));

          isOffline(false);
        } else {
          isOffline(true);
        }
      } catch (serverError) {
        debugPrint('PRODUCT SERVER ERROR: $serverError');

        isOffline(true);

        // ======================================================
        // LOCAL SUDAH DITAMPILKAN DI ATAS
        // Jadi tidak perlu mengosongkan productItems.
        // ======================================================
      }

      debugPrint('===================================');
    } catch (error) {
      debugPrint('FETCH PRODUCT ERROR: $error');

      isOffline(true);

      // ========================================================
      // FALLBACK LOCAL
      // ========================================================

      try {
        final int idKios = await _getIdKios();

        final localProducts = await _productRepository.getLocalProducts(
          idKios: idKios,
        );

        productItems.assignAll(_filterLocalProducts(localProducts));
      } catch (localError) {
        debugPrint('LOCAL PRODUCT ERROR: $localError');
      }
    } finally {
      isLoadingProduct(false);
    }
  }

  // ============================================================
  // LOCAL PRODUCT FILTER
  // ============================================================

  List<ProductModel> _filterLocalProducts(List<ProductModel> products) {
    final String keyword = searchTextFieldController.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      return products;
    }

    return products.where((product) {
      final String name = product.productName?.toLowerCase().trim() ?? '';

      final String description =
          product.description?.toLowerCase().trim() ?? '';

      return name.contains(keyword) || description.contains(keyword);
    }).toList();
  }

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  Future<void> loadInitialData() async {
    await fetchProductCategory();
    Future.microtask(() async {
      await _syncService.syncPendingTransactions();
    });
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

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

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
