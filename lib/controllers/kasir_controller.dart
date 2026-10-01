import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/controllers/transaction_controller.dart';
import 'package:cashier/models/kasir_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/foundation.dart';
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
  final kodeCabang = ''.obs;

  final alamatCabang = ''.obs;
  final phoneCabang = ''.obs;

  // ============================================================
  // CHANGE OUTLET STATE
  // ============================================================

  final isChangingOutlet = false.obs;

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

      kodeCabang.value =
          (prefs.getString('kode_cabang') ?? '').trim().toUpperCase();

      alamatCabang.value = prefs.getString('alamat_cabang') ?? '';

      phoneCabang.value = prefs.getString('phone_cabang') ?? '';

      // ==========================================================
      // VALIDASI SESSION
      // ==========================================================

      if (idKios.value == 0 || idKasir.value == 0) {
        return;
      }

      // ==========================================================
      // LOAD LIST OUTLET
      // ==========================================================

      final result = await RemoteDataSource.getListOutlet({
        'id_kios': idKios.value,
        'id_kasir': idKasir.value,
      });

      if (result != null) {
        listOutlet.assignAll(result);
      }

      // ==========================================================
      // DEBUG
      // ==========================================================

      debugPrint('========================================');

      debugPrint('LOAD SESSION');
      debugPrint('id_kios     : ${idKios.value}');
      debugPrint('kios        : ${namaKios.value}');
      debugPrint('id_cabang   : ${idCabang.value}');
      debugPrint('cabang      : ${namaCabang.value}');
      debugPrint('kode_cabang : ${kodeCabang.value}');
      debugPrint('id_kasir    : ${idKasir.value}');
      debugPrint('nama_kasir  : ${namaKasir.value}');

      debugPrint('========================================');
    } catch (error) {
      debugPrint('KasirController.fetchDataListOutlet: $error');
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // SET SELECTED OUTLET
  // ============================================================
  //
  // Dipanggil ketika user memilih outlet dari list.
  //
  // Contoh:
  //
  // setSelectedOutlet(item);
  // await changeBranchOutlet();
  //
  // ============================================================

  void setSelectedOutlet(KasirModel outlet) {
    // ==========================================================
    // KIOS
    // ==========================================================

    idKios.value = outlet.idKios ?? idKios.value;

    namaKios.value = (outlet.kios ?? namaKios.value).trim();

    // ==========================================================
    // CABANG
    // ==========================================================

    idCabang.value = outlet.idCabang ?? idCabang.value;

    namaCabang.value = (outlet.cabang ?? namaCabang.value).trim();

    // ==========================================================
    // KODE CABANG
    // ==========================================================

    kodeCabang.value = (outlet.kode ?? '').trim().toUpperCase();

    // ==========================================================
    // ALAMAT
    // ==========================================================

    alamatCabang.value = (outlet.alamatCabang ?? alamatCabang.value).trim();

    // ==========================================================
    // PHONE
    // ==========================================================

    phoneCabang.value = (outlet.phoneCabang ?? phoneCabang.value).trim();

    // ==========================================================
    // KASIR
    // ==========================================================

    idKasir.value = outlet.idKasir ?? idKasir.value;

    namaKasir.value = (outlet.namaKasir ?? namaKasir.value).trim();

    // ==========================================================
    // DEBUG
    // ==========================================================

    debugPrint('========================================');

    debugPrint('SELECTED OUTLET');
    debugPrint('id_kios     : ${idKios.value}');
    debugPrint('kios        : ${namaKios.value}');
    debugPrint('id_cabang   : ${idCabang.value}');
    debugPrint('cabang      : ${namaCabang.value}');
    debugPrint('kode_cabang : ${kodeCabang.value}');
    debugPrint('id_kasir    : ${idKasir.value}');
    debugPrint('nama_kasir  : ${namaKasir.value}');

    debugPrint('========================================');
  }

  // ============================================================
  // CHANGE BRANCH / OUTLET
  // ============================================================

  Future<void> changeBranchOutlet() async {
    // ==========================================================
    // CEGAH DOUBLE TAP
    // ==========================================================

    if (isChangingOutlet.value) {
      return;
    }

    try {
      isChangingOutlet(true);

      final prefs = await SharedPreferences.getInstance();

      // ==========================================================
      // VALIDASI
      // ==========================================================

      if (idKios.value == 0) {
        throw Exception('ID kios tidak ditemukan.');
      }

      if (idCabang.value == 0) {
        throw Exception('ID cabang tidak ditemukan.');
      }

      if (idKasir.value == 0) {
        throw Exception('ID kasir tidak ditemukan.');
      }

      if (kodeCabang.value.trim().isEmpty) {
        throw Exception('Kode outlet tidak ditemukan.');
      }

      // ==========================================================
      // NORMALISASI
      // ==========================================================

      kodeCabang.value = kodeCabang.value.trim().toUpperCase();

      // ==========================================================
      // SAVE SESSION
      // ==========================================================

      await prefs.setInt('id_kasir', idKasir.value);

      await prefs.setString('nama_kasir', namaKasir.value);

      await prefs.setInt('id_kios', idKios.value);

      await prefs.setString('kios', namaKios.value);

      await prefs.setInt('id_cabang', idCabang.value);

      await prefs.setString('cabang', namaCabang.value);

      // ==========================================================
      // KODE OUTLET
      // ==========================================================

      await prefs.setString('kode_cabang', kodeCabang.value);

      await prefs.setString('alamat_cabang', alamatCabang.value);

      await prefs.setString('phone_cabang', phoneCabang.value);

      // ==========================================================
      // DEBUG SESSION
      // ==========================================================

      debugPrint('========================================');

      debugPrint('CHANGE OUTLET SUCCESS');
      debugPrint('id_kios     : ${idKios.value}');
      debugPrint('kios        : ${namaKios.value}');
      debugPrint('id_cabang   : ${idCabang.value}');
      debugPrint('cabang      : ${namaCabang.value}');
      debugPrint('kode_cabang : ${kodeCabang.value}');
      debugPrint('id_kasir    : ${idKasir.value}');
      debugPrint('nama_kasir  : ${namaKasir.value}');

      debugPrint('========================================');

      // ==========================================================
      // RELOAD PRODUCT
      // ==========================================================

      Future<void> reloadProduct() async {
        if (!Get.isRegistered<ProductController>()) {
          return;
        }

        try {
          await Get.find<ProductController>().fetchProductCategory();
        } catch (error) {
          debugPrint('KasirController.reloadProduct: $error');
        }
      }

      // ==========================================================
      // RELOAD TRANSACTION
      // ==========================================================

      Future<void> reloadTransaction() async {
        if (!Get.isRegistered<TransactionController>()) {
          return;
        }

        try {
          await Get.find<TransactionController>().refreshAfterOutletChanged();
        } catch (error) {
          debugPrint('KasirController.reloadTransaction: $error');
        }
      }

      // ==========================================================
      // RELOAD DATA
      // ==========================================================

      await Future.wait([reloadProduct(), reloadTransaction()]);
    } catch (error) {
      debugPrint('KasirController.changeBranchOutlet: $error');
    } finally {
      isChangingOutlet(false);
    }
  }
}
