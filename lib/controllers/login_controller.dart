import 'package:dio/dio.dart' as Dio;
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isPasswordCurrentVisible = false.obs;
  var isPasswordNewVisible = false.obs;
  var isPasswordConfirmVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noTelponController = TextEditingController();
  var idCabang = 0.obs;
  var namaCabang = ''.obs;
  var alamatCabang = ''.obs;
  var phoneCabang = ''.obs;
  var isLogin = false.obs;

  showPassword() {
    isPasswordVisible(!isPasswordVisible.value);
  }

  showCurrentPassword() {
    isPasswordCurrentVisible(!isPasswordCurrentVisible.value);
  }

  showNewPassword() {
    isPasswordNewVisible(!isPasswordNewVisible.value);
  }

  showConfirmPassword() {
    isPasswordConfirmVisible(!isPasswordConfirmVisible.value);
  }

  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }

  Future<void> loginWithEmail() async {
    try {
      isLoading(true);
      Dio.FormData formData = Dio.FormData.fromMap({
        "username": emailController.text.trim(),
        "password": passwordController.text,
      });
      bool result = await RemoteDataSource.login(formData);
      if (result) {
        ProductController productController = Get.put(ProductController());
        productController.fetchProductCategory();
        productController.fetchProduct();
        KasirController kasirController = Get.put(KasirController());
        kasirController.fetchDataListOutlet();
        Get.offNamed(RouterClass.product);
      } else {
        throw "Kios is not regsitered";
      }
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

  Future<void> changePasswordProcess() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (currentController.text.isEmpty ||
          newController.text.isEmpty ||
          confirmController.text.isEmpty) {
        throw "All fields are required";
      } else if (newController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else if (confirmController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else if (currentController.text.contains(' ')) {
        throw "Password cannot contain spaces";
      } else {
        String savedPassword = prefs.getString('password') ?? '';
        if (currentController.text != savedPassword) {
          throw "Current password is incorrect";
        } else if (newController.text.length < 6 ||
            confirmController.text.length < 6) {
          throw "Password must be at least 6 characters";
        } else if (newController.text != confirmController.text) {
          throw "New password and confirm password do not match";
        } else if (currentController.text == newController.text) {
          throw "New password must be different from current password";
        }
      }

      var rawFormat = {
        "username": prefs.getString('username') ?? '',
        "new_password": newController.text,
      };
      bool result = await RemoteDataSource.changePasswordProcess(rawFormat);
      if (result) {
        prefs.setString('password', newController.text);
        clearChangePasswordControllers();
        throw "Password changed successfully";
      } else {
        throw "Failed to change password";
      }
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

  Future<void> updateProfileProcess() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {
        "username": prefs.getString('username') ?? '',
        "nama_kasir": namaController.text,
        "phone_kasir": noTelponController.text,
        "id_cabang": idCabang.value,
      };
      bool result = await RemoteDataSource.updateProfile(rawFormat);
      if (result) {
        prefs.setString('nama_kasir', namaController.text);
        prefs.setString('phone_kasir', noTelponController.text);
        prefs.setInt('id_cabang', idCabang.value);
        prefs.setString('cabang', namaCabang.value);
        prefs.setString('alamat_cabang', alamatCabang.value);
        prefs.setString('phone_cabang', phoneCabang.value);
        Get.snackbar(
          'Notification',
          'Profile updated successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw "Failed to update profile";
      }
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

  void checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('statusLogin') ?? false;
    if (isLogin.value == true) {
      Get.offAllNamed(RouterClass.product);
    } else {
      Get.offAllNamed(RouterClass.login);
    }
  }

  void clearChangePasswordControllers() {
    currentController.clear();
    newController.clear();
    confirmController.clear();
  }

  void checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    namaController.text = prefs.getString('nama_kasir') ?? '';
    noTelponController.text = prefs.getString('phone_kasir') ?? '';
    namaCabang.value = prefs.getString('cabang') ?? '';
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    isLogin.value = false;
    Get.offAllNamed(RouterClass.login);
  }

  void openBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        height: 120,
        // decoration: const BoxDecoration(
        //   borderRadius: BorderRadius.only(
        //     topRight: Radius.circular(10),
        //     topLeft: Radius.circular(10),
        //   ),
        // ),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => logout(),
                  label: const Text('yes'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }
}
