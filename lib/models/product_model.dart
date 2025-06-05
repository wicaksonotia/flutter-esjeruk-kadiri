import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  int? idProduct;
  String? productName;
  String? categoriesName;
  String? description;
  int? price;
  Uint8List? photo1;
  bool promo = false;

  ProductModel(
      {this.idProduct,
      this.productName,
      this.categoriesName,
      this.description,
      this.price,
      this.photo1,
      this.promo = false});

  ProductModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    productName = json['product_name'];
    categoriesName = json['categories_name'];
    description = json['description'];
    price = json['price'];
    Uint8List decodePhoto;
    decodePhoto = const Base64Decoder().convert('${json['photo_1']}');
    photo1 = decodePhoto;
    promo = json['promo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_product'] = idProduct;
    data['product_name'] = productName;
    data['categories_name'] = categoriesName;
    data['description'] = description;
    data['price'] = price;
    data['photo_1'] = photo1;
    data['promo'] = promo;
    return data;
  }
}
