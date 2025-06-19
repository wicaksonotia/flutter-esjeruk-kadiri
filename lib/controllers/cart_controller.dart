import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/navigation/app_navigation.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final PrintNotaController _printNotaController = Get.put(
    PrintNotaController(),
  );
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoading = false.obs;
  var numberOfItems = 1.obs;
  var subTotal = 0.obs;
  var totalAllQuantity = 0.obs;
  var paymentMethod = 'cash'.obs;
  TextEditingController discountController = TextEditingController();
  var totalBayar = 0.obs;
  TextEditingController bayarTunai = TextEditingController();
  var isButtonDisabled = true.obs;

  void incrementProductQuantity(ProductModel dataProduct) {
    if (cartList
        .where((element) => element.idProduct == dataProduct.idProduct)
        .isNotEmpty) {
      var index = cartList.indexWhere(
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
    totalAllQuantity++;
    subTotal.value += dataProduct.price!;
    buttonCheckhoutDisable();
    update();
  }

  void decrementProductQuantity(ProductModel dataProduct) {
    var index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );
    if (index >= 0) {
      if (cartList[index].quantity > 0) {
        cartList[index].quantity--;
        totalAllQuantity--;
        subTotal.value -= dataProduct.price!;
      } else {
        cartList.removeAt(index);
      }
    }
    buttonCheckhoutDisable();
    update();
  }

  void removeProduct(ProductModel dataProduct) {
    var index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );
    if (index >= 0) {
      totalAllQuantity -= cartList[index].quantity;
      subTotal.value -= dataProduct.price! * cartList[index].quantity;
      cartList.removeAt(index);
    }
    buttonCheckhoutDisable();
    applyDiscount();
  }

  getProductQuantity(ProductModel dataProduct) {
    var index = cartList.indexWhere(
      (element) => element.idProduct == dataProduct.idProduct,
    );
    if (index >= 0) {
      return cartList[index].quantity;
    } else {
      return 0;
    }
  }

  void buttonCheckhoutDisable() {
    isButtonDisabled.value = cartList.isEmpty;
  }

  void applyDiscount() {
    int calculatedDiscount =
        discountController.text.isEmpty
            ? 0
            : int.parse(
              discountController.text.replaceAll(RegExp(r'[^0-9\-]'), ''),
            );
    if (calculatedDiscount > subTotal.value) {
      calculatedDiscount = subTotal.value;
    }
    totalBayar.value = subTotal.value - calculatedDiscount;
    update();
  }

  void saveCart() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var kios = prefs.getInt('id_kios');
      var cabang = prefs.getInt('id_cabang');
      var kasir = prefs.getInt('id_kasir');
      int calculatedDiscount =
          discountController.text.isEmpty
              ? 0
              : int.parse(
                discountController.text.replaceAll(RegExp(r'[^0-9\-]'), ''),
              );
      var dataDetailTransaction =
          cartList.map((cartItem) {
            return {
              'id_product': cartItem.idProduct,
              'product_name': cartItem.productModel.productName.toString(),
              'quantity': cartItem.quantity,
              'unit_price': cartItem.productModel.price,
            };
          }).toList();
      var dataTransaction = {
        'id_kios': kios,
        'id_cabang': cabang,
        'id_kasir': kasir,
        'sub_total': subTotal.value,
        'discount': calculatedDiscount,
        'total_bayar': totalBayar.value,
      };
      var resultSave = await RemoteDataSource.saveTransaction(
        dataTransaction,
        dataDetailTransaction,
      );
      if (resultSave) {
        // NOTIF SAVE SUCCESS
        Get.snackbar(
          'Notification',
          'Data saved successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
        // PRINT TRANSACTION
        _printNotaController.printTransaction(prefs.getInt('transaction_id')!);
        // CLEAR TRANSACTION
        clearCart();
        update();
        Get.toNamed(RouterClass.product);
      }
    } catch (e) {
      Get.snackbar(
        'Notification',
        'Failed to save transaction: ${e.toString()}',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

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
}
