import 'package:cashier/commons/colors.dart';
import 'package:cashier/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final SyncService syncService = Get.find<SyncService>();

    return Obx(() {
      final state = syncService.syncState.value;

      final pending = syncService.pendingCount.value;

      if (compact) {
        return _buildCompact(context, syncService, state, pending);
      }

      return _buildFull(context, syncService, state, pending);
    });
  }

  Widget _buildCompact(
    BuildContext context,
    SyncService service,
    SyncState state,
    int pending,
  ) {
    final config = _getConfig(state, pending);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _showDetail(context, service);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: config.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: config.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state == SyncState.syncing)
              const SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(config.icon, size: 15, color: config.iconColor),
            const SizedBox(width: 6),
            Text(
              config.shortTitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: config.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFull(
    BuildContext context,
    SyncService service,
    SyncState state,
    int pending,
  ) {
    final config = _getConfig(state, pending);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: config.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: config.iconBackground,
              shape: BoxShape.circle,
            ),
            child:
                state == SyncState.syncing
                    ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Icon(config.icon, size: 20, color: config.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: config.textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  config.description,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: config.textColor.withValues(alpha: .75),
                  ),
                ),
              ],
            ),
          ),
          if (pending > 0 && state != SyncState.syncing)
            TextButton(
              onPressed:
                  service.isSyncing.value
                      ? null
                      : () {
                        service.syncNow();
                      },
              child: const Text('Sync'),
            ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, SyncService service) {
    final state = service.syncState.value;

    final pending = service.pendingCount.value;

    final config = _getConfig(state, pending);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Icon(config.icon, size: 32, color: config.iconColor),
            const SizedBox(height: 10),
            Text(
              config.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              config.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: MyColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (pending > 0) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      color: MyColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$pending transaksi '
                        'menunggu sinkronisasi',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MyColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed:
                    service.isSyncing.value
                        ? null
                        : () async {
                          Get.back();
                          await service.syncNow();
                        },
                icon: const Icon(Icons.sync_rounded),
                label: const Text('Sinkronkan Sekarang'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  _SyncConfig _getConfig(SyncState state, int pending) {
    switch (state) {
      case SyncState.syncing:
        return _SyncConfig(
          icon: Icons.sync_rounded,
          iconColor: MyColors.primary,
          iconBackground: MyColors.primaryLight,
          background: MyColors.primaryLight,
          border: MyColors.primary.withValues(alpha: .2),
          textColor: MyColors.primary,
          shortTitle: 'Menyinkronkan',
          title: 'Sedang menyinkronkan',
          description: 'Transaksi sedang dikirim ke server.',
        );

      case SyncState.pending:
        return _SyncConfig(
          icon: Icons.cloud_upload_rounded,
          iconColor: const Color(0xFFB7791F),
          iconBackground: const Color(0xFFFFF4D6),
          background: const Color(0xFFFFFBEB),
          border: const Color(0xFFF6D58A),
          textColor: const Color(0xFF8A5A00),
          shortTitle: '$pending menunggu',
          title: '$pending transaksi menunggu',
          description:
              'Transaksi sudah aman tersimpan '
              'di perangkat dan akan dikirim '
              'saat koneksi tersedia.',
        );

      case SyncState.offline:
        return _SyncConfig(
          icon: Icons.cloud_off_rounded,
          iconColor: const Color(0xFFB42318),
          iconBackground: const Color(0xFFFEE4E2),
          background: const Color(0xFFFFF5F5),
          border: const Color(0xFFFECACA),
          textColor: const Color(0xFFB42318),
          shortTitle: pending > 0 ? '$pending menunggu' : 'Offline',
          title: 'Belum terhubung ke server',
          description:
              pending > 0
                  ? '$pending transaksi tetap aman '
                      'di perangkat dan akan dicoba '
                      'kembali saat internet tersedia.'
                  : 'Aplikasi tetap dapat digunakan '
                      'untuk transaksi lokal.',
        );

      case SyncState.synced:
        return _SyncConfig(
          icon: Icons.cloud_done_rounded,
          iconColor: const Color(0xFF027A48),
          iconBackground: const Color(0xFFD1FADF),
          background: const Color(0xFFF6FEF9),
          border: const Color(0xFFA6F4C5),
          textColor: const Color(0xFF027A48),
          shortTitle: 'Tersinkron',
          title: 'Semua data tersinkron',
          description:
              'Tidak ada transaksi yang '
              'menunggu dikirim ke server.',
        );
    }
  }
}

class _SyncConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color background;
  final Color border;
  final Color textColor;
  final String shortTitle;
  final String title;
  final String description;

  const _SyncConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.background,
    required this.border,
    required this.textColor,
    required this.shortTitle,
    required this.title,
    required this.description,
  });
}
