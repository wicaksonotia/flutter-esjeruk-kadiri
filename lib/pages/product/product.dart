import 'package:cashier/commons/containers/box_container.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/pages/change_outlet_page.dart';
import 'package:cashier/pages/product/categories.dart';
import 'package:cashier/pages/product/footer.dart';
import 'package:cashier/pages/product/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier/commons/colors.dart';
import 'package:cashier/pages/product/product_grid_view.dart';
import 'package:cashier/pages/product/product_list_view.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

// Widget to use behind the curved app bar for background color
class CurvedAppBarBackground extends StatelessWidget {
  final Color color;
  final double height;

  const CurvedAppBarBackground({
    required this.color,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CurvedAppBarBackgroundPainter(color)),
    );
  }
}

class _CurvedAppBarBackgroundPainter extends CustomPainter {
  final Color color;

  _CurvedAppBarBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 50,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final LoginController loginController = Get.find<LoginController>();
  final KasirController kasirController = Get.find<KasirController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: FooterProduct(cartController: cartController),
      body: RefreshIndicator(
        onRefresh: () async {
          productController.fetchProductCategory();
          productController.fetchProduct();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: const CurvedAppBarBackground(
                color: MyColors.primary,
                height: 200,
              ),
              pinned: true,
              expandedHeight: 100,
              collapsedHeight: 80,
              toolbarHeight: 30,
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Obx(() {
                      final kios = kasirController.namaKios.value;
                      final cabang = kasirController.namaCabang.value;
                      return Text(
                        '$kios - $cabang',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }),
                    const Gap(10),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        showModalBottomSheet(
                          context: context,
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          builder: (context) => const ChangeOutletPage(),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: MySizes.iconMd,
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SearchBarContainer(productController: productController),
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
