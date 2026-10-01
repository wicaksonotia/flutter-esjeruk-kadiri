import 'package:cashier/commons/colors.dart';
import 'package:cashier/networks/api_endpoints.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? image;
  final String folder;

  final double? width;
  final double? height;
  final double size;
  final double borderRadius;

  final IconData placeholderIcon;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.image,
    required this.folder,
    this.width,
    this.height,
    this.size = 90,
    this.borderRadius = 14,
    this.placeholderIcon = Icons.fastfood_rounded,
    this.fit = BoxFit.cover,
  });

  // ================================================================
  // IMAGE VALIDATION
  // ================================================================

  bool get _hasImage {
    return image != null && image!.trim().isNotEmpty;
  }

  // ================================================================
  // IMAGE URL
  // ================================================================

  String get _imageUrl {
    final value = image!.trim();

    // --------------------------------------------------------------
    // Backend mengirim URL lengkap
    // --------------------------------------------------------------

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    // --------------------------------------------------------------
    // Backend hanya mengirim nama file
    // --------------------------------------------------------------

    return '${ApiEndPoints.ipPublic}images/$folder/$value';
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final imageWidth = width ?? size;
    final imageHeight = height ?? size;

    return Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: MyColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          _hasImage
              ? Image.network(
                _imageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: fit,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) {
                  return _Placeholder(icon: placeholderIcon);
                },
              )
              : _Placeholder(icon: placeholderIcon),
    );
  }
}

// ================================================================
// PLACEHOLDER
// ================================================================

class _Placeholder extends StatelessWidget {
  final IconData icon;

  const _Placeholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(icon, size: 29, color: MyColors.textMuted));
  }
}
