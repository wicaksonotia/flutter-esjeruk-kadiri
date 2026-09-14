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

      backgroundColor: MyColors.background,

      appBar: AppBar(
        backgroundColor: MyColors.primary,
        foregroundColor: MyColors.textOnPrimary,
        elevation: 0,
        title: const Text(
          'User Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),

      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.primary),
            );
          }

          final prefs = snapshot.data!;

          return FutureBuilder<Map<String, String?>>(
            future: _loadPrinterInfo(),
            builder: (context, bluetooth) {
              final printer = bluetooth.data ?? {};

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GetBuilder<LoginController>(
                    builder: (_) {
                      return _UserHeader(
                        name: prefs.getString('nama_kasir') ?? '-',
                        outlet: prefs.getString('kios') ?? '-',
                        branch: prefs.getString('cabang') ?? '-',
                      );
                    },
                  ),

                  const Gap(20),

                  _SectionCard(
                    title: 'Account',
                    children: [
                      _MenuTile(
                        icon: Icons.person_outline_rounded,
                        color: MyColors.primary,
                        title: 'Profile',
                        subtitle: 'Edit account information',
                        onTap: () => Get.toNamed(RouterClass.profile),
                      ),
                      _MenuTile(
                        icon: Icons.lock_outline_rounded,
                        color: MyColors.primary,
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
                        icon: Icons.bluetooth_rounded,
                        color: MyColors.primary,
                        title: 'Bluetooth Printer',
                        subtitle: printer['name'] ?? 'Belum memilih printer',
                        trailing: Icon(
                          printer['mac'] != null
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color:
                              printer['mac'] != null
                                  ? MyColors.success
                                  : MyColors.textMuted,
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
                        color: MyColors.primary,
                        title: 'SOP Document',
                        subtitle: 'Panduan operasional kasir',
                        onTap: () => Get.toNamed(RouterClass.sopDocument),
                      ),
                      const _InfoTile(
                        icon: Icons.info_outline_rounded,
                        color: MyColors.primary,
                        title: 'Versi Aplikasi',
                        value: 'v1.0.0',
                      ),
                    ],
                  ),

                  const Gap(30),

                  // LOGOUT
                  OutlinedButton.icon(
                    onPressed: () {
                      loginController.logout();
                      cartController.clearCart();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MyColors.error,
                      side: const BorderSide(color: MyColors.error),
                      backgroundColor: MyColors.surface,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

                  const Gap(12),

                  const Center(
                    child: Text(
                      'Cashier Himalaya',
                      style: TextStyle(color: MyColors.textMuted, fontSize: 12),
                    ),
                  ),

                  const Gap(10),
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
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: MyColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 34,
              color: MyColors.primaryDark,
            ),
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
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),

                const Gap(4),

                Text(
                  outlet,
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Gap(2),

                Text(
                  'Cabang $branch',
                  style: const TextStyle(
                    color: MyColors.textMuted,
                    fontSize: 13,
                  ),
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
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: MyColors.textPrimary,
              ),
            ),
          ),

          const Divider(height: 1, color: MyColors.divider),

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
        onTap: onTap,
        splashColor: MyColors.primary.withValues(alpha: .05),
        highlightColor: MyColors.primary.withValues(alpha: .025),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 21),
              ),

              const Gap(14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),

                    const Gap(2),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: MyColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: MyColors.textMuted,
                  ),
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
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),

          const Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),

                const Gap(2),

                Text(
                  value,
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
