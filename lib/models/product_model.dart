class ProductModel {
  int? idProduct;
  int? idCategory;
  String? productName;
  String? description;
  int? price;
  String? photo1;
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
    photo1 = json['photo_1'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id_product': idProduct,
      'id_categories': idCategory,
      'product_name': productName,
      'description': description,
      'price': price,
      'photo_1': photo1,
      'favorite': favorite,
    };
  }
}
