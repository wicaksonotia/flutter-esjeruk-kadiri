import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOutletPage extends StatefulWidget {
  const ChangeOutletPage({super.key});

  @override
  State<ChangeOutletPage> createState() => _ChangeOutletPageState();
}

class _ChangeOutletPageState extends State<ChangeOutletPage> {
  final KasirController kasirController = Get.find<KasirController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .38,
      maxChildSize: .9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Material(
          color: MyColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Obx(() {
            if (kasirController.isLoading.value) {
              return _buildLoading();
            }

            if (kasirController.listOutlet.isEmpty) {
              return _buildEmpty();
            }

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: kasirController.listOutlet.length,
                    itemBuilder: (context, index) {
                      final outlet = kasirController.listOutlet[index];

                      return _buildOutletItem(outlet: outlet, index: index);
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 21,
                  color: MyColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Outlet',
                      style: TextStyle(
                        fontSize: MySizes.fontSizeLg,
                        fontWeight: FontWeight.w800,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pilih outlet yang sedang kamu gunakan',
                      style: TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutletItem({required dynamic outlet, required int index}) {
    return Obx(() {
      final isSelected =
          outlet.idKios == kasirController.idKios.value &&
          outlet.idKasir == kasirController.idKasir.value &&
          outlet.idCabang == kasirController.idCabang.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: isSelected ? MyColors.primaryLight : MyColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),

            // LOGIC ASLI — JANGAN DIUBAH
            onTap: () {
              kasirController.idKasir.value = outlet.idKasir!;
              kasirController.namaKasir.value = outlet.namaKasir ?? '';
              kasirController.idKios.value = outlet.idKios!;
              kasirController.namaKios.value = outlet.kios ?? '';
              kasirController.idCabang.value = outlet.idCabang!;
              kasirController.namaCabang.value = outlet.cabang ?? '';
              kasirController.alamatCabang.value = outlet.alamatCabang ?? '';
              kasirController.phoneCabang.value = outlet.phoneCabang ?? '';
              kasirController.changeBranchOutlet();
            },

            splashColor: MyColors.primary.withValues(alpha: .06),
            highlightColor: MyColors.primary.withValues(alpha: .03),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      isSelected
                          ? MyColors.primary.withValues(alpha: .35)
                          : MyColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? MyColors.surface : MyColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      size: 20,
                      color:
                          isSelected
                              ? MyColors.primaryDark
                              : MyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${outlet.kios!} - ${outlet.cabang!}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: MySizes.fontSizeMd,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected
                                    ? MyColors.primaryDark
                                    : MyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          outlet.alamatCabang!.replaceAll(r'\n', '\n'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: MySizes.fontSizeSm,
                            color: MyColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // OBX tetap seperti behavior sebelumnya
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            (outlet.idKios == kasirController.idKios.value &&
                                    outlet.idKasir ==
                                        kasirController.idKasir.value &&
                                    outlet.idCabang ==
                                        kasirController.idCabang.value)
                                ? MyColors.primary
                                : MyColors.surfaceSoft,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 17,
                        color:
                            (outlet.idKios == kasirController.idKios.value &&
                                    outlet.idKasir ==
                                        kasirController.idKasir.value &&
                                    outlet.idCabang ==
                                        kasirController.idCabang.value)
                                ? MyColors.textOnPrimary
                                : MyColors.textMuted,
                      ),
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

  Widget _buildLoading() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: 4,
            itemBuilder: (_, _) {
              return Container(
                height: 82,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: MyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: MyColors.border),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.store_outlined,
                      color: MyColors.primaryDark,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Outlet tidak tersedia',
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Belum ada outlet yang dapat dipilih.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeSm,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
