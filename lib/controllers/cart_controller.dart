import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final PrintNotaController _printNotaController =
      Get.put(PrintNotaController());
  List<CartModel> cartList = <CartModel>[].obs;
  var isLoading = false.obs;
  var numberOfItems = 1.obs;
  var totalPrice = 0.obs;
  var totalAllQuantity = 0.obs;

  void incrementProductQuantity(ProductModel dataProduct) {
    if (cartList
        .where((element) => element.idProduct == dataProduct.idProduct)
        .isNotEmpty) {
      var index = cartList
          .indexWhere((element) => element.idProduct == dataProduct.idProduct);
      cartList[index].quantity++;
      // print("totalQuantity: ${cartList[index].quantity}");
    } else {
      cartList.add(CartModel(
        productModel: dataProduct,
        idProduct: dataProduct.idProduct!,
        quantity: 1,
      ));
      // print("totalQuantity: ${cartList.last.quantity}");
    }
    totalAllQuantity++;
    totalPrice.value += dataProduct.price!;
    update();
  }

  void decrementProductQuantity(ProductModel dataProduct) {
    var index = cartList
        .indexWhere((element) => element.idProduct == dataProduct.idProduct);
    if (index >= 0) {
      if (cartList[index].quantity > 0) {
        cartList[index].quantity--;
        totalAllQuantity--;
        totalPrice.value -= dataProduct.price!;
        // print("totalQuantity: ${cartList[index].quantity}");
      } else {
        cartList.removeAt(index);
      }
    }

    update();
  }

  void removeProduct(ProductModel dataProduct) {
    var index = cartList
        .indexWhere((element) => element.idProduct == dataProduct.idProduct);
    if (index >= 0) {
      totalAllQuantity -= cartList[index].quantity;
      totalPrice.value -= dataProduct.price! * cartList[index].quantity;
      cartList.removeAt(index);
    }
    update();
  }

  getProductQuantity(ProductModel dataProduct) {
    var index = cartList
        .indexWhere((element) => element.idProduct == dataProduct.idProduct);
    if (index >= 0) {
      return cartList[index].quantity;
    } else {
      return 0;
    }
  }

  void saveCart() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (cartList.isNotEmpty) {
        // Show dialog to input discount
        TextEditingController discountController = TextEditingController();
        int discount = 0;

        await Get.defaultDialog(
          title: "Enter Discount",
          content: Column(
            children: [
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          textConfirm: "Save",
          textCancel: "No",
          onConfirm: () {
            discount = discountController.text.isNotEmpty
                ? int.parse(discountController.text)
                : 0;
            Get.back();
          },
          onCancel: () {
            discount = 0;
            Get.back();
          },
        );

        var payload = cartList.map((cartItem) {
          return {
            'id_product': cartItem.idProduct,
            'product_name': cartItem.productModel.productName.toString(),
            'quantity': cartItem.quantity,
            'unit_price': cartItem.productModel.price,
            'kios': prefs.getString('username'),
          };
        }).toList();
        var resultSave = await RemoteDataSource.saveDetailTransaction(payload);
        if (resultSave) {
          await RemoteDataSource.saveTransaction(
            prefs.getString('username')!,
            discount,
          );
          // NOTIF SAVE SUCCESS
          Get.snackbar('Notification', 'Data saved successfully',
              icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
          // PRINT TRANSACTION
          _printNotaController.printTransaction(
            int.parse(prefs.getString('numerator')!),
            prefs.getString('username')!,
          );
          // CLEAR TRANSACTION
          cartList.clear();
          totalAllQuantity = 0.obs;
          totalPrice.value = 0;
          update();
        }
      } else {
        Get.snackbar('Notification', 'Your cart is empty',
            icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar(
          'Notification', 'Failed to save transaction: ${e.toString()}',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void clearCart() {
    cartList.clear();
    totalAllQuantity = 0.obs;
    totalPrice.value = 0;
    update();
  }
}
