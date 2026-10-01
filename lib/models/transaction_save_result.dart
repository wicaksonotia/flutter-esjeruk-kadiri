class TransactionSaveResult {
  final bool success;
  final int? transactionId;
  final int? numerator;
  final bool duplicate;
  final String? message;

  const TransactionSaveResult({
    required this.success,
    this.transactionId,
    this.numerator,
    this.duplicate = false,
    this.message,
  });

  factory TransactionSaveResult.fromJson(Map<String, dynamic> json) {
    return TransactionSaveResult(
      success: json['status']?.toString() == 'ok',
      transactionId: _toInt(json['transaction_id']),
      numerator: _toInt(json['numerator']),
      duplicate: json['duplicate'] == true,
      message: json['message']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }
}
