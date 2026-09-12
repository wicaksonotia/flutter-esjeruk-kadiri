import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/pages/change_outlet_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final cartController = Get.find<CartController>();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            buildDrawerHeader(context),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(
                    icon: Icons.shopping_cart,
                    text: 'Menu',
                    route: RouterClass.product,
                  ),

                  buildDrawerItem(
                    icon: Icons.history,
                    text: 'Daily Transactions',
                    route: RouterClass.dailytransactions,
                  ),

                  buildDrawerItem(
                    icon: Icons.edit_document,
                    text: 'Transaction History',
                    route: RouterClass.transactionhistories,
                  ),

                  const Divider(height: 24),

                  buildDrawerItem(
                    icon: Icons.manage_accounts,
                    text: 'Setting',
                    route: RouterClass.userSetting,
                  ),

                  buildDrawerItem(
                    icon: Icons.description,
                    text: 'SOP Document',
                    route: RouterClass.sopDocument,
                  ),

                  buildDrawerItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      loginController.logout();
                      cartController.clearCart();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String text,
    String? route,
    VoidCallback? onTap,
  }) {
    final bool isActive = route != null && Get.currentRoute == route;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? MyColors.primary : Colors.black87,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isActive ? MyColors.primary : Colors.black87,
            fontSize: MySizes.fontSizeMd,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isActive ? MyColors.primary : Colors.black54,
          size: MySizes.iconXs,
        ),
        onTap:
            onTap ??
            () {
              Get.back();

              if (route != null) {
                Get.toNamed(route);
              }
            },
      ),
    );
  }

  Widget buildDrawerHeader(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final prefs = snapshot.data;

        final namaKasir = prefs?.getString('nama_kasir') ?? '';
        final kios = prefs?.getString('kios') ?? '';
        final cabang = prefs?.getString('cabang') ?? '';

        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: MyColors.primary),
          accountName: Text(
            namaKasir,
            style: const TextStyle(
              color: Colors.white,
              fontSize: MySizes.fontSizeLg,
            ),
          ),
          accountEmail: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kios,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: MySizes.fontSizeMd,
                ),
              ),
              const Gap(4),
              InkWell(
                onTap: () {
                  Get.back();
                  _showChangeOutlet(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Cabang $cabang',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: MySizes.fontSizeMd,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: MySizes.iconMd,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ],
          ),
          currentAccountPictureSize: const Size(60, 60),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/clerk.png'),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  void _showChangeOutlet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ChangeOutletPage(),
    );
  }
}
