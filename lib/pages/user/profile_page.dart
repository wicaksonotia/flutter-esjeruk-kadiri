import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:cashier/pages/user/change_outlet_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    controller.checkProfile();
  }

  void _changeOutlet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const UserChangeOutletPage(),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: MyColors.textSecondary),
      floatingLabelStyle: const TextStyle(
        color: MyColors.primaryDark,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: MyColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: MyColors.primary,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: MyColors.textOnPrimary,
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.primary, MyColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: MyColors.textOnPrimary.withValues(
                              alpha: .14,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MyColors.textOnPrimary.withValues(
                                alpha: .25,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            size: 44,
                            color: MyColors.textOnPrimary,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          controller.namaController.text.isEmpty
                              ? 'Cashier'
                              : controller.namaController.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MyColors.textOnPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(4),
                        Obx(
                          () => Text(
                            controller.namaCabang.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: MyColors.textOnPrimary.withValues(
                                alpha: .72,
                              ),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // EDIT PROFILE
                  _SectionCard(
                    title: 'Edit Profile',
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.namaController,
                          style: const TextStyle(
                            color: MyColors.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration('Full Name'),
                        ),

                        const Gap(16),

                        TextField(
                          controller: controller.noTelponController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            color: MyColors.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration('Phone Number'),
                        ),

                        const Gap(16),

                        Material(
                          color: MyColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: MyColors.primary.withValues(
                              alpha: .06,
                            ),
                            highlightColor: MyColors.primary.withValues(
                              alpha: .03,
                            ),
                            onTap: _changeOutlet,
                            child: InputDecorator(
                              decoration: _inputDecoration('Default Store'),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: MyColors.primaryLight,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: const Icon(
                                      Icons.storefront_outlined,
                                      color: MyColors.primaryDark,
                                      size: 18,
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: Obx(
                                      () => Text(
                                        controller.namaCabang.value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: MyColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: MyColors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(28),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.updateProfileProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          foregroundColor: MyColors.textOnPrimary,
                          disabledBackgroundColor: MyColors.surfaceSoft,
                          disabledForegroundColor: MyColors.textMuted,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child:
                            controller.isLoading.value
                                ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: MyColors.primary,
                                  ),
                                )
                                : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                      ),
                    ),
                  ),

                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: MyColors.primaryDark, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: MyColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: MyColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
          const Gap(16),
          child,
        ],
      ),
    );
  }
}
