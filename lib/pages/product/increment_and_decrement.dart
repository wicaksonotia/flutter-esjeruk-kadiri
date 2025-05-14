import 'package:esjerukkadiri/commons/containers/box_container.dart';
import 'package:esjerukkadiri/controllers/cart_controller.dart';
import 'package:esjerukkadiri/models/product_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IncrementAndDecrement extends StatefulWidget {
  const IncrementAndDecrement({
    super.key,
    required this.dataProduct,
  });

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
        width: MediaQuery.of(context).size.width * 0.3,
        radius: 5,
        showBorder: true,
        borderColor: Colors.grey.shade200,
        shadow: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 20.0, // desired size
              onPressed: () {
                cartController.decrementProductQuantity(widget.dataProduct);
                setState(() {
                  quantity--;
                  if (quantity < 1) {
                    cartController.removeProduct(widget.dataProduct);
                  }
                });
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Center(
                child: Text(
                  '${cartController.getProductQuantity(widget.dataProduct)}',
                  textAlign: TextAlign.left,
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
              iconSize: 20.0, // desired size
              onPressed: () {
                cartController.incrementProductQuantity(widget.dataProduct);
                setState(() {
                  quantity++;
                });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
