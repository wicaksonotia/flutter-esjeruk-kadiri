import 'package:cashier/commons/colors.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // ============================================================
  // STATE
  // ============================================================

  var isPasswordVisible = false.obs;
  var isPasswordCurrentVisible = false.obs;
  var isPasswordNewVisible = false.obs;
  var isPasswordConfirmVisible = false.obs;

  var isLoading = false.obs;
  var isLogin = false.obs;

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTelponController = TextEditingController();

  // ============================================================
  // PROFILE
  // ============================================================

  var idCabang = 0.obs;
  var namaCabang = ''.obs;
  var alamatCabang = ''.obs;
  var phoneCabang = ''.obs;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    namaController.dispose();
    noTelponController.dispose();

    super.onClose();
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void showPassword() {
    isPasswordVisible.toggle();
  }

  void showCurrentPassword() {
    isPasswordCurrentVisible.toggle();
  }

  void showNewPassword() {
    isPasswordNewVisible.toggle();
  }

  void showConfirmPassword() {
    isPasswordConfirmVisible.toggle();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> loginWithEmail() async {
    try {
      isLoading(true);

      final Dio.FormData formData = Dio.FormData.fromMap({
        "username": emailController.text.trim(),
        "password": passwordController.text,
      });

      final bool result = await RemoteDataSource.login(formData);

      if (!result) {
        throw "Kios is not registered";
      }

      Get.offAllNamed(RouterClass.product);
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> changePasswordProcess() async {
    try {
      isLoading(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (currentController.text.isEmpty ||
          newController.text.isEmpty ||
          confirmController.text.isEmpty) {
        throw "All fields are required";
      }

      if (newController.text.contains(' ') ||
          confirmController.text.contains(' ') ||
          currentController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      }

      final String savedPassword = prefs.getString('password') ?? '';

      if (currentController.text != savedPassword) {
        throw "Current password is incorrect";
      }

      if (newController.text.length < 6 || confirmController.text.length < 6) {
        throw "Password must be at least 6 characters";
      }

      if (newController.text != confirmController.text) {
        throw "New password and confirm password do not match";
      }

      if (currentController.text == newController.text) {
        throw "New password must be different from current password";
      }

      final rawFormat = {
        "username": prefs.getString('username') ?? '',
        "new_password": newController.text,
      };

      final bool result = await RemoteDataSource.changePasswordProcess(
        rawFormat,
      );

      if (!result) {
        throw "Failed to change password";
      }

      await prefs.setString('password', newController.text);

      clearChangePasswordControllers();

      Get.snackbar(
        'Notification',
        'Password changed successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> updateProfileProcess() async {
    try {
      isLoading(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // --------------------------------------------------------
      // Ambil id cabang dari SharedPreferences sebagai fallback.
      // --------------------------------------------------------

      final int savedIdCabang = prefs.getInt('id_cabang') ?? 0;

      // --------------------------------------------------------
      // Prioritas:
      // 1. Cabang yang sedang dipilih di controller
      // 2. Cabang yang tersimpan di SharedPreferences
      // --------------------------------------------------------

      final int selectedIdCabang =
          idCabang.value != 0 ? idCabang.value : savedIdCabang;

      // --------------------------------------------------------
      // Jangan kirim id_cabang = 0
      // --------------------------------------------------------

      if (selectedIdCabang == 0) {
        throw "Cabang belum dipilih";
      }

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      final rawFormat = {
        "username": prefs.getString('username') ?? '',
        "nama_kasir": namaController.text.trim(),
        "phone_kasir": noTelponController.text.trim(),
        "id_cabang": selectedIdCabang,
      };

      // debugPrint('========================================');
      // debugPrint('UPDATE PROFILE');
      // debugPrint('username    : ${rawFormat["username"]}');
      // debugPrint('nama_kasir  : ${rawFormat["nama_kasir"]}');
      // debugPrint('phone_kasir : ${rawFormat["phone_kasir"]}');
      // debugPrint('id_cabang   : ${rawFormat["id_cabang"]}');
      // debugPrint('========================================');

      final bool result = await RemoteDataSource.updateProfile(rawFormat);

      if (!result) {
        throw "Failed to update profile";
      }

      // --------------------------------------------------------
      // Update state controller
      // --------------------------------------------------------

      idCabang.value = selectedIdCabang;

      // --------------------------------------------------------
      // Simpan profile ke SharedPreferences
      // --------------------------------------------------------

      await prefs.setString('nama_kasir', namaController.text.trim());

      await prefs.setString('phone_kasir', noTelponController.text.trim());

      await prefs.setInt('id_cabang', selectedIdCabang);

      await prefs.setString('cabang', namaCabang.value);

      await prefs.setString('alamat_cabang', alamatCabang.value);

      await prefs.setString('phone_cabang', phoneCabang.value);

      // --------------------------------------------------------
      // Sync ke KasirController (UI utama)
      // --------------------------------------------------------
      if (Get.isRegistered<KasirController>()) {
        final kasir = Get.find<KasirController>();

        kasir.idCabang.value = idCabang.value;
        kasir.namaCabang.value = namaCabang.value;
        kasir.alamatCabang.value = alamatCabang.value;
        kasir.phoneCabang.value = phoneCabang.value;
      }

      update();
      // --------------------------------------------------------
      // Success
      // --------------------------------------------------------

      Get.snackbar(
        'Notification',
        'Profile updated successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // CHECK LOGIN STATUS
  // ============================================================

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isLogin.value = prefs.getBool('statusLogin') ?? false;

    if (isLogin.value) {
      Get.offAllNamed(RouterClass.product);
    } else {
      Get.offAllNamed(RouterClass.login);
    }
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // Data kasir
    // ----------------------------------------------------------

    namaController.text = prefs.getString('nama_kasir') ?? '';

    noTelponController.text = prefs.getString('phone_kasir') ?? '';

    // ----------------------------------------------------------
    // Data cabang
    // ----------------------------------------------------------

    idCabang.value = prefs.getInt('id_cabang') ?? 0;

    namaCabang.value = prefs.getString('cabang') ?? '';

    alamatCabang.value = prefs.getString('alamat_cabang') ?? '';

    phoneCabang.value = prefs.getString('phone_cabang') ?? '';

    // ----------------------------------------------------------
    // Debug
    // ----------------------------------------------------------

    // debugPrint('========================================');
    // debugPrint('CHECK PROFILE');
    // debugPrint('nama_kasir   : ${namaController.text}');
    // debugPrint('phone_kasir  : ${noTelponController.text}');
    // debugPrint('id_cabang    : ${idCabang.value}');
    // debugPrint('cabang       : ${namaCabang.value}');
    // debugPrint('alamat       : ${alamatCabang.value}');
    // debugPrint('phone cabang : ${phoneCabang.value}');
    // debugPrint('========================================');
  }

  // ============================================================
  // CLEAR CHANGE PASSWORD
  // ============================================================

  void clearChangePasswordControllers() {
    currentController.clear();
    newController.clear();
    confirmController.clear();
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    isLogin.value = false;

    Get.offAllNamed(RouterClass.login);
  }

  // ============================================================
  // LOGOUT BOTTOM SHEET
  // ============================================================

  void openBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Do you want to logout?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MySizes.fontSizeLg,
                ),
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyColors.surface,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.thumb_up),
                  onPressed: logout,
                  label: const Text('yes'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyColors.surface,
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () => Get.back(),
                  label: const Text('cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
      persistent: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: MyColors.surface,
      elevation: 1,
    );
  }
}
