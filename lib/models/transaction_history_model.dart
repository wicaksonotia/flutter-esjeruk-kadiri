class TransactionHistoryModel {
  String? status;
  String? message;
  int? totalCup;
  List<TransactionModel>? data;

  TransactionHistoryModel({
    this.status,
    this.message,
    this.totalCup,
    this.data,
  });

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalCup = json['total_cup'];
    if (json['data'] != null) {
      data = <TransactionModel>[];
      json['data'].forEach((v) {
        data!.add(TransactionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_cup'] = totalCup;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionModel {
  int? id;
  int? numerator;
  String? transactionDate;
  int? idKios;
  int? idKasir;
  int? subTotal;
  int? discount;
  int? grandTotal;
  String? orderType;
  bool? deleteStatus;
  String? deleteReason;
  int? idCabang;
  String? paymentMethod;
  List<ListDetailTransactionModel>? details;

  TransactionModel({
    this.id,
    this.numerator,
    this.transactionDate,
    this.idKios,
    this.idKasir,
    this.subTotal,
    this.discount,
    this.grandTotal,
    this.orderType,
    this.deleteStatus,
    this.deleteReason,
    this.idCabang,
    this.paymentMethod,
    this.details,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numerator = json['numerator'];
    transactionDate = json['transaction_date'];
    idKios = json['id_kios'];
    idKasir = json['id_kasir'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    grandTotal = json['grand_total'];
    orderType = json['order_type'];
    deleteStatus = json['delete_status'];
    deleteReason = json['delete_reason'];
    idCabang = json['id_cabang'];
    paymentMethod = json['payment_method'];
    if (json['details'] != null) {
      details = <ListDetailTransactionModel>[];
      json['details'].forEach((v) {
        details!.add(ListDetailTransactionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numerator'] = numerator;
    data['transaction_date'] = transactionDate;
    data['id_kios'] = idKios;
    data['id_kasir'] = idKasir;
    data['sub_total'] = subTotal;
    data['discount'] = discount;
    data['grand_total'] = grandTotal;
    data['order_type'] = orderType;
    data['delete_status'] = deleteStatus;
    data['delete_reason'] = deleteReason;
    data['id_cabang'] = idCabang;
    data['payment_method'] = paymentMethod;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDetailTransactionModel {
  String? productName;
  int? quantity;
  int? unitPrice;
  int? totalPrice;

  ListDetailTransactionModel({
    this.productName,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  ListDetailTransactionModel.fromJson(Map<String, dynamic> json) {
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
