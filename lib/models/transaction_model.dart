class TransactionModel {
  int? id;
  int? numerator;
  String? transactionDate;
  String? kios;
  int? grandTotal;
  bool deleteStatus = false;

  TransactionModel(
      {this.id,
      this.numerator,
      this.transactionDate,
      this.kios,
      this.grandTotal,
      required this.deleteStatus});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numerator = json['numerator'];
    transactionDate = json['transaction_date'];
    kios = json['kios'];
    grandTotal = json['grand_total'];
    deleteStatus = json['delete_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numerator'] = numerator;
    data['transaction_date'] = transactionDate;
    data['kios'] = kios;
    data['grand_total'] = grandTotal;
    data['delete_status'] = deleteStatus;
    return data;
  }
}
