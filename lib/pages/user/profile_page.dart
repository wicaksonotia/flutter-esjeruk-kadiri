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
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    loginController.checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [MyColors.primary, MyColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -100,
                    left: -50,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: -60,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: -40,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const Positioned(
                    top: 60,
                    left: 80,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ubah Profil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(8),
                        const Text("Ubah informasi profil anda di bawah ini."),
                        const Gap(25),
                        TextField(
                          controller: loginController.namaController,
                          decoration: InputDecoration(
                            labelText: "Nama Pengguna *",
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TextField(
                          controller: loginController.noTelponController,
                          decoration: InputDecoration(
                            labelText: "Nomor Telepon *",
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              constraints: const BoxConstraints(
                                minWidth: double.infinity,
                              ),
                              builder:
                                  (context) => const UserChangeOutletPage(),
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            );
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Set Default Cabang',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                              ),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text(
                                    loginController.namaCabang.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: MyColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(50),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                loginController.updateProfileProcess();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: MySizes.fontSizeMd,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
