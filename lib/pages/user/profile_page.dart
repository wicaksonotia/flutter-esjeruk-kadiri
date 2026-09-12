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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const UserChangeOutletPage(),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
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
      backgroundColor: MyColors.notionBgGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: MyColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.primary, MyColors.secondary],
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
                        const CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: MyColors.primary,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          controller.namaController.text.isEmpty
                              ? "Cashier"
                              : controller.namaController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(4),
                        Obx(
                          () => Text(
                            controller.namaCabang.value,
                            style: const TextStyle(
                              color: Colors.white70,
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
                  _SectionCard(
                    title: "Account Information",
                    child: Column(
                      children: [
                        Obx(
                          () => _infoTile(
                            Icons.store,
                            "Store Name",
                            controller.namaCabang.value,
                          ),
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.phone,
                          "Phone Number",
                          controller.noTelponController.text.isEmpty
                              ? "-"
                              : controller.noTelponController.text,
                        ),
                      ],
                    ),
                  ),

                  const Gap(16),

                  _SectionCard(
                    title: "Edit Profile",
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.namaController,
                          decoration: _inputDecoration("Full Name"),
                        ),
                        const Gap(16),

                        TextField(
                          controller: controller.noTelponController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration("Phone Number"),
                        ),
                        const Gap(16),

                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _changeOutlet,
                          child: InputDecorator(
                            decoration: _inputDecoration("Default Store"),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: MyColors.primary,
                                  size: 20,
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      controller.namaCabang.value,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(28),

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
                          foregroundColor: Colors.white,
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
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    fontWeight: FontWeight.w600,
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
        CircleAvatar(
          radius: 20,
          backgroundColor: MyColors.primary.withValues(alpha: .1),
          child: Icon(icon, color: MyColors.primary, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          child,
        ],
      ),
    );
  }
}
