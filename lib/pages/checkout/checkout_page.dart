import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/pages/checkout/widget/checkout_cart_section.dart';
import 'package:cashier/pages/checkout/widget/checkout_header.dart';
import 'package:cashier/pages/checkout/widget/checkout_payment_section.dart';
import 'package:cashier/pages/checkout/widget/checkout_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CartController cartController;

  @override
  void initState() {
    super.initState();

    cartController = Get.find<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,

      body: SafeArea(
        bottom: false,

        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),

          slivers: [
            const SliverToBoxAdapter(child: CheckoutHeader()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),

                child: _CheckoutCard(cartController: cartController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// CHECKOUT CARD
// ================================================================

class _CheckoutCard extends StatelessWidget {
  final CartController cartController;

  const _CheckoutCard({required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: MyColors.surface,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: MyColors.border),

        boxShadow: [
          BoxShadow(
            color: MyColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CheckoutCartSection(cartController: cartController),

            const SizedBox(height: 20),

            const _SectionDivider(),

            const SizedBox(height: 20),

            CheckoutSummarySection(cartController: cartController),

            const SizedBox(height: 20),

            const _SectionDivider(),

            const SizedBox(height: 20),

            CheckoutPaymentSection(cartController: cartController),

            const SizedBox(height: 28),

            _CheckoutButton(cartController: cartController),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// CHECKOUT BUTTON
// ================================================================

class _CheckoutButton extends StatelessWidget {
  final CartController cartController;

  const _CheckoutButton({required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = !cartController.isButtonDisabled.value;

      return SizedBox(
        width: double.infinity,
        height: 52,

        child: ElevatedButton(
          onPressed: enabled ? cartController.saveCart : null,

          style: ElevatedButton.styleFrom(
            elevation: 0,

            backgroundColor: MyColors.primary,

            foregroundColor: MyColors.textOnPrimary,

            disabledBackgroundColor: MyColors.surfaceSoft,

            disabledForegroundColor: MyColors.textMuted,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(Icons.check_circle_outline_rounded, size: 19),

              SizedBox(width: 8),

              Text(
                'Proses Pesanan',

                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ================================================================
// SECTION DIVIDER
// ================================================================

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: MyColors.divider);
  }
}
