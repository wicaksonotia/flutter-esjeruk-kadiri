import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChangeOutletPage extends StatefulWidget {
  const UserChangeOutletPage({super.key});

  @override
  State<UserChangeOutletPage> createState() => _UserChangeOutletPageState();
}

class _UserChangeOutletPageState extends State<UserChangeOutletPage> {
  final KasirController kasirController = Get.put(KasirController());
  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    kasirController.fetchDataListOutlet();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
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
                      loginController.idCabang.value = outlet.idCabang!;
                      loginController.namaCabang.value = outlet.cabang!;
                      loginController.alamatCabang.value = outlet.alamatCabang!;
                      loginController.phoneCabang.value = outlet.phoneCabang!;
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
                                        loginController.idCabang.value)
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
