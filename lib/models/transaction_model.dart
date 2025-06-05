class TransactionModel {
  String? status;
  String? message;
  int? income;
  List<Data>? data;

  TransactionModel({this.status, this.message, this.income, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    income = json['income'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['income'] = income;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? numerator;
  String? transactionDate;
  String? kios;
  int? grandTotal;
  bool? deleteStatus;
  int? discount;
  int? total;
  List<TransactionListDetails>? details;

  Data(
      {this.id,
      this.numerator,
      this.transactionDate,
      this.kios,
      this.grandTotal,
      this.deleteStatus,
      this.discount,
      this.total,
      this.details});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numerator = json['numerator'];
    transactionDate = json['transaction_date'];
    kios = json['kios'];
    grandTotal = json['grand_total'];
    deleteStatus = json['delete_status'];
    discount = json['discount'];
    total = json['total'];
    if (json['details'] != null) {
      details = <TransactionListDetails>[];
      json['details'].forEach((v) {
        details!.add(TransactionListDetails.fromJson(v));
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
    data['discount'] = discount;
    data['total'] = total;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionListDetails {
  String? productName;
  int? quantity;
  int? unitPrice;
  int? totalPrice;

  TransactionListDetails(
      {this.productName, this.quantity, this.unitPrice, this.totalPrice});

  TransactionListDetails.fromJson(Map<String, dynamic> json) {
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
