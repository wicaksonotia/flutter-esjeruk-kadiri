import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/pages/change_outlet_page.dart';
import 'package:cashier/pages/product/categories.dart';
import 'package:cashier/pages/product/footer.dart';
import 'package:cashier/pages/product/product_grid_view.dart';
import 'package:cashier/pages/product/product_list_view.dart';
import 'package:cashier/pages/product/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      drawer: const custom_drawer.NavigationDrawer(),

      bottomNavigationBar: FooterProduct(cartController: cartController),

      body: RefreshIndicator(
        color: MyColors.primary,

        onRefresh: () async {
          // Jangan Future.wait dengan fetchProductCategory()
          // karena fetchProductCategory() sendiri memanggil fetchProduct().
          await productController.fetchProductCategory();
        },

        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),

          slivers: [
            _buildHeader(),

            SliverPersistentHeader(
              pinned: true,
              delegate: _ProductFilterDelegate(
                productController: productController,
              ),
            ),

            SliverToBoxAdapter(
              child: _ProductSection(productController: productController),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  SliverAppBar _buildHeader() {
    return SliverAppBar(
      backgroundColor: MyColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,

      pinned: true,

      expandedHeight: 135,
      collapsedHeight: 72,
      toolbarHeight: 72,

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

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [MyColors.primary, Color(0xFF1976D2)],
            ),
          ),

          child: const SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Text(
                  'Pilih produk untuk transaksi',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .82),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      builder: (_) => const ChangeOutletPage(),
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
          // Hanya bagian ini reactive
          Obx(
            () => Text(
              kasirController.namaKios.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 2),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hanya bagian ini reactive
              Obx(
                () => Text(
                  'Cabang ${kasirController.namaCabang.value}',
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 3),

              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PRODUCT SECTION
// ================================================================

class _ProductSection extends StatelessWidget {
  final ProductController productController;

  const _ProductSection({required this.productController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Hanya jumlah produk yang reactive
          Obx(
            () => _ProductSectionHeader(
              productCount: productController.productItems.length,
            ),
          ),

          const SizedBox(height: 4),

          // Hanya switch layout yang reactive.
          // ProductListView/ProductGridView sendiri sudah
          // mempunyai Obx untuk data produknya.
          Obx(() {
            if (productController.showListGrid.value) {
              return ProductListView();
            }

            return ProductGridView();
          }),
        ],
      ),
    );
  }
}

// ================================================================
// PRODUCT SECTION HEADER
// ================================================================

class _ProductSectionHeader extends StatelessWidget {
  final int productCount;

  const _ProductSectionHeader({required this.productCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Produk',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202124),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),

          decoration: BoxDecoration(
            color: MyColors.primary.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            '$productCount',
            style: const TextStyle(
              color: MyColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}

// ================================================================
// FILTER HEADER
// ================================================================

class _ProductFilterDelegate extends SliverPersistentHeaderDelegate {
  final ProductController productController;

  _ProductFilterDelegate({required this.productController});

  @override
  double get minExtent => 112;

  @override
  double get maxExtent => 112;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFF7F8FA),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          SearchBarContainer(productController: productController),

          const SizedBox(height: 10),

          const CategoriesMenu(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ProductFilterDelegate oldDelegate) {
    // Tidak ada property delegate yang perlu menyebabkan
    // rebuild. Search dan category masing-masing mengurus
    // reactive state mereka sendiri.
    return false;
  }
}
