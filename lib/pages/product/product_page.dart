import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/models/product_model.dart';
import 'package:cashier/pages/change_outlet_page.dart';
import 'package:cashier/pages/product/widget/categories.dart';
import 'package:cashier/pages/product/widget/footer.dart';
import 'package:cashier/pages/product/widget/product_grid_view.dart';
import 'package:cashier/pages/product/widget/product_list_view.dart';
import 'package:cashier/pages/product/widget/product_view_toggle.dart';
import 'package:cashier/pages/product/widget/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:cashier/models/product_category_target.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.find<ProductController>();

  final CartController cartController = Get.find<CartController>();

  final LoginController loginController = Get.find<LoginController>();

  final KasirController kasirController = Get.find<KasirController>();

  final ScrollController _scrollController = ScrollController();

  final Map<int, GlobalKey> _categoryKeys = {};

  bool _isCategoryJumping = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCategory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      drawer: const custom_drawer.NavigationDrawer(),

      bottomNavigationBar: FooterProduct(cartController: cartController),

      body: RefreshIndicator(
        color: MyColors.primary,

        onRefresh: () async {
          await productController.fetchProduct();

          if (!mounted) return;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeCategory(force: true);
          });
        },

        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,

          child: CustomScrollView(
            controller: _scrollController,

            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),

            slivers: [
              _buildAppBar(),

              SliverToBoxAdapter(child: _buildTopArea()),

              SliverPersistentHeader(
                pinned: true,

                delegate: _CategoryHeaderDelegate(
                  child: Container(
                    color: const Color(0xFFF6F7F9),

                    padding: const EdgeInsets.only(top: 4, bottom: 8),

                    child: CategoriesMenu(
                      onCategorySelected: _scrollToCategory,
                    ),
                  ),
                ),
              ),

              ..._buildCategorySlivers(),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,

      elevation: 0,

      backgroundColor: MyColors.primary,

      foregroundColor: Colors.white,

      toolbarHeight: 68,

      leading: Builder(
        builder: (context) {
          return IconButton(
            tooltip: 'Menu',

            icon: const Icon(Icons.menu_rounded, size: 25),

            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),

      titleSpacing: 0,

      title: _HeaderTitle(
        kasirController: kasirController,
        onChangeOutlet: _showChangeOutlet,
      ),

      actions: [
        IconButton(
          tooltip: 'Refresh',

          icon: const Icon(Icons.refresh_rounded),

          onPressed: () async {
            await productController.fetchProduct();

            if (!mounted) return;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeCategory(force: true);
            });
          },
        ),

        const SizedBox(width: 6),
      ],
    );
  }

  // ============================================================
  // TOP AREA
  // ============================================================

  Widget _buildTopArea() {
    return Container(
      color: MyColors.primary,

      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),

      child: Column(
        children: [
          SearchBarContainer(productController: productController),

          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pilih produk',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              ProductViewToggle(controller: productController),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY SLIVERS
  // ============================================================

  List<Widget> _buildCategorySlivers() {
    return [
      Obx(() {
        if (productController.isLoadingProduct.value) {
          return const SliverToBoxAdapter(child: _ProductLoading());
        }

        if (productController.productItems.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyProduct());
        }

        return SliverMainAxisGroup(slivers: _buildCategoryContent());
      }),
    ];
  }

  // ============================================================
  // CATEGORY CONTENT
  // ============================================================

  List<Widget> _buildCategoryContent() {
    final products = productController.productItems.toList();

    final categories = productController.productCategoryItems.toList();

    final slivers = <Widget>[];

    for (final category in categories) {
      final categoryId = category.categoryId;

      if (categoryId == null) {
        continue;
      }

      final categoryName = category.categoryName?.trim();

      if (categoryName == null || categoryName.isEmpty) {
        continue;
      }

      final categoryProducts =
          products
              .where((product) => product.idCategory == categoryId)
              .toList();

      if (categoryProducts.isEmpty) {
        continue;
      }

      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            key: _getCategoryKey(categoryId),

            child: _ProductCategorySection(
              categoryId: categoryId,

              title: categoryName,

              products: categoryProducts,

              productController: productController,
            ),
          ),
        ),
      );

      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 20)));
    }

    return slivers;
  }

  // ============================================================
  // CATEGORY KEY
  // ============================================================

  GlobalKey _getCategoryKey(int categoryId) {
    return _categoryKeys.putIfAbsent(categoryId, () => GlobalKey());
  }

  // ============================================================
  // INITIAL CATEGORY
  // ============================================================

  void _initializeCategory({bool force = false}) {
    if (!mounted) return;

    final products = productController.productItems.toList();

    final categories = productController.productCategoryItems.toList();

    if (products.isEmpty || categories.isEmpty) {
      return;
    }

    if (!force && productController.selectedCategoryId.value > 0) {
      return;
    }

    for (final category in categories) {
      final id = category.categoryId;

      if (id == null) {
        continue;
      }

      final hasProducts = products.any((product) => product.idCategory == id);

      if (!hasProducts) {
        continue;
      }

      productController.selectedCategoryId.value = id;

      return;
    }
  }

  // ============================================================
  // CATEGORY CLICK
  // ============================================================

  Future<void> _scrollToCategory(ProductCategoryTarget target) async {
    if (_isCategoryJumping) return;

    final key = _categoryKeys[target.id];
    final targetContext = key?.currentContext;

    if (targetContext == null) return;

    _isCategoryJumping = true;

    // Langsung ubah selected agar UI category menu mengikuti klik.
    productController.selectedCategoryId.value = target.id;

    try {
      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );

      // Category header kita pinned setinggi 58px.
      // Setelah ensureVisible selesai, section berada di paling atas
      // viewport. Geser kembali 58px supaya header section terlihat
      // tepat di bawah category menu.
      const double categoryMenuHeight = 58;

      final targetOffset = (_scrollController.offset - categoryMenuHeight)
          .clamp(0.0, _scrollController.position.maxScrollExtent);

      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    } finally {
      _isCategoryJumping = false;
    }
  }

  // ============================================================
  // SCROLL NOTIFICATION
  // ============================================================

  bool _onScrollNotification(ScrollNotification notification) {
    if (_isCategoryJumping) {
      return false;
    }

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) {
        return false;
      }

      _updateCategoryFromScroll();
    }

    return false;
  }

  // ============================================================
  // UPDATE CATEGORY FROM MANUAL SCROLL
  // ============================================================

  void _updateCategoryFromScroll() {
    if (!mounted) {
      return;
    }

    final categories = productController.productCategoryItems.toList();

    if (categories.isEmpty) {
      return;
    }

    const double categoryHeaderHeight = 58;

    const double activationOffset = 90;

    int? activeCategory;

    double bestDistance = double.infinity;

    for (final category in categories) {
      final id = category.categoryId;

      if (id == null) {
        continue;
      }

      final context = _categoryKeys[id]?.currentContext;

      if (context == null) {
        continue;
      }

      final renderObject = context.findRenderObject();

      if (renderObject is! RenderBox) {
        continue;
      }

      if (!renderObject.hasSize) {
        continue;
      }

      final position = renderObject.localToGlobal(Offset.zero);

      final top = position.dy;

      final effectiveTop = top - categoryHeaderHeight;

      // Kategori yang sudah melewati garis
      // aktivasi menjadi kandidat aktif.
      if (effectiveTop <= activationOffset) {
        final distance = (activationOffset - effectiveTop).abs();

        if (distance < bestDistance) {
          bestDistance = distance;

          activeCategory = id;
        }
      }
    }

    if (activeCategory == null) {
      return;
    }

    if (productController.selectedCategoryId.value != activeCategory) {
      productController.selectedCategoryId.value = activeCategory;
    }
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  void _showChangeOutlet() {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.white,

      constraints: const BoxConstraints(minWidth: double.infinity),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (_) {
        return const ChangeOutletPage();
      },
    );
  }
}

