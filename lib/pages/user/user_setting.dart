import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
        title: const Text('User Settings'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final prefs = snapshot.data!;

          return FutureBuilder<Map<String, String?>>(
            future: _loadPrinterInfo(),
            builder: (context, bluetooth) {
              final printer = bluetooth.data!;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _UserHeader(
                    name: prefs.getString('nama_kasir') ?? '-',
                    outlet: prefs.getString('kios') ?? '-',
                    branch: prefs.getString('cabang') ?? '-',
                  ),

                  const Gap(20),

                  _SectionCard(
                    title: 'Account',
                    children: [
                      _MenuTile(
                        icon: Icons.person_outline,
                        color: Colors.blue,
                        title: 'Profile',
                        subtitle: 'Edit account information',
                        onTap: () => Get.toNamed(RouterClass.profile),
                      ),
                      _MenuTile(
                        icon: Icons.lock_outline,
                        color: Colors.orange,
                        title: 'Change Password',
                        subtitle: 'Change account password',
                        onTap: () => Get.toNamed(RouterClass.changePassword),
                      ),
                    ],
                  ),

                  const Gap(16),

                  _SectionCard(
                    title: 'Operasional',
                    children: [
                      _MenuTile(
                        icon: Icons.bluetooth,
                        color: Colors.indigo,
                        title: 'Bluetooth Printer',
                        subtitle: printer['name'] ?? 'Belum memilih printer',
                        trailing: Icon(
                          printer['mac'] != null
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              printer['mac'] != null
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        onTap: () => Get.toNamed(RouterClass.bluetoothSetting),
                      ),
                    ],
                  ),

                  const Gap(16),

                  _SectionCard(
                    title: 'Support',
                    children: [
                      _MenuTile(
                        icon: Icons.menu_book_outlined,
                        color: Colors.purple,
                        title: 'SOP Document',
                        subtitle: 'Panduan operasional kasir',
                        onTap: () => Get.toNamed(RouterClass.sopDocument),
                      ),
                      const _InfoTile(
                        icon: Icons.info_outline,
                        color: Colors.teal,
                        title: 'Versi Aplikasi',
                        value: 'v1.0.0',
                      ),
                    ],
                  ),

                  const Gap(30),

                  OutlinedButton.icon(
                    onPressed: () {
                      loginController.logout();
                      cartController.clearCart();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const Gap(12),

                  const Center(
                    child: Text(
                      'Cashier Himalaya',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _loadPrinterInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('selected_printer_name'),
      'mac': prefs.getString('selected_printer_mac'),
    };
  }
}

/// =======================================================
/// USER HEADER
/// =======================================================

class _UserHeader extends StatelessWidget {
  final String name;
  final String outlet;
  final String branch;

  const _UserHeader({
    required this.name,
    required this.outlet,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: MyColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 34, color: MyColors.primary),
          ),

          const Gap(16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(4),

                Text(outlet, style: const TextStyle(color: Colors.black87)),

                const Gap(2),

                Text(
                  'Cabang $branch',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// SECTION CARD
/// =======================================================

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(height: 1),

          ...children,
        ],
      ),
    );
  }
}

/// =======================================================
/// MENU TILE
/// =======================================================

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),

              const Gap(14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              trailing ??
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// INFO TILE
/// =======================================================

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),

          const Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Gap(2),
                Text(
                  value,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
