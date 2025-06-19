import 'package:badges/badges.dart' as badges;
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FooterProduct extends StatefulWidget {
  final CartController cartController;
  const FooterProduct({super.key, required this.cartController});

  @override
  State<FooterProduct> createState() => _FooterProductState();
}

class _FooterProductState extends State<FooterProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * .07,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 7,
          ),
        ],
        color: Colors.white,
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                badges.Badge(
                  badgeContent: Text(
                    widget.cartController.totalAllQuantity.value.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  badgeAnimation: const badges.BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 400),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 30,
                    color: MyColors.primary,
                  ),
                ),
                const Gap(10),
                verticalSeparator(),
                RichText(
                  text: TextSpan(
                    text: 'Rp ',
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      color: MyColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: CurrencyFormat.convertToIdr(
                          widget.cartController.subTotal.value,
                          0,
                        ),
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeXl,
                          color: MyColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (widget.cartController.isButtonDisabled.value) return;
                Get.toNamed(RouterClass.checkoutPage);
                widget.cartController.applyDiscount();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
                backgroundColor:
                    widget.cartController.isButtonDisabled.value
                        ? Colors.grey
                        : MyColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.save, color: Colors.white),
                  Gap(5),
                  Text('Checkout', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  VerticalDivider verticalSeparator() {
    return VerticalDivider(color: Colors.grey[300], thickness: 1, width: 20);
  }
}
