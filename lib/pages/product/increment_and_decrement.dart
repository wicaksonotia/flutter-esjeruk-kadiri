import 'package:cashier/commons/containers/box_container.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IncrementAndDecrement extends StatefulWidget {
  const IncrementAndDecrement({super.key, required this.dataProduct});

  final ProductModel dataProduct;

  @override
  _IncrementAndDecrementState createState() => _IncrementAndDecrementState();
}

class _IncrementAndDecrementState extends State<IncrementAndDecrement> {
  final CartController cartController = Get.find<CartController>();
  var quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BoxContainer(
        height: 35,
        radius: 5,
        showBorder: true,
        borderColor: Colors.grey.shade200,
        shadow: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 20,
              onPressed: () {
                cartController.decrementProductQuantity(widget.dataProduct);
                setState(() {
                  quantity--;
                  if (quantity < 1) {
                    cartController.removeProduct(widget.dataProduct);
                  }
                });
              },
              icon: const Icon(Icons.remove, color: Colors.black),
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  '${cartController.getProductQuantity(widget.dataProduct)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 20,
              onPressed: () {
                cartController.incrementProductQuantity(widget.dataProduct);
                setState(() {
                  quantity++;
                });
              },
              icon: const Icon(Icons.add, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
