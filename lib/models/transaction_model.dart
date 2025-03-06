class TransactionModel {
  int? id;
  int? numerator;
  String? transactionDate;
  String? kios;
  int? grandTotal;
  bool? deleteStatus;
  List<Details>? details;

  TransactionModel(
      {this.id,
      this.numerator,
      this.transactionDate,
      this.kios,
      this.grandTotal,
      this.deleteStatus,
      this.details});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numerator = json['numerator'];
    transactionDate = json['transaction_date'];
    kios = json['kios'];
    grandTotal = json['grand_total'];
    deleteStatus = json['delete_status'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numerator'] = numerator;
    data['transaction_date'] = transactionDate;
    data['kios'] = kios;
    data['grand_total'] = grandTotal;
    data['delete_status'] = deleteStatus;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? productName;
  int? quantity;
  int? unitPrice;
  int? totalPrice;

  Details({this.productName, this.quantity, this.unitPrice, this.totalPrice});

  Details.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['unit_price'] = unitPrice;
    data['total_price'] = totalPrice;
    return data;
  }
}
