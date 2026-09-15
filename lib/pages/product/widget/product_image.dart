import 'dart:typed_data';

import 'package:cashier/commons/colors.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Uint8List? image;
  final double size;
  final double borderRadius;

  const ProductImage({
    super.key,
    required this.image,
    this.size = 90,
    this.borderRadius = 14,
  });

  bool get _hasImage {
    return image != null && image!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasImage) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.memory(
        image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _placeholder();
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.fastfood_rounded,
            size: 23,
            color: MyColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
