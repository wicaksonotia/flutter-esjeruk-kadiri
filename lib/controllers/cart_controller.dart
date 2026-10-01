import 'dart:math';

import 'package:cashier/commons/currency.dart';
import 'package:cashier/database/repositories/transaction_repository.dart';
import 'package:cashier/models/cart_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/navigation/app_navigation.dart';
import 'package:cashier/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();

  final SyncService _syncService = Get.find<SyncService>();

  RxList<CartModel> cartList = <CartModel>[].obs;

  var isLoading = false.obs;

  var numberOfItems = 1.obs;

  var subTotal = 0.obs;

  var totalAllQuantity = 0.obs;

  var paymentMethod = 'Cash'.obs;

  final TextEditingController discountController = TextEditingController();

  var totalBayar = 0.obs;

  final TextEditingController bayarTunai = TextEditingController();

  var isButtonDisabled = true.obs;

  // ============================================================
  // CART
  // ============================================================

  void incrementProductQuantity(ProductModel dataProduct) {
    if (cartList
        .where((element) => element.idProduct == dataProduct.idProduct)
        .isNotEmpty) {
      final index = cartList.indexWhere(
        (element) => element.idProduct == dataProduct.idProduct,
      );

      cartList[index].quantity++;
    } else {
      cartList.add(
        CartModel(
          productModel: dataProduct,
          idProduct: dataProduct.idProduct!,
          quantity: 1,
        ),
      );
    }

    cartList.refresh();

    totalAllQuantity++;

    subTotal.value += dataProduct.price ?? 0;

    buttonCheckhoutDisable();

    applyDiscount();

    update();
  }

  void decrementProductQuantity(ProductModel dataProduct) {
    final index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );

    if (index < 0) {
      return;
    }

    final cartItem = cartList[index];

    if (cartItem.quantity > 1) {
      cartItem.quantity--;

      totalAllQuantity.value--;

      subTotal.value -= dataProduct.price ?? 0;

      cartList.refresh();
    } else {
      removeProduct(dataProduct);
      return;
    }

    buttonCheckhoutDisable();

    applyDiscount();

    update();
  }

  void removeProduct(ProductModel dataProduct) {
    final index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );

    if (index >= 0) {
      final quantity = cartList[index].quantity;

      totalAllQuantity.value -= quantity;

      subTotal.value -= (dataProduct.price ?? 0) * quantity;

      cartList.removeAt(index);
    }

    buttonCheckhoutDisable();

    applyDiscount();

    update();
  }

  int getProductQuantity(ProductModel dataProduct) {
    final index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );

    if (index >= 0) {
      return cartList[index].quantity;
    }

    return 0;
  }

  void buttonCheckhoutDisable() {
    isButtonDisabled.value = cartList.isEmpty;
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  void applyDiscount() {
    int calculatedDiscount = 0;

    if (discountController.text.isNotEmpty) {
      calculatedDiscount =
          int.tryParse(
            discountController.text.replaceAll(RegExp(r'[^0-9\-]'), ''),
          ) ??
          0;
    }

    if (calculatedDiscount < 0) {
      calculatedDiscount = 0;
    }

    if (calculatedDiscount > subTotal.value) {
      calculatedDiscount = subTotal.value;
    }

    totalBayar.value = subTotal.value - calculatedDiscount;

    bayarTunai.text = CurrencyFormat.convertToIdr(totalBayar.value, 0);

    update();
  }

  int _getCalculatedDiscount() {
    int discount = 0;

    if (discountController.text.isNotEmpty) {
      discount =
          int.tryParse(
            discountController.text.replaceAll(RegExp(r'[^0-9\-]'), ''),
          ) ??
          0;
    }

    if (discount < 0) {
      discount = 0;
    }

    if (discount > subTotal.value) {
      discount = subTotal.value;
    }

    return discount;
  }

  // ============================================================
  // LOCAL UUID
  // ============================================================

  String _generateLocalUuid({required int idKios, required int idKasir}) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final random = Random.secure().nextInt(999999);

    return 'KSR-$idKios-$idKasir-$timestamp-$random';
  }

  // ============================================================
  // BRANCH CODE
  // ============================================================

  String _getBranchCode(SharedPreferences prefs) {
    final value = prefs.getString('kode_cabang');

    if (value == null || value.trim().isEmpty) {
      throw Exception('Kode outlet tidak ditemukan.');
    }

    return value.trim().toUpperCase();
  }

  // ============================================================
  // SAVE TRANSACTION
  // ============================================================

  Future<void> saveCart() async {
    if (cartList.isEmpty) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    try {
      isLoading(true);

      // ========================================================
      // USER SESSION
      // ========================================================

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final int kios = prefs.getInt('id_kios') ?? 0;

      final int cabang = prefs.getInt('id_cabang') ?? 0;

      final int kasir = prefs.getInt('id_kasir') ?? 0;

      final String branchCode = _getBranchCode(prefs);

      if (kios == 0 || cabang == 0 || kasir == 0) {
        throw Exception('Data outlet atau kasir tidak ditemukan.');
      }

      // ========================================================
      // DISCOUNT
      // ========================================================

      final int calculatedDiscount = _getCalculatedDiscount();

      final int calculatedTotal = subTotal.value - calculatedDiscount;

      totalBayar.value = calculatedTotal;

      // ========================================================
      // LOCAL UUID
      // ========================================================

      final String localUuid = _generateLocalUuid(idKios: kios, idKasir: kasir);

      final DateTime transactionDate = DateTime.now();

      // ========================================================
      // LOCAL DETAILS
      // ========================================================

      final List<TransactionDetailData> localDetails =
          cartList.map((cartItem) {
            return TransactionDetailData(
              idProduct: cartItem.idProduct,

              productName: cartItem.productModel.productName ?? '',

              quantity: cartItem.quantity,

              unitPrice: cartItem.productModel.price ?? 0,
            );
          }).toList();

      // ========================================================
      // SAVE TO SQLITE
      // ========================================================

      final int localNumber = await _transactionRepository.saveLocalTransaction(
        localUuid: localUuid,

        idKios: kios,

        idCabang: cabang,

        idKasir: kasir,

        branchCode: branchCode,

        subTotal: subTotal.value,

        discount: calculatedDiscount,

        totalBayar: calculatedTotal,

        totalQuantity: totalAllQuantity.value,

        paymentMethod: paymentMethod.value,

        transactionDate: transactionDate,

        details: localDetails,
      );

      debugPrint('================================================');

      debugPrint('LOCAL TRANSACTION SAVED');

      debugPrint('UUID        : $localUuid');

      debugPrint('BRANCH CODE : $branchCode');

      debugPrint('LOCAL NUMBER: $localNumber');

      debugPrint(
        'DISPLAY     : HIMALAYA/'
        '$branchCode/'
        'LOCAL-${localNumber.toString().padLeft(4, '0')}',
      );

      debugPrint('================================================');

      // ========================================================
      // LOCAL DATABASE BERHASIL
      // ========================================================

      clearCart();

      // ========================================================
      // KEMBALI KE PRODUCT
      // ========================================================

      Get.offNamed(RouterClass.product);

      // ========================================================
      // NOTIFICATION
      // ========================================================

      Get.snackbar(
        'Transaksi berhasil',
        'Transaksi tersimpan di perangkat.',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      // ========================================================
      // BACKGROUND SYNC
      // ========================================================

      Future.microtask(() async {
        try {
          await _syncService.syncPendingTransactions();
        } catch (e) {
          debugPrint('BACKGROUND SYNC ERROR: $e');
        }
      });
    } catch (e) {
      debugPrint('SAVE LOCAL TRANSACTION ERROR: $e');

      Get.snackbar(
        'Transaksi gagal',
        'Transaksi belum tersimpan: '
            '${e.toString()}',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  void clearCart() {
    cartList.clear();

    buttonCheckhoutDisable();

    totalAllQuantity.value = 0;

    subTotal.value = 0;

    discountController.clear();

    totalBayar.value = 0;

    bayarTunai.clear();

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    discountController.dispose();

    bayarTunai.dispose();

    super.onClose();
  }
}
