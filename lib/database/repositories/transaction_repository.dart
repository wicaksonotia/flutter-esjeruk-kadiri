import 'package:cashier/database/app_database.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class TransactionRepository {
  final AppDatabase _db = Get.find<AppDatabase>();

  // ============================================================
  // GET NEXT LOCAL NUMBER
  // ============================================================

  /// Mengambil nomor transaksi lokal berikutnya untuk outlet tertentu.
  ///
  /// Contoh:
  /// BGSN / transaksi terakhir LOCAL-0007
  /// maka transaksi berikutnya = 8
  ///
  /// Nomor ini hanya untuk transaksi yang belum mendapatkan
  /// nomor resmi dari server.
  Future<int> getNextLocalNumber({
    required int idKios,
    required int idCabang,
  }) async {
    final maxLocalNumber = _db.transactions.localNumber.max();

    final query =
        _db.selectOnly(_db.transactions)
          ..addColumns([maxLocalNumber])
          ..where(
            _db.transactions.idKios.equals(idKios) &
                _db.transactions.idCabang.equals(idCabang),
          );

    final row = await query.getSingle();

    final lastNumber = row.read(maxLocalNumber);

    return (lastNumber ?? 0) + 1;
  }

  // ============================================================
  // SAVE LOCAL TRANSACTION
  // ============================================================

  /// Simpan transaksi + detail secara atomic.
  ///
  /// Alur:
  ///
  /// localNumber dibuat di sini
  /// ↓
  /// transaction header disimpan
  /// ↓
  /// transaction detail disimpan
  ///
  /// Kalau salah satu insert gagal, seluruh transaksi dibatalkan.
  Future<int> saveLocalTransaction({
    required String localUuid,
    required int idKios,
    required int idCabang,
    required int idKasir,
    required String branchCode,
    required int subTotal,
    required int discount,
    required int totalBayar,
    required int totalQuantity,
    required String paymentMethod,
    required DateTime transactionDate,
    required List<TransactionDetailData> details,
  }) async {
    final localNumber = await getNextLocalNumber(
      idKios: idKios,
      idCabang: idCabang,
    );

    await _db.transaction(() async {
      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              localUuid: localUuid,

              serverTransactionId: const drift.Value(null),

              idKios: idKios,

              idCabang: idCabang,

              idKasir: idKasir,

              branchCode: drift.Value(branchCode),

              localNumber: drift.Value(localNumber),

              numerator: const drift.Value(null),

              subTotal: drift.Value(subTotal),

              discount: drift.Value(discount),

              totalBayar: drift.Value(totalBayar),

              totalQuantity: drift.Value(totalQuantity),

              paymentMethod: paymentMethod,

              transactionDate: transactionDate,

              syncStatus: 'PENDING',

              isCancelled: const drift.Value(false),

              cancelReason: const drift.Value(null),

              createdAt: transactionDate,

              syncedAt: const drift.Value(null),

              updatedAt: transactionDate,
            ),
          );

      for (final detail in details) {
        await _db
            .into(_db.transactionDetails)
            .insert(
              TransactionDetailsCompanion.insert(
                transactionLocalUuid: localUuid,

                idProduct: detail.idProduct,

                productName: detail.productName,

                quantity: detail.quantity,

                unitPrice: detail.unitPrice,

                subtotal: drift.Value(detail.quantity * detail.unitPrice),

                createdAt: transactionDate,
              ),
            );
      }
    });

    return localNumber;
  }

  // ============================================================
  // SYNC STATUS
  // ============================================================

  Future<void> markAsSynced({
    required String localUuid,
    required int serverTransactionId,
    int? numerator,
  }) async {
    final now = DateTime.now();

    await (_db.update(_db.transactions)
      ..where((tbl) => tbl.localUuid.equals(localUuid))).write(
      TransactionsCompanion(
        serverTransactionId: drift.Value(serverTransactionId),

        numerator: drift.Value(numerator),

        syncStatus: const drift.Value('SYNCED'),

        syncedAt: drift.Value(now),

        updatedAt: drift.Value(now),
      ),
    );
  }

  Future<void> markAsPending({required String localUuid}) async {
    await (_db.update(_db.transactions)
      ..where((tbl) => tbl.localUuid.equals(localUuid))).write(
      TransactionsCompanion(
        syncStatus: const drift.Value('PENDING'),

        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  // ============================================================
  // GET SINGLE TRANSACTION
  // ============================================================

  Future<Transaction?> getByLocalUuid(String localUuid) async {
    return (_db.select(_db.transactions)
      ..where((tbl) => tbl.localUuid.equals(localUuid))).getSingleOrNull();
  }

  // ============================================================
  // PENDING
  // ============================================================

  Future<List<Transaction>> getPendingTransactions() async {
    return (_db.select(_db.transactions)
          ..where((tbl) => tbl.syncStatus.equals('PENDING'))
          ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<int> getPendingCount() async {
    final countExpression = _db.transactions.id.count();

    final query =
        _db.selectOnly(_db.transactions)
          ..addColumns([countExpression])
          ..where(_db.transactions.syncStatus.equals('PENDING'));

    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }

  // ============================================================
  // DETAILS
  // ============================================================

  Future<List<TransactionDetail>> getDetailsByLocalUuid(
    String localUuid,
  ) async {
    return (_db.select(_db.transactionDetails)
          ..where((tbl) => tbl.transactionLocalUuid.equals(localUuid))
          ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.id)]))
        .get();
  }

  // ============================================================
  // DAILY HISTORY
  // ============================================================

  Future<List<Transaction>> getDailyTransactions({
    required int idKios,
    required int idCabang,
    required int idKasir,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();

    final start = DateTime(targetDate.year, targetDate.month, targetDate.day);

    final end = start.add(const Duration(days: 1));

    return (_db.select(_db.transactions)
          ..where(
            (tbl) =>
                tbl.idKios.equals(idKios) &
                tbl.idCabang.equals(idCabang) &
                tbl.idKasir.equals(idKasir) &
                tbl.transactionDate.isBiggerOrEqualValue(start) &
                tbl.transactionDate.isSmallerThanValue(end),
          )
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.transactionDate)]))
        .get();
  }

  // ============================================================
  // MONTH HISTORY
  // ============================================================

  Future<List<Transaction>> getTransactionsByMonth({
    required int idKios,
    required int idCabang,
    required int idKasir,
    required int month,
    required int year,
  }) async {
    final start = DateTime(year, month, 1);

    final end = DateTime(year, month + 1, 1);

    return (_db.select(_db.transactions)
          ..where(
            (tbl) =>
                tbl.idKios.equals(idKios) &
                tbl.idCabang.equals(idCabang) &
                tbl.idKasir.equals(idKasir) &
                tbl.transactionDate.isBiggerOrEqualValue(start) &
                tbl.transactionDate.isSmallerThanValue(end),
          )
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.transactionDate)]))
        .get();
  }

  // ============================================================
  // DATE RANGE HISTORY
  // ============================================================

  Future<List<Transaction>> getTransactionsByDateRange({
    required int idKios,
    required int idCabang,
    required int idKasir,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    return (_db.select(_db.transactions)
          ..where(
            (tbl) =>
                tbl.idKios.equals(idKios) &
                tbl.idCabang.equals(idCabang) &
                tbl.idKasir.equals(idKasir) &
                tbl.transactionDate.isBiggerOrEqualValue(start) &
                tbl.transactionDate.isSmallerThanValue(end),
          )
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.transactionDate)]))
        .get();
  }

  // ============================================================
  // CONVERT LOCAL DATA → UI MODEL
  // ============================================================

  Future<TransactionModel> toTransactionModel(
    Transaction transaction, {
    String? cashierName,
    String? branchCode,
  }) async {
    final details = await getDetailsByLocalUuid(transaction.localUuid);

    return TransactionModel(
      id: transaction.serverTransactionId,

      numerator: transaction.numerator,

      transactionDate: transaction.transactionDate.toIso8601String(),

      idKios: transaction.idKios,

      idKasir: transaction.idKasir,

      subTotal: transaction.subTotal,

      discount: transaction.discount,

      grandTotal: transaction.totalBayar,

      orderType: null,

      deleteStatus: transaction.isCancelled,

      deleteReason: transaction.cancelReason ?? '',

      idCabang: transaction.idCabang,

      paymentMethod: transaction.paymentMethod,

      totalItem: transaction.totalQuantity,

      cashierName: cashierName ?? 'Unknown Cashier',

      branchCode:
          transaction.branchCode.isNotEmpty
              ? transaction.branchCode
              : branchCode,

      details:
          details.map((detail) {
            return ListDetailTransactionModel(
              productName: detail.productName,

              quantity: detail.quantity,

              unitPrice: detail.unitPrice,

              totalPrice: detail.subtotal,
            );
          }).toList(),
    );
  }

  // ============================================================
  // CONVERT LIST
  // ============================================================

  Future<List<TransactionModel>> toTransactionModels(
    List<Transaction> transactions, {
    String? cashierName,
    String? branchCode,
  }) async {
    final result = <TransactionModel>[];

    for (final transaction in transactions) {
      result.add(
        await toTransactionModel(
          transaction,
          cashierName: cashierName,
          branchCode: branchCode,
        ),
      );
    }

    return result;
  }

  // ============================================================
  // CANCEL LOCAL TRANSACTION
  // ============================================================

  Future<void> cancelLocalTransaction({
    required String localUuid,
    required String reason,
  }) async {
    await (_db.update(_db.transactions)
      ..where((tbl) => tbl.localUuid.equals(localUuid))).write(
      TransactionsCompanion(
        isCancelled: const drift.Value(true),

        cancelReason: drift.Value(reason),

        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }
}

// ============================================================
// TRANSACTION DETAIL DATA
// ============================================================

class TransactionDetailData {
  final int idProduct;
  final String productName;
  final int quantity;
  final int unitPrice;

  const TransactionDetailData({
    required this.idProduct,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}
