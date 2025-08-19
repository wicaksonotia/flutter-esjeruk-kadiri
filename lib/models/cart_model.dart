// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cashier/models/product_model.dart';

class CartModel {
  final ProductModel productModel;
  final int idProduct;
  int quantity;
  CartModel({
    required this.productModel,
    required this.idProduct,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productModel': productModel,
      'idProduct': idProduct,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productModel: ProductModel.fromJson(
        map['productModel'] as Map<String, dynamic>,
      ),
      idProduct: map['idProduct'] as int,
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
