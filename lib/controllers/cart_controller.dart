import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/models/cart_model.dart';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:esjerukkadiri/networks/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
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
        var payload = cartList.map((cartItem) {
          return {
            'id_product': cartItem.idProduct,
            'product_name': cartItem.productModel.productName.toString(),
            'quantity': cartItem.quantity,
            'unit_price': cartItem.productModel.price,
            'kios': prefs.getString('username'),
          };
        }).toList();
        var resultSave = await RemoteDataSource.saveTransaction(payload);
        if (resultSave) {
          // NOTIF SAVE SUCCESS
          Get.snackbar('Notification', 'Data saved successfully',
              icon: const Icon(Icons.check),
              snackPosition: SnackPosition.BOTTOM);

          bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
          if (connectionStatus) {
            List<int> nota = await printPurchaseOrder();
            var resultPrint = await PrintBluetoothThermal.writeBytes(nota);
            if (!resultPrint) {
              Get.snackbar('Notification', 'Failed to print',
                  icon: const Icon(Icons.error),
                  snackPosition: SnackPosition.BOTTOM);
            }
          } else {
            Get.snackbar('Notification', 'Bluetooth not connected',
                icon: const Icon(Icons.error),
                snackPosition: SnackPosition.BOTTOM);
          }
          // CLEAR TRANSACTION
          cartList.clear();
          totalAllQuantity = 0.obs;
          totalPrice.value = 0;
          update();
        }
      } else {
        Get.snackbar('Notification', 'Your cart is empty',
            icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
          'Notification', 'Failed to save transaction: ${e.toString()}',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
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

  Future<List<int>> printPurchaseOrder() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    // IMAGE
    final ByteData data = await rootBundle.load('assets/images/logo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    final image = decodeImage(bytesImg);
    final resizedImage = copyResize(image!, width: 300);
    bytes += generator.image(resizedImage);

    bytes += generator.text(
        'Dsn. Sumbertugu RT 07 RW 04 \nDepan Musholla Sumbertugu',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Kec. Gampengrejo, Kab. Kediri',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Telp. 085755124535',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);

    // CART LIST
    for (var cartItem in cartList) {
      bytes += generator.row([
        PosColumn(
          text: cartItem.productModel.productName ?? 'Unknown Product',
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: cartItem.quantity.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: (CurrencyFormat.convertToIdr(
                  cartItem.productModel.price! * cartItem.quantity, 0))
              .toString(),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: (CurrencyFormat.convertToIdr(totalPrice.value, 0)).toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('https://www.instagram.com/esjeruk.kadiri/');
    bytes += generator.text(
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.feed(1);

    // IMAGE
    final ByteData _dataHastag =
        await rootBundle.load('assets/images/hastag.jpg');
    final Uint8List _bytesImgHastag = _dataHastag.buffer.asUint8List();
    final _imageHastag = decodeImage(_bytesImgHastag);
    final _resizedImageHastag = copyResize(_imageHastag!, width: 300);
    bytes += generator.image(_resizedImageHastag);

    bytes += generator.feed(2);
    // bytes += generator.cut();
    return bytes;
  }
}
