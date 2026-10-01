import 'package:cashier/database/app_database.dart';
import 'package:cashier/models/product_category_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class ProductRepository {
  final AppDatabase _db = Get.find<AppDatabase>();

  // ==========================================================
  // LOCAL CATEGORIES
  // ==========================================================

  Future<List<ProductCategoryModel>> getLocalCategories({
    required int idKios,
  }) async {
    final rows =
        await (_db.select(_db.categories)
              ..where((tbl) => tbl.idKios.equals(idKios))
              ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.name)]))
            .get();

    return rows.map((row) {
      return ProductCategoryModel(
        categoryId: row.serverId,
        categoryName: row.name,
      );
    }).toList();
  }

  // ==========================================================
  // LOCAL PRODUCTS
  // ==========================================================

  Future<List<ProductModel>> getLocalProducts({required int idKios}) async {
    final rows =
        await (_db.select(_db.products)
              ..where((tbl) => tbl.idKios.equals(idKios))
              ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.name)]))
            .get();

    return rows.map((row) {
      return ProductModel(
        idProduct: row.serverId,
        idCategory: row.categoryId,
        productName: row.name,
        description: row.description,
        price: row.price,
        photo1: row.photo,
        favorite: row.favorite,
      );
    }).toList();
  }

  // ==========================================================
  // SAVE CATEGORIES
  // ==========================================================

  Future<void> saveCategories({
    required int idKios,
    required List<ProductCategoryModel> categories,
  }) async {
    await _db.transaction(() async {
      for (final category in categories) {
        if (category.categoryId == null) {
          continue;
        }

        final existing =
            await (_db.select(_db.categories)..where(
              (tbl) =>
                  tbl.serverId.equals(category.categoryId!) &
                  tbl.idKios.equals(idKios),
            )).getSingleOrNull();

        final companion = CategoriesCompanion(
          serverId: drift.Value(category.categoryId!),
          idKios: drift.Value(idKios),
          name: drift.Value(category.categoryName ?? ''),
          updatedAt: drift.Value(DateTime.now()),
        );

        if (existing == null) {
          await _db.into(_db.categories).insert(companion);
        } else {
          await (_db.update(_db.categories)
            ..where((tbl) => tbl.id.equals(existing.id))).write(companion);
        }
      }
    });
  }

  // ==========================================================
  // SAVE PRODUCTS
  // ==========================================================

  Future<void> saveProducts({
    required int idKios,
    required List<ProductModel> products,
  }) async {
    await _db.transaction(() async {
      for (final product in products) {
        if (product.idProduct == null) {
          continue;
        }

        final existing =
            await (_db.select(_db.products)..where(
              (tbl) =>
                  tbl.serverId.equals(product.idProduct!) &
                  tbl.idKios.equals(idKios),
            )).getSingleOrNull();

        final companion = ProductsCompanion(
          serverId: drift.Value(product.idProduct!),
          idKios: drift.Value(idKios),
          categoryId: drift.Value(product.idCategory),
          name: drift.Value(product.productName ?? ''),
          description: drift.Value(product.description),
          price: drift.Value(product.price ?? 0),
          photo: drift.Value(product.photo1),
          favorite: drift.Value(product.favorite ?? false),
          updatedAt: drift.Value(DateTime.now()),
        );

        if (existing == null) {
          await _db.into(_db.products).insert(companion);
        } else {
          await (_db.update(_db.products)
            ..where((tbl) => tbl.id.equals(existing.id))).write(companion);
        }
      }
    });
  }

  // ==========================================================
  // CLEAR PRODUCTS
  // ==========================================================

  Future<void> clearLocalProducts({required int idKios}) async {
    await (_db.delete(_db.products)
      ..where((tbl) => tbl.idKios.equals(idKios))).go();
  }

  // ==========================================================
  // CLEAR CATEGORIES
  // ==========================================================

  Future<void> clearLocalCategories({required int idKios}) async {
    await (_db.delete(_db.categories)
      ..where((tbl) => tbl.idKios.equals(idKios))).go();
  }

  // ==========================================================
  // SYNC FROM SERVER
  // ==========================================================

  Future<bool> syncFromServer({required int idKios}) async {
    try {
      // ========================================================
      // CATEGORY
      // ========================================================

      final categories = await RemoteDataSource.getProductCategories();

      if (categories == null) {
        return false;
      }

      // ========================================================
      // PRODUCT
      // ========================================================

      final products = await RemoteDataSource.getProduct({
        'search': '',
        'category_id': 0,
        'id_kios': idKios,
      });

      if (products == null) {
        return false;
      }

      // ========================================================
      // SAVE LOCAL
      // ========================================================

      await saveCategories(idKios: idKios, categories: categories);

      await saveProducts(idKios: idKios, products: products);

      return true;
    } catch (error) {
      return false;
    }
  }

  // ==========================================================
  // LOCAL FIRST
  // ==========================================================

  Future<ProductCacheResult> loadProducts({required int idKios}) async {
    // ========================================================
    // LOAD LOCAL
    // ========================================================

    final localCategories = await getLocalCategories(idKios: idKios);

    final localProducts = await getLocalProducts(idKios: idKios);

    final hasLocalData = localCategories.isNotEmpty || localProducts.isNotEmpty;

    // ========================================================
    // TRY SERVER
    // ========================================================

    bool syncSuccess = false;

    try {
      syncSuccess = await syncFromServer(idKios: idKios);
    } catch (_) {
      syncSuccess = false;
    }

    // ========================================================
    // SERVER SUCCESS
    // ========================================================

    if (syncSuccess) {
      final freshCategories = await getLocalCategories(idKios: idKios);

      final freshProducts = await getLocalProducts(idKios: idKios);

      return ProductCacheResult(
        categories: freshCategories,
        products: freshProducts,
        fromCache: false,
        syncSuccess: true,
      );
    }

    // ========================================================
    // SERVER FAILED → LOCAL
    // ========================================================

    return ProductCacheResult(
      categories: localCategories,
      products: localProducts,
      fromCache: hasLocalData,
      syncSuccess: false,
    );
  }
}

// ============================================================
// CACHE RESULT
// ============================================================

class ProductCacheResult {
  final List<ProductCategoryModel> categories;

  final List<ProductModel> products;

  final bool fromCache;

  final bool syncSuccess;

  ProductCacheResult({
    required this.categories,
    required this.products,
    required this.fromCache,
    required this.syncSuccess,
  });
}
