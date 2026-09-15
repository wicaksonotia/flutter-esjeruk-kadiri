import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/product_category_target.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/product/widget/category_menu.dart';
import 'package:cashier/pages/product/widget/footer.dart';
import 'package:cashier/pages/product/widget/product_grid_view.dart';
import 'package:cashier/pages/product/widget/product_hero_header.dart';
import 'package:cashier/pages/product/widget/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final ProductController productController;
  late final CartController cartController;

  // ============================================================
  // SCAFFOLD
  // ============================================================

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ============================================================
  // SCROLL
  // ============================================================

  final ScrollController _scrollController = ScrollController();

  final Map<int, GlobalKey> _categoryKeys = {};

  bool _isCategoryJumping = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    productController = Get.find<ProductController>();
    cartController = Get.find<CartController>();

    _scrollController.addListener(_handleScroll);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshProducts() async {
    await productController.fetchProductCategory();
  }

  // ============================================================
  // OPEN DRAWER
  // ============================================================

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // ============================================================
  // CATEGORY SCROLL TRACKING
  // ============================================================

  void _handleScroll() {
    if (_isCategoryJumping) {
      return;
    }

    final categories = productController.productCategoryItems.toList();

    if (categories.isEmpty) {
      return;
    }

    int? activeCategoryId;

    double closestDistance = double.infinity;

    for (final category in categories) {
      final categoryId = category.categoryId;

      if (categoryId == null) {
        continue;
      }

      final key = _categoryKeys[categoryId];

      if (key?.currentContext == null) {
        continue;
      }

      final renderObject = key!.currentContext!.findRenderObject();

      if (renderObject is! RenderBox) {
        continue;
      }

      final position = renderObject.localToGlobal(Offset.zero);

      final distance = (position.dy - 180).abs();

      if (distance < closestDistance) {
        closestDistance = distance;
        activeCategoryId = categoryId;
      }
    }

    if (activeCategoryId != null &&
        productController.selectedCategoryId.value != activeCategoryId) {
      productController.selectedCategoryId.value = activeCategoryId;
    }
  }

  // ============================================================
  // CATEGORY SELECT
  // ============================================================

  Future<void> _onCategorySelected(ProductCategoryTarget target) async {
    final categoryId = target.categoryId;

    if (categoryId == null) {
      return;
    }

    productController.selectedCategoryId.value = categoryId;

    final key = _categoryKeys[categoryId];

    if (key?.currentContext == null) {
      return;
    }

    _isCategoryJumping = true;

    await Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: .04,
    );

    await Future.delayed(const Duration(milliseconds: 80));

    _isCategoryJumping = false;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: MyColors.background,

      drawer: const custom_drawer.NavigationDrawer(),

      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: MyColors.primary,
          backgroundColor: MyColors.surface,
          onRefresh: _refreshProducts,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedHeaderDelegate(
                  child: ProductHeroHeader(onMenuTap: _openDrawer),
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedCategoryDelegate(
                  child: CategoriesMenu(
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
                sliver: _buildProductCategories(),
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // CART
      // ==========================================================
      bottomNavigationBar: FooterProduct(cartController: cartController),
    );
  }

  // ============================================================
  // PRODUCT CATEGORIES
  // ============================================================

  Widget _buildProductCategories() {
    return Obx(() {
      final categories = productController.productCategoryItems.toList();

      if (categories.isEmpty) {
        return const SliverToBoxAdapter(child: _EmptyProductState());
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];

          final categoryId = category.categoryId;

          final categoryName = category.categoryName?.trim();

          if (categoryId == null ||
              categoryName == null ||
              categoryName.isEmpty) {
            return const SizedBox.shrink();
          }

          _categoryKeys.putIfAbsent(categoryId, () => GlobalKey());

          final products =
              productController.productItems
                  .where((product) => product.idCategory == categoryId)
                  .toList();

          if (products.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            key: _categoryKeys[categoryId],
            padding: EdgeInsets.only(
              bottom: index == categories.length - 1 ? 0 : 22,
            ),
            child: _ProductCategorySection(
              title: categoryName,
              products: products,
              productController: productController,
            ),
          );
        }, childCount: categories.length),
      );
    });
  }
}

// ==================================================================
// SLIVER PERSISTENT HEADER DELEGATES
// ==================================================================
class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _PinnedHeaderDelegate({required this.child});

  @override
  double get minExtent => 176;

  @override
  double get maxExtent => 176;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(color: MyColors.background, child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// ==================================================================
// SLIVER PERSISTENT HEADER DELEGATES
// ==================================================================
class _PinnedCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _PinnedCategoryDelegate({required this.child});

  @override
  double get minExtent => 111;

  @override
  double get maxExtent => 111;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: MyColors.background,
      elevation: overlapsContent ? 1 : 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedCategoryDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// ==================================================================
// PRODUCT CATEGORY SECTION
// ==================================================================

class _ProductCategorySection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final ProductController productController;

  const _ProductCategorySection({
    required this.title,
    required this.products,
    required this.productController,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isList = productController.showListGrid.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, itemCount: products.length),

          const SizedBox(height: 10),

          if (isList)
            ProductListView(
              products: products,
              productController: productController,
            )
          else
            ProductGridView(
              products: products,
              productController: productController,
            ),
        ],
      );
    });
  }
}

// ==================================================================
// SECTION HEADER
// ==================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final int itemCount;

  const _SectionHeader({required this.title, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 21,
          decoration: BoxDecoration(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
              letterSpacing: -.2,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$itemCount Menu',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MyColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// EMPTY STATE
// ==================================================================

class _EmptyProductState extends StatelessWidget {
  const _EmptyProductState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: MyColors.primaryDark,
              size: 30,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Menu belum tersedia',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Tarik layar ke bawah untuk memuat ulang.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: MyColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
