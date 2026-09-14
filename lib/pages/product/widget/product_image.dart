import 'dart:typed_data';

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

        /*
         * Jika byte image rusak / bukan image valid,
         * jangan biarkan exception merusak UI.
         */
        errorBuilder: (context, error, stackTrace) {
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
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),

      child: const Center(
        child: Icon(Icons.fastfood_rounded, size: 30, color: Color(0xFFB8BDC5)),
      ),
    );
  }
}
