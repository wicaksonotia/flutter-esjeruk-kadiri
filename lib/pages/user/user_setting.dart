import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/widgets/logout_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  LoginController get loginController => Get.find<LoginController>();

  CartController get cartController => Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      appBar: const _SettingsAppBar(),
      body: SafeArea(
        child: FutureBuilder<SharedPreferences>(
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
              builder: (context, printerSnapshot) {
                final printer = printerSnapshot.data ?? {};

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // USER HEADER
                      // ==================================================

                      GetBuilder<LoginController>(
                        builder: (_) {
                          return _UserHeader(
                            name: prefs.getString('nama_kasir') ?? '-',
                            outlet: prefs.getString('kios') ?? '-',
                            branch: prefs.getString('cabang') ?? '-',
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // ACCOUNT
                      // ==================================================
                      const _SectionHeader(
                        title: 'Account',
                        subtitle: 'Manage your personal account',
                      ),

                      const SizedBox(height: 12),

                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.person_outline_rounded,
                            iconBackground: MyColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            iconColor: MyColors.primary,
                            title: 'Profile',
                            subtitle: 'View and manage your profile',
                            onTap: () {
                              Get.toNamed(RouterClass.profile);
                            },
                          ),

                          const _SettingsDivider(),

                          _SettingsTile(
                            icon: Icons.lock_outline_rounded,
                            iconBackground: Colors.orange.withValues(
                              alpha: 0.10,
                            ),
                            iconColor: Colors.orange.shade700,
                            title: 'Change Password',
                            subtitle: 'Update your account password',
                            onTap: () {
                              Get.toNamed(RouterClass.changePassword);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // OPERASIONAL
                      // ==================================================
                      const _SectionHeader(
                        title: 'Operasional',
                        subtitle: 'Configure your cashier equipment',
                      ),

                      const SizedBox(height: 12),

                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.bluetooth_rounded,
                            iconBackground: Colors.blue.withValues(alpha: 0.10),
                            iconColor: Colors.blue.shade700,
                            title: 'Bluetooth Printer',
                            subtitle:
                                printer['name'] ?? 'Belum memilih printer',
                            trailing: _PrinterStatus(
                              connected: printer['mac'] != null,
                            ),
                            onTap: () {
                              Get.toNamed(RouterClass.bluetoothSetting);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // SUPPORT
                      // ==================================================
                      const _SectionHeader(
                        title: 'Support',
                        subtitle: 'Find answers and get help',
                      ),

                      const SizedBox(height: 12),

                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.menu_book_outlined,
                            iconBackground: Colors.teal.withValues(alpha: 0.10),
                            iconColor: Colors.teal.shade700,
                            title: 'SOP Document',
                            subtitle: 'Panduan operasional kasir',
                            onTap: () {
                              Get.toNamed(RouterClass.sopDocument);
                            },
                          ),

                          const _SettingsDivider(),

                          _SettingsTile(
                            icon: Icons.help_outline_rounded,
                            iconBackground: Colors.indigo.withValues(
                              alpha: 0.10,
                            ),
                            iconColor: Colors.indigo.shade700,
                            title: 'FAQ',
                            subtitle: 'Frequently asked questions',
                            onTap: () {
                              // TODO:
                              // Tambahkan route FAQ ketika halaman
                              // FAQ sudah dibuat.
                            },
                          ),

                          const _SettingsDivider(),

                          const _VersionTile(),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ==================================================
                      // LOGOUT
                      // ==================================================
                      _LogoutButton(onTap: () => _confirmLogout(context)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PRINTER
  // ============================================================

  Future<Map<String, String?>> _loadPrinterInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('selected_printer_name'),
      'mac': prefs.getString('selected_printer_mac'),
    };
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _confirmLogout(BuildContext context) {
    return LogoutConfirmationDialog.show(
      context: context,
      onConfirm: _performLogout,
    );
  }

  void _performLogout() {
    cartController.clearCart();
    loginController.logout();
  }
}

// ============================================================================
// APP BAR
// ============================================================================

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SettingsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: MyColors.background,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 8,
      leading: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu_rounded, color: MyColors.textPrimary),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        },
      ),
      title: const Text(
        'Settings',
        style: TextStyle(
          color: MyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================================
// USER HEADER
// ============================================================================

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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const _ProfileAvatar(),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: MyColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        outlet,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MyColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  'Cabang $branch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textMuted,
                    fontSize: 11,
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

// ============================================================================
// PROFILE AVATAR
// ============================================================================

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 30,
        color: MyColors.primaryDark,
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: MyColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(color: MyColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SETTINGS CARD
// ============================================================================

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ============================================================================
// SETTINGS TILE
// ============================================================================

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
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
        borderRadius: BorderRadius.circular(20),
        splashColor: MyColors.primary.withValues(alpha: 0.05),
        highlightColor: MyColors.primary.withValues(alpha: 0.025),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              _MenuIcon(
                icon: icon,
                backgroundColor: iconBackground,
                iconColor: iconColor,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: MyColors.textMuted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MENU ICON
// ============================================================================

class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _MenuIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, size: 21, color: iconColor),
    );
  }
}

// ============================================================================
// DIVIDER
// ============================================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 74),
      child: Divider(height: 1, thickness: 0.6, color: MyColors.divider),
    );
  }
}

// ============================================================================
// PRINTER STATUS
// ============================================================================

class _PrinterStatus extends StatelessWidget {
  final bool connected;

  const _PrinterStatus({required this.connected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color:
            connected
                ? MyColors.success.withValues(alpha: 0.10)
                : MyColors.textMuted.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            connected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: connected ? MyColors.success : MyColors.textMuted,
          ),

          const SizedBox(width: 5),

          Text(
            connected ? 'Connected' : 'Not set',
            style: TextStyle(
              color: connected ? MyColors.success : MyColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VERSION TILE
// ============================================================================

class _VersionTile extends StatelessWidget {
  const _VersionTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MyColors.textMuted.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 21,
              color: MyColors.textMuted,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Version',
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Cashier Himalaya',
                  style: TextStyle(color: MyColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),

          const Text(
            '1.0.0',
            style: TextStyle(
              color: MyColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LOGOUT BUTTON
// ============================================================================

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.error,
          backgroundColor: MyColors.surface,
          side: BorderSide(color: MyColors.error.withValues(alpha: 0.30)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
