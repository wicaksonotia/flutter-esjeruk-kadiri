import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/controllers/kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOutletPage extends StatefulWidget {
  const ChangeOutletPage({super.key});

  @override
  State<ChangeOutletPage> createState() => _ChangeOutletPageState();
}

class _ChangeOutletPageState extends State<ChangeOutletPage> {
  final KasirController kasirController = Get.put(KasirController());

  @override
  void initState() {
    super.initState();
    kasirController.fetchDataListOutlet();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .5,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (kasirController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: kasirController.listOutlet.length,
              itemBuilder: (context, index) {
                final outlet = kasirController.listOutlet[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      kasirController.idKasir.value = outlet.idKasir!;
                      kasirController.namaKasir.value = outlet.namaKasir ?? '';
                      kasirController.idKios.value = outlet.idKios!;
                      kasirController.namaKios.value = outlet.kios ?? '';
                      kasirController.idCabang.value = outlet.idCabang!;
                      kasirController.namaCabang.value = outlet.cabang ?? '';
                      kasirController.alamatCabang.value =
                          outlet.alamatCabang ?? '';
                      kasirController.phoneCabang.value =
                          outlet.phoneCabang ?? '';
                      kasirController.changeBranchOutlet();
                    },
                    title: Text(
                      '${outlet.kios!} - ${outlet.cabang!}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      outlet.alamatCabang!.replaceAll(r'\n', '\n'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                    trailing: Obx(
                      () => Icon(
                        Icons.check_circle,
                        color:
                            (outlet.idKios == kasirController.idKios.value &&
                                    outlet.idKasir ==
                                        kasirController.idKasir.value &&
                                    outlet.idCabang ==
                                        kasirController.idCabang.value)
                                ? Colors.lightGreen
                                : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}
