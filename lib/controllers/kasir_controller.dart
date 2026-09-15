import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/kasir_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasirController extends GetxController {
  // ============================================================
  // DATA
  // ============================================================

  final listOutlet = <KasirModel>[].obs;

  // ============================================================
  // STATE
  // ============================================================

  final isLoading = true.obs;

  final idKasir = 0.obs;
  final namaKasir = ''.obs;

  final idKios = 0.obs;
  final namaKios = ''.obs;

  final idCabang = 0.obs;
  final namaCabang = ''.obs;

  final alamatCabang = ''.obs;
  final phoneCabang = ''.obs;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchDataListOutlet();
  }

  // ============================================================
  // LOAD DATA KASIR + OUTLET
  // ============================================================

  Future<void> fetchDataListOutlet() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();

      // ==========================================================
      // LOAD LOCAL SESSION
      // ==========================================================

      idKios.value = prefs.getInt('id_kios') ?? 0;
      idKasir.value = prefs.getInt('id_kasir') ?? 0;
      idCabang.value = prefs.getInt('id_cabang') ?? 0;

      namaKasir.value = prefs.getString('nama_kasir') ?? '';
      namaKios.value = prefs.getString('kios') ?? '';
      namaCabang.value = prefs.getString('cabang') ?? '';

      alamatCabang.value = prefs.getString('alamat_cabang') ?? '';

      phoneCabang.value = prefs.getString('phone_cabang') ?? '';

      // ==========================================================
      // LOAD OUTLET
      // ==========================================================

      if (idKios.value == 0 || idKasir.value == 0) {
        return;
      }

      final result = await RemoteDataSource.getListOutlet({
        'id_kios': idKios.value,
        'id_kasir': idKasir.value,
      });

      if (result != null) {
        listOutlet.assignAll(result);
      }
    } catch (error) {
      print('KasirController.fetchDataListOutlet: $error');
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // CHANGE BRANCH / OUTLET
  // ============================================================

  Future<void> changeBranchOutlet() async {
    final prefs = await SharedPreferences.getInstance();

    // ==========================================================
    // SAVE SESSION
    // ==========================================================

    await prefs.setInt('id_kasir', idKasir.value);

    await prefs.setString('nama_kasir', namaKasir.value);

    await prefs.setInt('id_kios', idKios.value);

    await prefs.setString('kios', namaKios.value);

    await prefs.setInt('id_cabang', idCabang.value);

    await prefs.setString('cabang', namaCabang.value);

    await prefs.setString('alamat_cabang', alamatCabang.value);

    await prefs.setString('phone_cabang', phoneCabang.value);

    // ==========================================================
    // REFRESH REACTIVE STATE
    // ==========================================================

    namaKasir.refresh();
    namaKios.refresh();
    namaCabang.refresh();
    idKios.refresh();
    idCabang.refresh();

    // ==========================================================
    // RELOAD PRODUCT
    // ==========================================================

    if (Get.isRegistered<ProductController>()) {
      await Get.find<ProductController>().fetchProductCategory();
    }
  }
}
