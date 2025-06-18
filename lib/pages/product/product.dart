import 'package:esjerukkadiri/commons/containers/box_container.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:esjerukkadiri/controllers/product_category_controller.dart';
import 'package:esjerukkadiri/drawer/nav_drawer.dart' as custom_drawer;
import 'package:esjerukkadiri/pages/product/categories.dart';
import 'package:esjerukkadiri/pages/product/footer.dart';
import 'package:esjerukkadiri/pages/product/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/pages/product/product_grid_view.dart';
import 'package:esjerukkadiri/pages/product/product_list_view.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductCategoryController productCategoryController =
      Get.find<ProductCategoryController>();
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: const FooterProduct(),
      body: RefreshIndicator(
        onRefresh: () async {
          productCategoryController.fetchProductCategory();
          productCategoryController.fetchProduct();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: MyColors.primary),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              backgroundColor: MyColors.primary,
              flexibleSpace: const FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image(
                  image: AssetImage('assets/images/header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              pinned: true,
              expandedHeight: 100,
              collapsedHeight: 50,
              toolbarHeight: 30,
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SearchBarContainer(
                      productCategoryController: productCategoryController,
                    ),
                    const BoxContainer(
                      shadow: true,
                      radius: 0,
                      alignment: Alignment.centerLeft,
                      child: CategoriesMenu(),
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return productCategoryController.showListGrid.value
                    ? ProductListView()
                    : ProductGridView();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _widget;

  _SliverAppBarDelegate(this._widget);

  @override
  double get minExtent => 78;

  @override
  double get maxExtent => 78;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
