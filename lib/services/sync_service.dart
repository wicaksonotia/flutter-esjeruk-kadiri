import 'package:cashier/database/app_database.dart';
import 'package:cashier/database/repositories/transaction_repository.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum SyncState { synced, pending, syncing, offline }

class SyncService extends GetxService {
  final TransactionRepository _transactionRepository = TransactionRepository();

  // ============================================================
  // STATE
  // ============================================================

  final RxBool isSyncing = false.obs;
  final RxInt pendingCount = 0.obs;
  final Rx<SyncState> syncState = SyncState.synced.obs;

  final RxString lastSyncMessage = 'Belum ada sinkronisasi'.obs;

  final Rx<DateTime?> lastSyncAt = Rx<DateTime?>(null);

  bool get hasPending => pendingCount.value > 0;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    refreshPendingCount();
  }

  // ============================================================
  // PENDING COUNT
  // ============================================================

  Future<void> refreshPendingCount() async {
    try {
      pendingCount.value = await _transactionRepository.getPendingCount();

      if (isSyncing.value) {
        syncState.value = SyncState.syncing;
      } else if (pendingCount.value > 0) {
        syncState.value = SyncState.pending;
      } else {
        syncState.value = SyncState.synced;
      }

      debugPrint('SYNC: pending count = ${pendingCount.value}');
    } catch (e) {
      debugPrint('SYNC COUNT ERROR: $e');
    }
  }

  // ============================================================
  // PUSH TRANSACTIONS
  // ============================================================

  Future<void> syncPendingTransactions() async {
    if (isSyncing.value) {
      debugPrint('SYNC: proses masih berjalan.');
      return;
    }

    isSyncing.value = true;
    syncState.value = SyncState.syncing;

    try {
      final pendingTransactions =
          await _transactionRepository.getPendingTransactions();

      pendingCount.value = pendingTransactions.length;

      if (pendingTransactions.isEmpty) {
        syncState.value = SyncState.synced;

        lastSyncMessage.value = 'Semua transaksi sudah tersinkron';

        lastSyncAt.value = DateTime.now();

        debugPrint('SYNC: tidak ada transaksi pending.');

        return;
      }

      debugPrint(
        'SYNC: ditemukan '
        '${pendingTransactions.length} transaksi pending.',
      );

      bool hasError = false;

      for (final transaction in pendingTransactions) {
        final success = await _syncSingleTransaction(transaction);

        if (!success) {
          hasError = true;
        }

        await refreshPendingCount();
      }

      await refreshPendingCount();

      if (pendingCount.value == 0) {
        syncState.value = SyncState.synced;

        lastSyncMessage.value = 'Semua transaksi berhasil disinkronkan';

        lastSyncAt.value = DateTime.now();
      } else if (hasError) {
        syncState.value = SyncState.offline;

        lastSyncMessage.value =
            '${pendingCount.value} transaksi menunggu koneksi';
      }
    } catch (e, stackTrace) {
      debugPrint('SYNC ERROR: $e');
      debugPrint('$stackTrace');

      syncState.value =
          pendingCount.value > 0 ? SyncState.offline : SyncState.synced;

      lastSyncMessage.value = 'Belum dapat terhubung ke server';
    } finally {
      isSyncing.value = false;
      await refreshPendingCount();
    }
  }

  // ============================================================
  // FORMAT TRANSACTION DATE
  // ============================================================

  String _formatTransactionDate(DateTime date) {
    // Jangan mengubah ke UTC.
    // Pertahankan representasi tanggal dari transaksi lokal.
    return date.toIso8601String();
  }

  // ============================================================
  // PUSH SINGLE TRANSACTION
  // ============================================================

  Future<bool> _syncSingleTransaction(Transaction transaction) async {
    final localUuid = transaction.localUuid;

    try {
      debugPrint('SYNC: processing $localUuid');

      // ----------------------------------------------------------
      // Ambil detail transaksi lokal
      // ----------------------------------------------------------

      final details = await _transactionRepository.getDetailsByLocalUuid(
        localUuid,
      );

      if (details.isEmpty) {
        debugPrint('SYNC: detail kosong untuk $localUuid');

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      // ----------------------------------------------------------
      // Tanggal asli transaksi dari SQLite
      // ----------------------------------------------------------

      final transactionDate = _formatTransactionDate(
        transaction.transactionDate,
      );

      debugPrint(
        'SYNC DATE => '
        'uuid=$localUuid | '
        'date=${transaction.transactionDate} | '
        'utc=${transaction.transactionDate.isUtc} | '
        'payload=$transactionDate',
      );

      // ----------------------------------------------------------
      // Header transaction
      // ----------------------------------------------------------

      final dataTransaction = {
        'id_kios': transaction.idKios,
        'id_cabang': transaction.idCabang,
        'id_kasir': transaction.idKasir,

        'sub_total': transaction.subTotal,
        'discount': transaction.discount,
        'total_bayar': transaction.totalBayar,

        'payment_method': transaction.paymentMethod,
        'total_quantity': transaction.totalQuantity,

        'local_uuid': localUuid,

        // TANGGAL ASLI TRANSAKSI LOKAL
        'transaction_date': transactionDate,
      };

      // ----------------------------------------------------------
      // Detail transaction
      // ----------------------------------------------------------

      final dataDetailTransaction =
          details.map((detail) {
            return {
              'id_product': detail.idProduct,
              'product_name': detail.productName,
              'quantity': detail.quantity,
              'unit_price': detail.unitPrice,
            };
          }).toList();

      // ----------------------------------------------------------
      // Request server
      // ----------------------------------------------------------

      final result = await RemoteDataSource.saveTransactionResult(
        dataTransaction,
        dataDetailTransaction,
      );

      // ----------------------------------------------------------
      // Server gagal
      // ----------------------------------------------------------

      if (!result.success) {
        debugPrint(
          'SYNC FAILED: '
          '$localUuid - ${result.message}',
        );

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      // ----------------------------------------------------------
      // Transaction ID kosong
      // ----------------------------------------------------------

      if (result.transactionId == null) {
        debugPrint(
          'SYNC FAILED: transaction_id kosong '
          'untuk $localUuid',
        );

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      // ----------------------------------------------------------
      // Mark synced
      // ----------------------------------------------------------

      await _transactionRepository.markAsSynced(
        localUuid: localUuid,
        serverTransactionId: result.transactionId!,
        numerator: result.numerator,
      );

      debugPrint(
        'SYNC SUCCESS: '
        '$localUuid → #${result.transactionId}'
        '${result.duplicate ? ' (DUPLICATE)' : ''}',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('SYNC TRANSACTION ERROR [$localUuid]: $e');

      debugPrint('$stackTrace');

      await _transactionRepository.markAsPending(localUuid: localUuid);

      return false;
    }
  }

  // ============================================================
  // PULL TRANSACTION BY MONTH
  // ============================================================

  Future<bool> pullTransactions({
    required int idKios,
    required int idCabang,
    required int month,
    required int year,
  }) async {
    try {
      debugPrint('========================================');
      debugPrint('SYNC PULL TRANSACTION BY MONTH');
      debugPrint('kios   : $idKios');
      debugPrint('cabang : $idCabang');
      debugPrint('month  : $month');
      debugPrint('year   : $year');
      debugPrint('========================================');

      final success = await _transactionRepository
          .syncTransactionsFromServerByMonth(
            idKios: idKios,
            idCabang: idCabang,
            month: month,
            year: year,
          );

      if (success) {
        lastSyncAt.value = DateTime.now();
        lastSyncMessage.value = 'Data transaksi berhasil diperbarui';

        debugPrint('SYNC PULL MONTH SUCCESS');
      } else {
        debugPrint('SYNC PULL MONTH FAILED');
      }

      return success;
    } catch (e, stackTrace) {
      debugPrint('SYNC PULL MONTH ERROR: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  // ============================================================
  // PULL TRANSACTION BY DATE RANGE
  // ============================================================

  Future<bool> pullTransactionsByDateRange({
    required int idKios,
    required int idCabang,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      debugPrint('========================================');
      debugPrint('SYNC PULL TRANSACTION BY DATE RANGE');
      debugPrint('kios   : $idKios');
      debugPrint('cabang : $idCabang');
      debugPrint('start  : $startDate');
      debugPrint('end    : $endDate');
      debugPrint('========================================');

      final success = await _transactionRepository
          .syncTransactionsFromServerByDateRange(
            idKios: idKios,
            idCabang: idCabang,
            startDate: startDate,
            endDate: endDate,
          );

      if (success) {
        lastSyncAt.value = DateTime.now();
        lastSyncMessage.value = 'Data transaksi berhasil diperbarui';

        debugPrint('SYNC PULL RANGE SUCCESS');
      } else {
        debugPrint('SYNC PULL RANGE FAILED');
      }

      return success;
    } catch (e, stackTrace) {
      debugPrint('SYNC PULL RANGE ERROR: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  // ============================================================
  // SYNC NOW
  // ============================================================

  Future<void> syncNow() async {
    await syncPendingTransactions();
  }
}
