import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/controllers/print_nota_controller.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    if (index > 0) {
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

  void showBottomSheet() async {
    TextEditingController discountController = TextEditingController();
    int discount = 0;
    if (cartList.isNotEmpty) {
      await Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Discount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              TextField(
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'id',
                    decimalDigits: 0,
                    symbol: 'Rp.',
                  )
                ],
                keyboardType: TextInputType.number,
                controller: discountController,
                decoration: const InputDecoration(
                  labelText: "Discount",
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(Get.context!).size.width * .45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: MyColors.primary),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: MyColors.primary),
                      ),
                    ),
                  ),
                  const Gap(5),
                  SizedBox(
                    width: MediaQuery.of(Get.context!).size.width * .45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        discount = discountController.text.isNotEmpty
                            ? int.parse(discountController.text
                                .replaceAll(RegExp('[^0-9]'), ''))
                            : 0;
                        saveCart(discount);
                        Get.back();
                      },
                      child: const Text(
                        'Proccess',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      Get.snackbar('Notification', 'Your cart is empty',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      return;
    }
  }

  void saveCart(discount) async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
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
