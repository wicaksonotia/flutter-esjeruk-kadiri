import 'package:esjerukkadiri/commons/colors.dart' show MyColors;
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/controllers/login_controller.dart';
import 'package:esjerukkadiri/navigation/app_navigation.dart';
import 'package:esjerukkadiri/pages/change_outlet_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final CartController cartController = Get.find<CartController>();
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            buildDrawerHeader(),
            buildDrawerItem(
              icon: Icons.shopping_cart,
              text: "Katalog Menu",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.product);
              },
              tileColor: Colors.black,
              textIconColor:
                  Get.currentRoute == RouterClass.product
                      ? MyColors.primary
                      : Colors.black,
            ),
            buildDrawerItem(
              icon: Icons.history,
              text: "Transaksi Harian",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.dailytransactions);
              },
              tileColor: Colors.black,
              textIconColor:
                  Get.currentRoute == RouterClass.dailytransactions
                      ? MyColors.primary
                      : Colors.black,
            ),
            buildDrawerItem(
              icon: Icons.edit_document,
              text: "Riwayat Transaksi",
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(RouterClass.transactionhistories);
              },
              tileColor: Colors.black,
              textIconColor:
                  Get.currentRoute == RouterClass.transactionhistories
                      ? MyColors.primary
                      : Colors.black,
            ),
            Divider(color: Colors.grey.shade300),
            buildDrawerItem(
              icon: Icons.bluetooth,
              text: "Setting Bluetooth",
              onTap: () => Get.toNamed(RouterClass.bluetoothSetting),
              tileColor: Colors.black,
              textIconColor: Colors.black,
            ),
            buildDrawerItem(
              icon: Icons.logout,
              text: "Log Out",
              onTap: () {
                loginController.logout();
                cartController.clearCart();
              },
              tileColor: Colors.black,
              textIconColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: MyColors.primary),
            accountName: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: MySizes.fontSizeLg,
              ),
            ),
            accountEmail: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: MySizes.fontSizeMd,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/clerk.png'),
              backgroundColor: Colors.white,
            ),
          );
        }
        final prefs = snapshot.data!;
        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: MyColors.primary),
          accountName: Text(
            prefs.getString('nama_kasir') ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: MySizes.fontSizeLg,
            ),
          ),
          accountEmail: Row(
            children: [
              Text(
                '${prefs.getString('kios') ?? ''} - ${prefs.getString('cabang') ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: MySizes.fontSizeMd,
                ),
              ),
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
                  Icons.edit,
                  color: Colors.white,
                  size: MySizes.iconSm,
                ),
              ),
            ],
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/clerk.png'),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required Color textIconColor,
    required Color? tileColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(text, style: TextStyle(color: textIconColor)),
      tileColor: tileColor,
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: textIconColor,
        size: MySizes.iconXs,
      ),
      onTap: onTap,
    );
  }
}
