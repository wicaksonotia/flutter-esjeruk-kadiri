import 'package:cashier/database/app_database.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TransactionRepository {
  final AppDatabase _db = Get.find<AppDatabase>();

  // ============================================================
  // GET NEXT LOCAL NUMBER
  // ============================================================

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

  Future<int> saveLocalTransaction({
    required String localUuid,
    required int idKios,
    required int idCabang,
    required int idKasir,
    required String cashierName,
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

              // ==================================================
              // CASHIER NAME
              // ==================================================
              cashierName: drift.Value(cashierName),

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

    debugPrint(
      'SAVE LOCAL TRANSACTION => '
      'uuid=$localUuid | '
      'kasir=$idKasir | '
      'nama=$cashierName | '
      'cabang=$idCabang | '
      'localNumber=$localNumber',
    );

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

  Future<Transaction?> getByServerTransactionId(int serverTransactionId) async {
    return (_db.select(_db.transactions)..where(
      (tbl) => tbl.serverTransactionId.equals(serverTransactionId),
    )).getSingleOrNull();
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
          ..orderBy([
            (tbl) => drift.OrderingTerm(
              expression: tbl.transactionDate,
              mode: drift.OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // ============================================================
  // MONTH HISTORY
  // ============================================================

  Future<List<Transaction>> getTransactionsByMonth({
    required int idKios,
    required int idCabang,
    required int month,
    required int year,
  }) async {
    final start = DateTime(year, month, 1);

    final end = DateTime(year, month + 1, 1);

    debugPrint(
      'DB MONTH QUERY => '
      'kios=$idKios, '
      'cabang=$idCabang, '
      'start=$start, '
      'end=$end',
    );

    final query =
        _db.select(_db.transactions)
          ..where((tbl) {
            final baseCondition =
                tbl.idKios.equals(idKios) &
                tbl.transactionDate.isBiggerOrEqualValue(start) &
                tbl.transactionDate.isSmallerThanValue(end);

            if (idCabang == 0) {
              return baseCondition;
            }

            return baseCondition & tbl.idCabang.equals(idCabang);
          })
          ..orderBy([
            (tbl) => drift.OrderingTerm(
              expression: tbl.transactionDate,
              mode: drift.OrderingMode.desc,
            ),
          ]);

    final result = await query.get();

    debugPrint('DB MONTH RESULT => ${result.length}');

    return result;
  }

  // ============================================================
  // DATE RANGE HISTORY
  // ============================================================

  Future<List<Transaction>> getTransactionsByDateRange({
    required int idKios,
    required int idCabang,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    debugPrint(
      'DB RANGE QUERY => '
      'kios=$idKios, '
      'cabang=$idCabang, '
      'start=$start, '
      'end=$end',
    );

    final query =
        _db.select(_db.transactions)
          ..where((tbl) {
            final baseCondition =
                tbl.idKios.equals(idKios) &
                tbl.transactionDate.isBiggerOrEqualValue(start) &
                tbl.transactionDate.isSmallerThanValue(end);

            if (idCabang == 0) {
              return baseCondition;
            }

            return baseCondition & tbl.idCabang.equals(idCabang);
          })
          ..orderBy([
            (tbl) => drift.OrderingTerm(
              expression: tbl.transactionDate,
              mode: drift.OrderingMode.desc,
            ),
          ]);

    final result = await query.get();

    debugPrint('DB RANGE RESULT => ${result.length}');

    return result;
  }

  // ============================================================
  // CONVERT LOCAL → MODEL
  // ============================================================

  Future<TransactionModel> toTransactionModel(
    Transaction transaction, {
    String? cashierName,
    String? branchCode,
  }) async {
    final details = await getDetailsByLocalUuid(transaction.localUuid);

    debugPrint(
      'TO MODEL => '
      'serverId=${transaction.serverTransactionId} | '
      'idKasir=${transaction.idKasir} | '
      'dbCashier="${transaction.cashierName}" | '
      'paramCashier="$cashierName"',
    );

    final localCashierName = transaction.cashierName.trim();

    final resolvedCashierName =
        localCashierName.isNotEmpty
            ? localCashierName
            : (cashierName?.trim().isNotEmpty == true
                ? cashierName!.trim()
                : 'Kasir #${transaction.idKasir}');

    debugPrint(
      'TO MODEL RESULT => '
      'serverId=${transaction.serverTransactionId} | '
      'cashier="$resolvedCashierName"',
    );

    return TransactionModel(
      id: transaction.serverTransactionId,
      numerator: transaction.numerator,
      transactionDate: transaction.transactionDate.toIso8601String(),
      idKios: transaction.idKios,
      idKasir: transaction.idKasir,
      cashierName: resolvedCashierName,
      subTotal: transaction.subTotal,
      discount: transaction.discount,
      grandTotal: transaction.totalBayar,
      orderType: null,
      deleteStatus: transaction.isCancelled,
      deleteReason: transaction.cancelReason ?? '',
      idCabang: transaction.idCabang,
      paymentMethod: transaction.paymentMethod,
      totalItem: transaction.totalQuantity,
      branchCode:
          transaction.branchCode.isNotEmpty
              ? transaction.branchCode
              : branchCode,
      details:
          details.map((detail) {
            return ListDetailTransactionModel(
              idProduct: detail.idProduct,
              productName: detail.productName,
              quantity: detail.quantity,
              unitPrice: detail.unitPrice,
              totalPrice: detail.subtotal,
            );
          }).toList(),
    );
  }

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
  // CANCEL
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

  // ============================================================
  // SAVE SERVER TRANSACTION
  // ============================================================

  Future<void> saveServerTransaction({
    required TransactionModel transaction,
  }) async {
    final serverId = transaction.id;

    if (serverId == null || serverId == 0) {
      debugPrint('PULL SKIP: transaction id kosong');
      return;
    }

    final transactionDate =
        DateTime.tryParse(transaction.transactionDate ?? '') ?? DateTime.now();

    final existing = await getByServerTransactionId(serverId);

    await _db.transaction(() async {
      // ========================================================
      // EXISTING TRANSACTION
      // ========================================================

      if (existing != null) {
        final resolvedCashierName =
            transaction.cashierName?.trim().isNotEmpty == true
                ? transaction.cashierName!.trim()
                : existing.cashierName;

        final resolvedBranchCode =
            transaction.branchCode?.trim().isNotEmpty == true
                ? transaction.branchCode!.trim()
                : existing.branchCode;

        await (_db.update(_db.transactions)
          ..where((tbl) => tbl.id.equals(existing.id))).write(
          TransactionsCompanion(
            serverTransactionId: drift.Value(serverId),

            idKios: drift.Value(transaction.idKios ?? existing.idKios),

            idCabang: drift.Value(transaction.idCabang ?? existing.idCabang),

            idKasir: drift.Value(transaction.idKasir ?? existing.idKasir),

            // ==================================================
            // CASHIER NAME
            // ==================================================
            cashierName: drift.Value(resolvedCashierName),

            branchCode: drift.Value(resolvedBranchCode),

            numerator: drift.Value(transaction.numerator),

            subTotal: drift.Value(transaction.subTotal ?? 0),

            discount: drift.Value(transaction.discount ?? 0),

            totalBayar: drift.Value(transaction.grandTotal ?? 0),

            totalQuantity: drift.Value(transaction.totalItem ?? 0),

            paymentMethod: drift.Value(transaction.paymentMethod ?? ''),

            transactionDate: drift.Value(transactionDate),

            syncStatus: const drift.Value('SYNCED'),

            isCancelled: drift.Value(transaction.deleteStatus ?? false),

            cancelReason: drift.Value(transaction.deleteReason),

            syncedAt: drift.Value(DateTime.now()),

            updatedAt: drift.Value(DateTime.now()),
          ),
        );

        await (_db.delete(_db.transactionDetails)..where(
          (tbl) => tbl.transactionLocalUuid.equals(existing.localUuid),
        )).go();

        await _insertServerTransactionDetails(
          localUuid: existing.localUuid,
          transaction: transaction,
          transactionDate: transactionDate,
        );

        debugPrint(
          'PULL UPDATE LOCAL '
          'serverId=$serverId | '
          'kasir=${transaction.idKasir} | '
          'nama=${transaction.cashierName}',
        );

        return;
      }

      // ========================================================
      // NEW SERVER TRANSACTION
      // ========================================================

      final localUuid = 'SERVER-$serverId';

      final resolvedCashierName = transaction.cashierName?.trim() ?? '';

      final resolvedBranchCode = transaction.branchCode?.trim() ?? '';

      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              localUuid: localUuid,

              serverTransactionId: drift.Value(serverId),

              idKios: transaction.idKios ?? 0,

              idCabang: transaction.idCabang ?? 0,

              idKasir: transaction.idKasir ?? 0,

              // ==================================================
              // CASHIER NAME
              // ==================================================
              cashierName: drift.Value(resolvedCashierName),

              branchCode: drift.Value(resolvedBranchCode),

              localNumber: const drift.Value(null),

              numerator: drift.Value(transaction.numerator),

              subTotal: drift.Value(transaction.subTotal ?? 0),

              discount: drift.Value(transaction.discount ?? 0),

              totalBayar: drift.Value(transaction.grandTotal ?? 0),

              totalQuantity: drift.Value(transaction.totalItem ?? 0),

              paymentMethod: transaction.paymentMethod ?? '',

              transactionDate: transactionDate,

              syncStatus: 'SYNCED',

              isCancelled: drift.Value(transaction.deleteStatus ?? false),

              cancelReason: drift.Value(transaction.deleteReason),

              createdAt: transactionDate,

              syncedAt: drift.Value(DateTime.now()),

              updatedAt: DateTime.now(),
            ),
          );

      await _insertServerTransactionDetails(
        localUuid: localUuid,
        transaction: transaction,
        transactionDate: transactionDate,
      );

      debugPrint(
        'PULL INSERT LOCAL '
        'serverId=$serverId | '
        'kios=${transaction.idKios} | '
        'cabang=${transaction.idCabang} | '
        'kasir=${transaction.idKasir} | '
        'nama=${transaction.cashierName}',
      );
    });
  }

  // ============================================================
  // INSERT SERVER DETAILS
  // ============================================================

  Future<void> _insertServerTransactionDetails({
    required String localUuid,
    required TransactionModel transaction,
    required DateTime transactionDate,
  }) async {
    final details = transaction.details ?? [];

    for (final detail in details) {
      await _db
          .into(_db.transactionDetails)
          .insert(
            TransactionDetailsCompanion.insert(
              transactionLocalUuid: localUuid,

              idProduct: detail.idProduct ?? 0,

              productName: detail.productName ?? '',

              quantity: detail.quantity ?? 0,

              unitPrice: detail.unitPrice ?? 0,

              subtotal: drift.Value(
                detail.totalPrice ??
                    ((detail.quantity ?? 0) * (detail.unitPrice ?? 0)),
              ),

              createdAt: transactionDate,
            ),
          );
    }
  }

  // ============================================================
  // PULL SERVER → SQLITE : MONTH
  // ============================================================

  Future<bool> syncTransactionsFromServerByMonth({
    required int idKios,
    required int idCabang,
    required int month,
    required int year,
  }) async {
    try {
      final monthYear = '${month.toString().padLeft(2, '0')}-$year';

      final rawFormat = {
        'id_kios': idKios,
        'id_cabang': idCabang,
        'monthYear': monthYear,
      };

      debugPrint('========================================');
      debugPrint('PULL TRANSACTION BY MONTH');
      debugPrint('REQUEST: $rawFormat');
      debugPrint('========================================');

      final result = await RemoteDataSource.transactionHistoryByMonth(
        rawFormat,
      );

      if (result == null) {
        debugPrint('PULL MONTH: response null');
        return false;
      }

      final serverTransactions = result.data ?? [];

      debugPrint(
        'PULL MONTH: '
        '${serverTransactions.length} transaksi',
      );

      for (final transaction in serverTransactions) {
        await saveServerTransaction(transaction: transaction);
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('PULL MONTH ERROR: $e');

      debugPrint('$stackTrace');

      return false;
    }
  }

  // ============================================================
  // PULL SERVER → SQLITE : RANGE
  // ============================================================

  Future<bool> syncTransactionsFromServerByDateRange({
    required int idKios,
    required int idCabang,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);

      final end = DateTime(endDate.year, endDate.month, endDate.day);

      final rawFormat = {
        'id_kios': idKios,
        'id_cabang': idCabang,
        'startDate':
            '${start.year.toString().padLeft(4, '0')}-'
            '${start.month.toString().padLeft(2, '0')}-'
            '${start.day.toString().padLeft(2, '0')} '
            '00:00:00',

        'endDate':
            '${end.year.toString().padLeft(4, '0')}-'
            '${end.month.toString().padLeft(2, '0')}-'
            '${end.day.toString().padLeft(2, '0')} '
            '23:59:59',
      };

      debugPrint('========================================');
      debugPrint('PULL TRANSACTION BY DATE RANGE');
      debugPrint('REQUEST: $rawFormat');
      debugPrint('========================================');

      final result = await RemoteDataSource.transactionHistoryByDateRange(
        rawFormat,
      );

      if (result == null) {
        debugPrint('PULL RANGE: response null');
        return false;
      }

      final serverTransactions = result.data ?? [];

      debugPrint(
        'PULL RANGE: '
        '${serverTransactions.length} transaksi',
      );

      for (final transaction in serverTransactions) {
        await saveServerTransaction(transaction: transaction);
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('PULL RANGE ERROR: $e');

      debugPrint('$stackTrace');

      return false;
    }
  }

  // ============================================================
  // DEBUG
  // ============================================================

  Future<void> debugAllTransactions() async {
    final result =
        await (_db.select(_db.transactions)..orderBy([
          (tbl) => drift.OrderingTerm(
            expression: tbl.transactionDate,
            mode: drift.OrderingMode.desc,
          ),
        ])).get();

    debugPrint('========================================');

    debugPrint(
      'ALL LOCAL TRANSACTIONS: '
      '${result.length}',
    );

    debugPrint('========================================');

    for (final transaction in result) {
      debugPrint(
        'TX '
        'localId=${transaction.id} | '
        'serverId=${transaction.serverTransactionId} | '
        'kios=${transaction.idKios} | '
        'cabang=${transaction.idCabang} | '
        'kasir=${transaction.idKasir} | '
        'nama="${transaction.cashierName}" | '
        'date=${transaction.transactionDate} | '
        'total=${transaction.totalBayar} | '
        'sync=${transaction.syncStatus}',
      );
    }

    debugPrint('========================================');
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
