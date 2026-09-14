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
      backgroundColor: MyColors.background,
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
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      colors: [MyColors.primary, MyColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // =========================================================
                // DECORATION
                // =========================================================
                Positioned(
                  top: -100,
                  left: -50,
                  child: _circle(
                    size: 200,
                    color: MyColors.textOnPrimary.withValues(alpha: .10),
                  ),
                ),

                Positioned(
                  top: 50,
                  right: -60,
                  child: _circle(
                    size: 120,
                    color: MyColors.textOnPrimary.withValues(alpha: .08),
                  ),
                ),

                Positioned(
                  top: 70,
                  right: -40,
                  child: _circle(
                    size: 80,
                    color: MyColors.textOnPrimary.withValues(alpha: .06),
                  ),
                ),

                // =========================================================
                // BACK BUTTON
                // =========================================================
                Positioned(
                  top: 50,
                  left: 20,
                  child: Material(
                    color: MyColors.textOnPrimary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _back,
                      splashColor: MyColors.textOnPrimary.withValues(
                        alpha: .08,
                      ),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: MyColors.textOnPrimary,
                        ),
                      ),
                    ),
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
                      color: MyColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // =========================================================
                // CONTENT CARD
                // =========================================================
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 120, 20, 24),
                  padding: const EdgeInsets.all(18),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: MyColors.shadow,
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: MyColors.textPrimary,
                        ),
                      ),

                      const Gap(8),

                      const Text(
                        'Input your current password and new password '
                        'to change your account password. This is important.',
                        style: TextStyle(
                          fontSize: 14,
                          color: MyColors.textSecondary,
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
                          color: MyColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: MyColors.primary.withValues(alpha: .18),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: MyColors.primaryDark,
                            ),

                            const Gap(10),

                            const Expanded(
                              child: Text(
                                'After changing your password, please '
                                'log in again using your new password. '
                                'If you forget your password, you can '
                                'reset it through the "Forgot Password" '
                                'feature.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyColors.textSecondary,
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
                                foregroundColor: MyColors.textOnPrimary,
                                disabledBackgroundColor: MyColors.surfaceSoft,
                                disabledForegroundColor: MyColors.textMuted,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                          color: MyColors.textOnPrimary,
                                        ),
                                      )
                                      : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: MyColors.textOnPrimary,
                                          fontWeight: FontWeight.w700,
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
      style: const TextStyle(color: MyColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: '$label *',
        labelStyle: const TextStyle(color: MyColors.textSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: MyColors.textMuted),
        filled: true,
        fillColor: MyColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.primary, width: 1.5),
        ),
        suffixIcon: IconButton(
          tooltip:
              obscureText ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
          onPressed: onToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: MyColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _circle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
