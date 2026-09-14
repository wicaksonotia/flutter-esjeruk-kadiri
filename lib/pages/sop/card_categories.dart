import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/sop_controller.dart';
import 'package:cashier/networks/api_endpoints.dart';
import 'package:cashier/pages/sop/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardCategories extends StatelessWidget {
  const CardCategories({
    super.key,
    required this.sopController,
    required this.index,
  });

  final SopController sopController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sop = sopController.listSop[index];
      final name = sop.sopName?.trim() ?? '';

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(
              () => PdfViewerPage(
                url:
                    '${ApiEndPoints.ipPublic}upload/sertifikat/${sop.sopFile!}',
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: MyColors.primary.withValues(alpha: .06),
          highlightColor: MyColors.primary.withValues(alpha: .03),
          child: Ink(
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MyColors.border),
              boxShadow: const [
                BoxShadow(
                  color: MyColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon utama
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: MyColors.primaryDark,
                      size: 21,
                    ),
                  ),

                  const Spacer(),

                  // Nama SOP
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MyColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Keterangan
                  const Text(
                    'Buka dokumen',
                    style: TextStyle(
                      color: MyColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
