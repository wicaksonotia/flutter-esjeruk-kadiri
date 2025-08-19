import 'package:cashier/commons/sizes.dart';
import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  const BoxContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.shadow = false,
    this.showBorder = false,
    this.radius = MySizes.cardRadiusLg,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.alignment = Alignment.center,
  });

  final double? width, height;
  final double radius;
  final Widget? child;
  final bool showBorder, shadow;
  final Color? backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry? margin, padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        boxShadow: [
          shadow
              ? BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 7,
                // offset: Offset(0, 3), // changes position of shadow
              )
              : const BoxShadow(),
        ],
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
