class ProductCategoryModel {
  int? categoryId;
  String? categoryName;

  ProductCategoryModel({this.categoryId, this.categoryName});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    return data;
  }
}