// ================================================================
// HEADER TITLE
// ================================================================

class _HeaderTitle extends StatelessWidget {
  final KasirController kasirController;

  final VoidCallback onChangeOutlet;

  const _HeaderTitle({
    required this.kasirController,
    required this.onChangeOutlet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChangeOutlet,

      behavior: HitTestBehavior.opaque,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Obx(
            () => Text(
              kasirController.namaKios.value,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 15,

                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 1),

          Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Obx(
                () => Text(
                  'Cabang ${kasirController.namaCabang.value}',

                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .78),

                    fontSize: 11,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Icon(
                Icons.keyboard_arrow_down_rounded,

                color: Colors.white,

                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PRODUCT CATEGORY SECTION
// ================================================================

class _ProductCategorySection extends StatelessWidget {
  final int categoryId;
  final String title;
  final List<ProductModel> products;
  final ProductController productController;

  const _ProductCategorySection({
    required this.categoryId,
    required this.title,
    required this.products,
    required this.productController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202124),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${products.length}',
                  style: const TextStyle(
                    color: MyColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Obx(() {
            if (productController.showListGrid.value) {
              return ProductListView(
                products: products,
                productController: productController,
              );
            }

            return ProductGridView(
              products: products,
              productController: productController,
            );
          }),
        ],
      ),
    );
  }
}

// ================================================================
// CATEGORY HEADER
// ================================================================

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CategoryHeaderDelegate({required this.child});

  @override
  double get minExtent => 58;

  @override
  double get maxExtent => 58;

  @override
  Widget build(
    BuildContext context,

    double shrinkOffset,

    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
    return false;
  }
}

// ================================================================
// LOADING
// ================================================================

class _ProductLoading extends StatelessWidget {
  const _ProductLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),

      child: Center(child: CircularProgressIndicator()),
    );
  }
}

// ================================================================
// EMPTY
// ================================================================

class _EmptyProduct extends StatelessWidget {
  const _EmptyProduct();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),

      child: Column(
        children: [
          Container(
            width: 80,

            height: 80,

            decoration: BoxDecoration(
              color: Colors.white,

              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),

                  blurRadius: 20,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: const Icon(
              Icons.inventory_2_outlined,

              size: 36,

              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Produk tidak ditemukan',

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 5),

          const Text(
            'Coba gunakan kata pencarian lain.',

            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
