import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const _LoginHeader(),

                    const SizedBox(height: 36),

                    _LoginCard(controller: controller),

                    const SizedBox(height: 24),

                    const _FooterText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'kasira-logo',
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primary.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.point_of_sale_rounded,
                  size: 44,
                  color: Colors.white,
                ),

                Positioned(
                  right: 14,
                  top: 14,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: MyColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: MyColors.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'KASIRA',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: MyColors.primaryDark,
            letterSpacing: 2.5,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Simple cashier for everyday business',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: MyColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOGIN CARD
// ============================================================================

class _LoginCard extends StatelessWidget {
  final LoginController controller;

  const _LoginCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: MyColors.border.withValues(alpha: .7)),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow.withValues(alpha: .06),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Masuk',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Masukkan nama kios dan password untuk melanjutkan.',
            style: TextStyle(
              fontSize: 13,
              color: MyColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          _InputField(
            title: 'Nama Kios',
            hint: 'Contoh: Himalaya',
            icon: Icons.storefront_outlined,
            controller: controller.emailController,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 18),

          Obx(
            () => _InputField(
              title: 'Password',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: controller.passwordController,
              obscure: !controller.isPasswordVisible.value,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.loginWithEmail(),
              suffix: IconButton(
                splashRadius: 20,
                onPressed: controller.showPassword,
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 20,
                  color: MyColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : controller.loginWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                disabledBackgroundColor: MyColors.primary.withValues(
                  alpha: .65,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child:
                    controller.isLoading.value
                        ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(
                              MyColors.textOnPrimary,
                            ),
                          ),
                        )
                        : const Row(
                          key: ValueKey('text'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              size: 18,
                              color: MyColors.textOnPrimary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: MyColors.textOnPrimary,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INPUT
// ============================================================================

class _InputField extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscure,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: MyColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(icon, color: MyColors.primary, size: 20),
            suffixIcon: suffix,
            filled: true,
            fillColor: MyColors.surfaceSoft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: MyColors.border.withValues(alpha: .8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: MyColors.primary, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FOOTER
// ============================================================================

class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Powered by KASIRA',
          style: TextStyle(fontSize: 11, color: MyColors.textMuted),
        ),
        SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: TextStyle(fontSize: 11, color: MyColors.textMuted),
        ),
      ],
    );
  }
}
