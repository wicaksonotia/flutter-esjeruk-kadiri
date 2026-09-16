import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==================================================
                // LOGO
                // ==================================================

                _SplashLogo(),

                const SizedBox(height: 24),

                // ==================================================
                // APP NAME
                // ==================================================
                const Text(
                  'KASIRA',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: MyColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Simple cashier for everyday business',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 42),

                // ==================================================
                // LOADING
                // ==================================================
                Obx(
                  () => Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            value: controller.progress.value,
                            backgroundColor: MyColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              MyColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          controller.loadingText.value,
                          key: ValueKey(controller.loadingText.value),
                          style: const TextStyle(
                            fontSize: 12,
                            color: MyColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SPLASH LOGO
// ================================================================

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // ========================================================
          // MAIN ICON
          // ========================================================

          const Icon(
            Icons.point_of_sale_rounded,
            size: 44,
            color: Colors.white,
          ),

          // ========================================================
          // SMALL ACCENT
          // ========================================================
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
    );
  }
}
