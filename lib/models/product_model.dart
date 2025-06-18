import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  int? idProduct;
  int? idCategory;
  String? productName;
  String? description;
  int? price;
  Uint8List? photo1;
  bool? favorite;

  ProductModel({
    this.idProduct,
    this.idCategory,
    this.productName,
    this.description,
    this.price,
    this.photo1,
    this.favorite,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    idCategory = json['id_categories'];
    productName = json['product_name'];
    description = json['description'];
    price = json['price'];
    Uint8List decodePhoto;
    decodePhoto = const Base64Decoder().convert('${json['photo_1']}');
    photo1 = decodePhoto;
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_product'] = idProduct;
    data['id_categories'] = idCategory;
    data['product_name'] = productName;
    data['description'] = description;
    data['price'] = price;
    data['photo_1'] = photo1;
    data['favorite'] = favorite;
    return data;
  }
}
