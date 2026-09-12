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
  late final LoginController loginController;

  @override
  void initState() {
    super.initState();

    loginController = Get.find<LoginController>();

    _resetPasswordForm();
  }

  @override
  void dispose() {
    _resetPasswordForm();
    super.dispose();
  }

  void _resetPasswordForm() {
    loginController.isPasswordCurrentVisible(false);
    loginController.isPasswordNewVisible(false);
    loginController.isPasswordConfirmVisible(false);
    loginController.clearChangePasswordControllers();
  }

  void _back() {
    _resetPasswordForm();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            Stack(
              children: [
                // =========================================================
                // HEADER BACKGROUND
                // =========================================================

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

                // =========================================================
                // DECORATION
                // =========================================================
                Positioned(
                  top: -100,
                  left: -50,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white.withValues(alpha: 0.2),
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
                      color: Colors.white.withValues(alpha: 0.2),
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

                // =========================================================
                // BACK BUTTON
                // =========================================================
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    tooltip: 'Kembali',
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _back,
                  ),
                ),

                // =========================================================
                // TITLE
                // =========================================================
                const Positioned(
                  top: 60,
                  left: 80,
                  right: 20,
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // =========================================================
                // CONTENT CARD
                // =========================================================
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 120, 20, 24),
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
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Gap(8),

                      Text(
                        'Input your current password and new password to change your account password. This is important',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),

                      const Gap(25),

                      // ===================================================
                      // CURRENT PASSWORD
                      // ===================================================
                      Obx(
                        () => _passwordField(
                          controller: loginController.currentController,
                          label: 'Old Password',
                          hint: 'Enter your current password',
                          obscureText:
                              !loginController.isPasswordCurrentVisible.value,
                          onToggle: loginController.showCurrentPassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.password],
                        ),
                      ),

                      const Gap(16),

                      // ===================================================
                      // NEW PASSWORD
                      // ===================================================
                      Obx(
                        () => _passwordField(
                          controller: loginController.newController,
                          label: 'New Password',
                          hint: 'Enter your new password',
                          obscureText:
                              !loginController.isPasswordNewVisible.value,
                          onToggle: loginController.showNewPassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                      ),

                      const Gap(16),

                      // ===================================================
                      // CONFIRM PASSWORD
                      // ===================================================
                      Obx(
                        () => _passwordField(
                          controller: loginController.confirmController,
                          label: 'Confirm New Password',
                          hint: 'Confirm your new password',
                          obscureText:
                              !loginController.isPasswordConfirmVisible.value,
                          onToggle: loginController.showConfirmPassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                      ),

                      const Gap(20),

                      // ===================================================
                      // INFORMATION
                      // ===================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: MyColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: MyColors.primary,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                'After changing your password, please log in again using your new password. If you forget your password, you can reset it through the "Forgot Password" feature.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(40),

                      // ===================================================
                      // SAVE BUTTON
                      // ===================================================
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed:
                                  loginController.isLoading.value
                                      ? null
                                      : loginController.changePasswordProcess,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.primary,
                                disabledBackgroundColor: MyColors.primary
                                    .withValues(alpha: 0.5),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  loginController.isLoading.value
                                      ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),

                      const Gap(8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // PASSWORD FIELD
  // ==============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    required TextInputAction textInputAction,
    required Iterable<String> autofillHints,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary, width: 1.5),
        ),
        suffixIcon: IconButton(
          tooltip:
              obscureText ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
          onPressed: onToggle,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF5C5F65),
          ),
        ),
      ),
    );
  }
}
