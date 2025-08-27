import 'package:cashier/models/kasir_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasirController extends GetxController {
  var listOutlet = <KasirModel>[].obs;
  var isLoading = true.obs;
  var idKasir = 0.obs;
  var namaKasir = ''.obs;
  var idKios = 0.obs;
  var namaKios = ''.obs;
  var idCabang = 0.obs;
  var namaCabang = ''.obs;
  var alamatCabang = ''.obs;
  var phoneCabang = ''.obs;

  @override
  void onInit() {
    fetchDataListOutlet();
    super.onInit();
  }

  void fetchDataListOutlet() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs);
      idKios.value = prefs.getInt('id_kios')!;
      idKasir.value = prefs.getInt('id_kasir')!;
      idCabang.value = prefs.getInt('id_cabang')!;
      namaKios.value = prefs.getString('kios')!;
      namaCabang.value = prefs.getString('cabang')!;
      var rawFormat = {'id_kios': idKios.value, 'id_kasir': idKasir.value};
      var result = await RemoteDataSource.getListOutlet(rawFormat);
      if (result != null) {
        listOutlet.assignAll(result);
      }
    } finally {
      isLoading(false);
    }
  }

  void changeBranchOutlet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_kasir', idKasir.value);
    await prefs.setString('nama_kasir', namaKasir.value);
    await prefs.setInt('id_kios', idKios.value);
    await prefs.setString('kios', namaKios.value);
    await prefs.setInt('id_cabang', idCabang.value);
    await prefs.setString('cabang', namaCabang.value);
    await prefs.setString('alamat_cabang', alamatCabang.value);
    await prefs.setString('phone_cabang', phoneCabang.value);
  }
}
