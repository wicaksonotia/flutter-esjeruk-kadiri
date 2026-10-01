import 'package:cashier/database/app_database.dart';
import 'package:cashier/database/repositories/transaction_repository.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum SyncState { synced, pending, syncing, offline }

class SyncService extends GetxService {
  final TransactionRepository _transactionRepository = TransactionRepository();

  final RxBool isSyncing = false.obs;

  final RxInt pendingCount = 0.obs;

  final Rx<SyncState> syncState = SyncState.synced.obs;

  final RxString lastSyncMessage = 'Belum ada sinkronisasi'.obs;

  final Rx<DateTime?> lastSyncAt = Rx<DateTime?>(null);

  bool get hasPending => pendingCount.value > 0;

  @override
  void onInit() {
    super.onInit();

    refreshPendingCount();
  }

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
        '${pendingTransactions.length} '
        'transaksi pending.',
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
    } catch (e) {
      debugPrint('SYNC ERROR: $e');

      syncState.value =
          pendingCount.value > 0 ? SyncState.offline : SyncState.synced;

      lastSyncMessage.value = 'Belum dapat terhubung ke server';
    } finally {
      isSyncing.value = false;

      await refreshPendingCount();
    }
  }

  Future<bool> _syncSingleTransaction(Transaction transaction) async {
    final String localUuid = transaction.localUuid;

    try {
      debugPrint('SYNC: processing $localUuid');

      final details = await _transactionRepository.getDetailsByLocalUuid(
        localUuid,
      );

      if (details.isEmpty) {
        debugPrint('SYNC: detail kosong untuk $localUuid');

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      final dataTransaction = {
        'id_kios': transaction.idKios,
        'id_cabang': transaction.idCabang,
        'id_kasir': transaction.idKasir,
        'sub_total': transaction.subTotal,
        'discount': transaction.discount,
        'total_bayar': transaction.totalBayar,
        'payment_method': transaction.paymentMethod,
        'total_quantity': transaction.totalQuantity,
        'local_uuid': transaction.localUuid,
      };

      final dataDetailTransaction =
          details.map((detail) {
            return {
              'id_product': detail.idProduct,
              'product_name': detail.productName,
              'quantity': detail.quantity,
              'unit_price': detail.unitPrice,
            };
          }).toList();

      final result = await RemoteDataSource.saveTransactionResult(
        dataTransaction,
        dataDetailTransaction,
      );

      if (!result.success) {
        debugPrint(
          'SYNC FAILED: '
          '$localUuid - '
          '${result.message}',
        );

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      if (result.transactionId == null) {
        debugPrint(
          'SYNC FAILED: transaction_id kosong '
          'untuk $localUuid',
        );

        await _transactionRepository.markAsPending(localUuid: localUuid);

        return false;
      }

      await _transactionRepository.markAsSynced(
        localUuid: localUuid,
        serverTransactionId: result.transactionId!,
        numerator: result.numerator,
      );

      debugPrint(
        'SYNC SUCCESS: '
        '$localUuid → '
        '#${result.transactionId}'
        '${result.duplicate ? ' (DUPLICATE)' : ''}',
      );

      return true;
    } catch (e) {
      debugPrint(
        'SYNC TRANSACTION ERROR '
        '[$localUuid]: $e',
      );

      await _transactionRepository.markAsPending(localUuid: localUuid);

      return false;
    }
  }

  Future<void> syncNow() async {
    await syncPendingTransactions();
  }
}
