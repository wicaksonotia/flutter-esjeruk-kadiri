import 'package:drift/drift.dart';

class Transactions extends Table {
  /// Primary key lokal SQLite
  IntColumn get id => integer().autoIncrement()();

  /// UUID transaksi dari device.
  /// Dipakai sebagai idempotency key ketika sync ke server.
  TextColumn get localUuid => text().named('local_uuid').unique()();

  /// ID transaksi dari server setelah berhasil sync.
  IntColumn get serverTransactionId =>
      integer().named('server_transaction_id').nullable()();

  /// ID kios / brand
  IntColumn get idKios => integer().named('id_kios')();

  /// ID cabang / outlet
  IntColumn get idCabang => integer().named('id_cabang')();

  /// ID kasir
  IntColumn get idKasir => integer().named('id_kasir')();

  /// Kode outlet, contoh:
  /// BGSN
  /// STG
  /// NMBN
  TextColumn get branchCode =>
      text().named('branch_code').withDefault(const Constant(''))();

  /// Nomor transaksi lokal sebelum mendapatkan
  /// nomor resmi dari server.
  ///
  /// Contoh:
  /// LOCAL-0001
  /// LOCAL-0002
  IntColumn get localNumber => integer().named('local_number').nullable()();

  /// Nomor transaksi resmi dari server.
  ///
  /// Contoh:
  /// 5644
  /// 5645
  IntColumn get numerator => integer().named('numerator').nullable()();

  /// Sub total transaksi
  IntColumn get subTotal =>
      integer().named('sub_total').withDefault(const Constant(0))();

  /// Diskon
  IntColumn get discount =>
      integer().named('discount').withDefault(const Constant(0))();

  /// Total pembayaran
  IntColumn get totalBayar =>
      integer().named('total_bayar').withDefault(const Constant(0))();

  /// Total quantity item
  IntColumn get totalQuantity =>
      integer().named('total_quantity').withDefault(const Constant(0))();

  /// Metode pembayaran
  TextColumn get paymentMethod => text().named('payment_method')();

  /// Tanggal transaksi
  DateTimeColumn get transactionDate => dateTime().named('transaction_date')();

  /// Status sinkronisasi
  ///
  /// PENDING
  /// SYNCED
  TextColumn get syncStatus => text().named('sync_status')();

  /// Status pembatalan
  BoolColumn get isCancelled =>
      boolean().named('is_cancelled').withDefault(const Constant(false))();

  /// Alasan pembatalan
  TextColumn get cancelReason => text().named('cancel_reason').nullable()();

  /// Waktu dibuat di device
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  /// Waktu berhasil sync
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  /// Waktu terakhir berubah
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
}
