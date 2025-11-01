import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                          Future.delayed(const Duration(milliseconds: 500), () {
                            loginController.isPasswordCurrentVisible(false);
                            loginController.isPasswordNewVisible(false);
                            loginController.isPasswordConfirmVisible(false);
                            loginController.clearChangePasswordControllers();
                          });
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
                            'Change Password',
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
                            "Ganti Kata Sandi",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(8),
                          const Text(
                            "Masukkan kata sandi baru untuk akun yang terkait",
                          ),
                          const Gap(25),
                          TextField(
                            controller: loginController.currentController,
                            decoration: InputDecoration(
                              labelText: "Kata Sandi Sekarang *",
                              border: const OutlineInputBorder(),
                              suffixIcon: InkWell(
                                onTap: () {
                                  loginController.showCurrentPassword();
                                },
                                child: Icon(
                                  loginController.isPasswordCurrentVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF5C5F65),
                                ),
                              ),
                            ),
                            obscureText:
                                !loginController.isPasswordCurrentVisible.value,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: loginController.newController,
                            decoration: InputDecoration(
                              labelText: "Kata Sandi Baru *",
                              border: const OutlineInputBorder(),
                              suffixIcon: InkWell(
                                onTap: () {
                                  loginController.showNewPassword();
                                },
                                child: Icon(
                                  loginController.isPasswordNewVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF5C5F65),
                                ),
                              ),
                            ),
                            obscureText:
                                !loginController.isPasswordNewVisible.value,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: loginController.confirmController,
                            decoration: InputDecoration(
                              labelText: "Ulangi Kata Sandi *",
                              border: const OutlineInputBorder(),
                              suffixIcon: InkWell(
                                onTap: () {
                                  loginController.showConfirmPassword();
                                },
                                child: Icon(
                                  loginController.isPasswordConfirmVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF5C5F65),
                                ),
                              ),
                            ),
                            obscureText:
                                !loginController.isPasswordConfirmVisible.value,
                          ),
                          const Gap(20),
                          const Text(
                            "Setelah anda membuat Kata Sandi Baru, silahkan masuk dengan Kata Sandi Baru. 👍",
                            textAlign: TextAlign.center,
                          ),
                          const Gap(50),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  loginController.changePasswordProcess();
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
      ),
    );
  }
}
