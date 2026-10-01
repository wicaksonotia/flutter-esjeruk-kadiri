import 'package:drift/drift.dart';

class TransactionDetails extends Table {
  // ==========================================================
  // LOCAL PRIMARY KEY
  // ==========================================================

  IntColumn get id => integer().autoIncrement()();

  // ==========================================================
  // RELATION KE TRANSAKSI
  //
  // Menggunakan localUuid, bukan server ID.
  // Karena transaksi bisa belum mempunyai server ID.
  // ==========================================================

  TextColumn get transactionLocalUuid =>
      text().named('transaction_local_uuid')();

  // ==========================================================
  // PRODUCT
  // ==========================================================

  IntColumn get idProduct => integer().named('id_product')();

  // ==========================================================
  // SNAPSHOT PRODUK
  //
  // Jangan mengambil nama/harga dari master product ketika
  // menampilkan transaksi lama.
  // ==========================================================

  TextColumn get productName => text().named('product_name')();

  IntColumn get quantity => integer().named('quantity')();

  IntColumn get unitPrice => integer().named('unit_price')();

  IntColumn get subtotal =>
      integer().named('subtotal').withDefault(const Constant(0))();

  // ==========================================================
  // CREATED
  // ==========================================================

  DateTimeColumn get createdAt => dateTime().named('created_at')();
}
