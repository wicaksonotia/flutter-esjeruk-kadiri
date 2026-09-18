import 'package:cashier/commons/background_form.dart';
import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: MyColors.background,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: BackgroundForm(
            headerTitle: 'Ubah Password',
            container: _buildBody(),
          ),
        ),
      ),
    );
  }

  //============================================================
  // BODY
  //============================================================

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 24),
      child: Column(
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildFormCard(),
        ],
      ),
    );
  }

  //============================================================
  // HEADER CARD
  //============================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: MyColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: MyColors.primary,
              size: 26,
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Perbarui password akun untuk menjaga keamanan akses Kasira.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //============================================================
  // FORM CARD
  //============================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MyColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Masukkan password lama dan password baru.',
            style: TextStyle(color: MyColors.textSecondary, height: 1.4),
          ),

          const SizedBox(height: 24),

          _buildPasswordField(
            title: 'Password Lama',
            controllerText: controller.currentController,
            visible: controller.isPasswordCurrentVisible.value,
            onTap: controller.showCurrentPassword,
          ),

          const SizedBox(height: 18),

          _buildPasswordField(
            title: 'Password Baru',
            controllerText: controller.newController,
            visible: controller.isPasswordNewVisible.value,
            onTap: controller.showNewPassword,
          ),

          const SizedBox(height: 18),

          _buildPasswordField(
            title: 'Konfirmasi Password',
            controllerText: controller.confirmController,
            visible: controller.isPasswordConfirmVisible.value,
            onTap: controller.showConfirmPassword,
          ),

          const SizedBox(height: 24),

          _buildInfoBox(),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : controller.changePasswordProcess,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                disabledBackgroundColor: MyColors.primary.withValues(
                  alpha: .55,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Simpan Password',
                            style: TextStyle(
                              fontSize: MySizes.fontSizeMd,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  //============================================================
  // PASSWORD FIELD
  //============================================================

  Widget _buildPasswordField({
    required String title,
    required TextEditingController controllerText,
    required bool visible,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controllerText,
          obscureText: !visible,
          style: const TextStyle(fontSize: 15, color: MyColors.textPrimary),
          decoration: InputDecoration(
            hintText: '••••••••••••',
            filled: true,
            fillColor: MyColors.surfaceSoft,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: MyColors.border),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: MyColors.primary, width: 1.4),
            ),

            suffixIcon: IconButton(
              onPressed: onTap,
              splashRadius: 22,
              icon: Icon(
                visible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: MyColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //============================================================
  // INFO BOX
  //============================================================

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.primaryLight.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.primary.withValues(alpha: .15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: MyColors.primary, size: 20),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              'Setelah password berhasil diubah, Anda akan otomatis keluar dan perlu login kembali.',
              style: TextStyle(
                color: MyColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
