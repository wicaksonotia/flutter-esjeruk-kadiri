import 'dart:typed_data';

import 'package:cashier/commons/colors.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Uint8List? image;
  final double? width;
  final double? height;
  final double size;
  final double borderRadius;

  const ProductImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.size = 90,
    this.borderRadius = 14,
  });

  // ================================================================
  // IMAGE VALIDATION
  // ================================================================

  bool get _hasImage {
    return image != null && image!.isNotEmpty;
  }

  bool get _isSupportedImage {
    if (!_hasImage) {
      return false;
    }

    final bytes = image!;

    // ------------------------------------------------------------
    // JPEG
    // FF D8 FF
    // ------------------------------------------------------------
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return true;
    }

    // ------------------------------------------------------------
    // PNG
    // 89 50 4E 47 0D 0A 1A 0A
    // ------------------------------------------------------------
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return true;
    }

    // ------------------------------------------------------------
    // GIF
    // GIF87a / GIF89a
    // ------------------------------------------------------------
    if (bytes.length >= 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38 &&
        (bytes[4] == 0x37 || bytes[4] == 0x39) &&
        bytes[5] == 0x61) {
      return true;
    }

    // ------------------------------------------------------------
    // WEBP
    // RIFF .... WEBP
    // ------------------------------------------------------------
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 && // R
        bytes[1] == 0x49 && // I
        bytes[2] == 0x46 && // F
        bytes[3] == 0x46 && // F
        bytes[8] == 0x57 && // W
        bytes[9] == 0x45 && // E
        bytes[10] == 0x42 && // B
        bytes[11] == 0x50) {
      return true;
    }

    return false;
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final imageWidth = width ?? size;
    final imageHeight = height ?? size;

    // Tidak ada data image
    if (!_hasImage) {
      return _placeholder(width: imageWidth, height: imageHeight);
    }

    // Ada byte tetapi bukan format image yang didukung
    if (!_isSupportedImage) {
      return _placeholder(width: imageWidth, height: imageHeight);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.memory(
        image!,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          return _placeholder(width: imageWidth, height: imageHeight);
        },
      ),
    );
  }

  // ================================================================
  // PLACEHOLDER
  // ================================================================

  Widget _placeholder({required double? width, required double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: MyColors.border.withValues(alpha: .7)),
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
