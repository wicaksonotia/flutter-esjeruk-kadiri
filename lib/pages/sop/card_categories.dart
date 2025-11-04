import 'package:cashier/commons/containers/box_container.dart';
import 'package:cashier/commons/sizes.dart';
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
    return Obx(
      () => InkWell(
        onTap: () {
          Get.to(
            () => PdfViewerPage(
              url:
                  '${ApiEndPoints.ipPublic}upload/sertifikat/${sopController.listSop[index].sopFile!}',
            ),
          );
        },
        child: BoxContainer(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          radius: 15,
          shadow: true,
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              sopController.listSop[index].sopName!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MySizes.fontSizeSm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
