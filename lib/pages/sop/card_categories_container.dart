import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/containers/box_container.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/sop_controller.dart';
import 'package:cashier/networks/api_endpoints.dart';
import 'package:cashier/pages/sop/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CardCategoriesContainer extends StatelessWidget {
  const CardCategoriesContainer({
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
          radius: 15,
          shadow: false,
          backgroundColor: MyColors.primary,
          child: Stack(
            children: [
              Positioned(
                top: -10,
                right: -70,
                child: Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        BoxContainer(
                          radius: 50,
                          height: 20,
                          width: 20,
                          backgroundColor: Colors.white,
                        ),
                        Gap(20),
                        BoxContainer(
                          radius: 50,
                          height: 20,
                          width: 20,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sopController.listSop[index].sopName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: MySizes.fontSizeLg,
                            ),
                          ),
                          // Text(
                          //   sopController.jenisUjiItem[index].keterangan!,
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: MySizes.fontSizeMd,
                          //   ),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
