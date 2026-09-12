import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/pages/change_outlet_page.dart';
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

  SharedPreferences? _prefs;

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
      _prefs = prefs;
      _namaKasir = prefs.getString('nama_kasir') ?? '';
      _kios = prefs.getString('kios') ?? '';
      _cabang = prefs.getString('cabang') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F9FB),
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

                  const SizedBox(height: 24),

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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9EBEF))),
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
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _kios.isEmpty ? 'Cashier' : _kios,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: Color(0xFF7A808A),
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
      decoration: BoxDecoration(
        color: MyColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/clerk.png'),
      ),
    );
  }

  Widget _buildOutletCard() {
    return Material(
      color: const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.back();
          _showChangeOutlet(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: MyColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  size: MySizes.iconSm,
                  color: MyColors.primary,
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
                        color: Color(0xFF8A9099),
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
                        color: Color(0xFF30343B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
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
          letterSpacing: 0.8,
          color: Color(0xFF969BA3),
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
    final bool isActive = route != null && Get.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color:
            isActive
                ? MyColors.primary.withValues(alpha: 0.10)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  isActive
                      ? Border.all(
                        color: MyColors.primary.withValues(alpha: 0.08),
                      )
                      : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive ? MyColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow:
                        isActive
                            ? null
                            : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                  ),
                  child: Icon(
                    icon,
                    size: MySizes.iconSm,
                    color: isActive ? Colors.white : const Color(0xFF555B65),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isActive ? MyColors.primary : const Color(0xFF343940),
                    ),
                  ),
                ),

                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            cartController.clearCart();
            loginController.logout();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: MySizes.iconSm,
                    color: Color(0xFFE05252),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE05252),
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: MySizes.iconSm,
                  color: Color(0xFFD58A8A),
                ),
              ],
            ),
          ),
        ),
      ),
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
        style: TextStyle(fontSize: 11, color: Color(0xFFB0B4BA)),
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
      backgroundColor: Colors.white,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ChangeOutletPage(),
    );
  }
}
