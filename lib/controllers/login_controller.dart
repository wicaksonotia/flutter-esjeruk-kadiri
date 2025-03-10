import 'package:dio/dio.dart' as Dio;
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLogin = false.obs;
  final SharedPreferences prefs = Get.find<SharedPreferences>();
  showPassword() {
    isPasswordVisible(!isPasswordVisible.value);
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
        // "password": passwordController.text,
      });
      bool result = await RemoteDataSource.login(formData);
      // print(result);
      if (result) {
        // final SharedPreferences prefs = await _prefs;
        await prefs.setBool('statusLogin', true);
        await prefs.setString('username', emailController.text.trim());
        // await prefs.setString('password', passwordController.text);
        Get.offNamed('/product');
      } else {
        throw "Kios is not regsitered";
      }
    } catch (error) {
      Get.snackbar('Notification', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('statusLogin') ?? false;
    if (isLogin.value == true) {
      Get.offAllNamed('/product');
    } else {
      Get.offAllNamed('/login');
    }
  }

  void logout() async {
    // final SharedPreferences prefs = await _prefs;
    prefs.setBool('statusLogin', false);
    isLogin.value = prefs.getBool('statusLogin') ?? false;
    print(isLogin.value);
    Get.offAllNamed('/login');
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
                    color: Colors.black, fontSize: MySizes.fontSizeLg),
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
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => logout(),
                  label: const Text('yes'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () => Get.back(),
                  label: const Text('cancel'),
                ),
              ],
            )
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
