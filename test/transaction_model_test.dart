import 'package:cashier/models/transaction_history_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TransactionModel defaults null API values to safe runtime values', () {
    final model = TransactionModel.fromJson({
      'id': 1,
      'numerator': 12,
      'transaction_date': '2026-09-11T10:00:00',
      'id_kios': 1,
      'id_kasir': 2,
      'sub_total': 100000,
      'discount': 0,
      'grand_total': 100000,
      'order_type': 'cash',
      'delete_status': null,
      'delete_reason': null,
      'id_cabang': 1,
      'payment_method': 'Cash',
      'total_item': 2,
      'nama_kasir': 'Alice',
      'kode_cabang': 'A1',
      'details': null,
    });

    expect(model.deleteStatus, isFalse);
    expect(model.details, isEmpty);
  });
}
