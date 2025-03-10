import 'package:esjerukkadiri/commons/containers/box_container.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:esjerukkadiri/pages/product/categories.dart';
import 'package:esjerukkadiri/pages/product/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/controllers/product_controller.dart';
import 'package:esjerukkadiri/pages/product/product_grid_view.dart';
import 'package:esjerukkadiri/pages/product/product_list_view.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: const FooterProduct(),
      body: RefreshIndicator(
        onRefresh: () async {
          productController.fetchProduct();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                PopupMenuButton(
                  color: Colors.white,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onSelected: (dynamic value) {},
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Obx(
                        () => ListTile(
                          leading: Icon(
                            (productController.showListGrid.value)
                                ? Icons.grid_view_rounded
                                : Icons.format_list_bulleted_rounded,
                          ),
                          title: Text((productController.showListGrid.value)
                              ? 'Grid view'
                              : 'List view'),
                          onTap: () {
                            productController.showListGrid.value =
                                !productController.showListGrid.value;
                          },
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                          leading: const Icon(Icons.edit_document),
                          title: const Text('Report'),
                          onTap: () {
                            Get.back();
                            Get.toNamed('/reporttransaction');
                          }),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      child: ListTile(
                          leading: const Icon(Icons.bluetooth_searching),
                          title: const Text('Setting Bluetooth'),
                          onTap: () {
                            Get.back();
                            Get.toNamed('/bluetooth_setting');
                          }),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
                          loginController.logout();
                        },
                      ),
                    ),
                  ],
                ),
              ],
              backgroundColor: MyColors.green,
              flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Image(
                    image: AssetImage('assets/images/header.png'),
                    fit: BoxFit.cover,
                  )),
              pinned: true,
              expandedHeight: 130,
              collapsedHeight: 50,
              toolbarHeight: 30,
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                const BoxContainer(
                  shadow: true,
                  radius: 0,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: CategoriesMenu(),
                ),
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return productController.showListGrid.value
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
  double get minExtent => 40.0;

  @override
  double get maxExtent => 40.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
