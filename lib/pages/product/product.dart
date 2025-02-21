import 'package:esjerukkadiri/commons/containers/box_container.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/pages/product/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/controllers/product_controller.dart';
import 'package:esjerukkadiri/pages/product/product_grid_view.dart';
import 'package:esjerukkadiri/pages/product/product_list_view.dart';
import 'package:badges/badges.dart' as badges;

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            // title: SearchBarContainer(),
            backgroundColor: MyColors.primary,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image(
                  image: AssetImage('assets/images/header.jpeg'),
                  fit: BoxFit.cover,
                )),
            pinned: true,
            expandedHeight: 130,
            collapsedHeight: 35,
            toolbarHeight: 30,
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              BoxContainer(
                shadow: true,
                radius: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            CartPage(),
                          );
                        },
                        child: Row(
                          children: [
                            badges.Badge(
                              badgeContent: Text(
                                cartController.totalAllQuantity.value
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              badgeAnimation: badges.BadgeAnimation.fade(
                                  animationDuration:
                                      Duration(milliseconds: 400)),
                              child: Icon(
                                Icons.shopping_bag,
                                color: MyColors.green,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Rp',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: MySizes.fontSizeMd,
                                color: MyColors.primary,
                              ),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(1234567, 0),
                              style: const TextStyle(
                                fontSize: MySizes.fontSizeXl,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.save),
                        color: MyColors.green,
                      ),
                      IconButton(
                        onPressed: () {
                          productController.toggleShowListGrid();
                        },
                        icon: Icon((productController.showListGrid.value)
                            ? Icons.grid_view_rounded
                            : Icons.format_list_bulleted_rounded),
                        color: MyColors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Obx(() {
                  if (productController.showListGrid.value) {
                    return ProductListView();
                  } else {
                    return ProductGridView();
                  }
                }),
              ],
            ),
          )
        ],
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
