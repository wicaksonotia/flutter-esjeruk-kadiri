import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/pages/change_outlet_page.dart';
import 'package:cashier/widgets/logout_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late final LoginController loginController;
  late final CartController cartController;

  String _namaKasir = '';
  String _kios = '';
  String _cabang = '';

  @override
  void initState() {
    super.initState();

    loginController = Get.find<LoginController>();
    cartController = Get.find<CartController>();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _namaKasir = prefs.getString('nama_kasir') ?? '';
      _kios = prefs.getString('kios') ?? '';
      _cabang = prefs.getString('cabang') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColors.background,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileSection(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                children: [
                  _buildSectionTitle('TRANSAKSI'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.shopping_bag_outlined,
                    text: 'Menu',
                    route: RouterClass.product,
                  ),

                  _buildDrawerItem(
                    icon: Icons.today_outlined,
                    text: 'Daily Transactions',
                    route: RouterClass.dailytransactions,
                  ),

                  _buildDrawerItem(
                    icon: Icons.receipt_long_outlined,
                    text: 'Transaction History',
                    route: RouterClass.transactionhistories,
                  ),

                  const SizedBox(height: 22),

                  _buildSectionTitle('LAINNYA'),

                  const SizedBox(height: 6),

                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    route: RouterClass.userSetting,
                  ),

                  _buildDrawerItem(
                    icon: Icons.menu_book_outlined,
                    text: 'SOP Document',
                    route: RouterClass.sopDocument,
                  ),
                ],
              ),
            ),

            _buildLogoutButton(),

            const SizedBox(height: 8),

            _buildAppVersion(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        border: Border(bottom: BorderSide(color: MyColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _namaKasir.isEmpty ? 'Kasir' : _namaKasir,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeLg,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _kios.isEmpty ? 'Cashier' : _kios,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildOutletCard(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: MyColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundColor: MyColors.surface,
        backgroundImage: AssetImage('assets/images/clerk.png'),
      ),
    );
  }

  // ============================================================
  // OUTLET
  // ============================================================

  Widget _buildOutletCard() {
    return Material(
      color: MyColors.surfaceSoft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: MyColors.primary.withValues(alpha: .06),
        highlightColor: MyColors.primary.withValues(alpha: .03),
        onTap: () {
          Get.back();
          _showChangeOutlet(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MyColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: MySizes.iconSm,
                  color: MyColors.primaryDark,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outlet aktif',
                      style: TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _cabang.isEmpty ? 'Pilih outlet' : 'Cabang $_cabang',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.swap_horiz_rounded,
                size: MySizes.iconSm,
                color: MyColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: .8,
          color: MyColors.textMuted,
        ),
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    String? route,
    VoidCallback? onTap,
  }) {
    final isActive = route != null && Get.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive ? MyColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: MyColors.primary.withValues(alpha: .06),
          highlightColor: MyColors.primary.withValues(alpha: .03),
          onTap:
              onTap ??
              () {
                Get.back();

                if (route != null) {
                  Get.toNamed(route);
                }
              },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isActive
                        ? MyColors.primary.withValues(alpha: .12)
                        : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                // ICON
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive ? MyColors.surface : MyColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: MySizes.iconSm,
                    color:
                        isActive
                            ? MyColors.primaryDark
                            : MyColors.textSecondary,
                  ),
                ),

                const SizedBox(width: 12),

                // TEXT
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color:
                          isActive
                              ? MyColors.primaryDark
                              : MyColors.textPrimary,
                    ),
                  ),
                ),

                // ACTIVE INDICATOR
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: isActive ? 6 : 0,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: MyColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Material(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: MyColors.error.withValues(alpha: .06),
          highlightColor: MyColors.error.withValues(alpha: .03),
          onTap: () => _confirmLogout(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: MyColors.errorBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: MySizes.iconSm,
                    color: MyColors.error,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.w600,
                      color: MyColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) {
    return LogoutConfirmationDialog.show(
      context: context,
      onConfirm: () {
        cartController.clearCart();
        loginController.logout();
      },
    );
  }

  // ============================================================
  // VERSION
  // ============================================================

  Widget _buildAppVersion() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        'Cashier',
        style: TextStyle(fontSize: 11, color: MyColors.textMuted),
      ),
    );
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  void _showChangeOutlet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyColors.surface,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ChangeOutletPage(),
    );
  }
}
