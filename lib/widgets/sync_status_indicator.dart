import 'package:cashier/commons/colors.dart';
import 'package:cashier/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final SyncService syncService = Get.find<SyncService>();

    return Obx(() {
      final state = syncService.syncState.value;
      final pending = syncService.pendingCount.value;

      final config = _getConfig(state, pending);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap:
              onTap ??
              () {
                _showSyncBottomSheet(context, syncService);
              },
          child: Container(
            constraints: const BoxConstraints(minHeight: 34),
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
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: config.iconColor,
                    ),
                  )
                else
                  Icon(config.icon, size: 15, color: config.iconColor),

                const SizedBox(width: 6),

                Text(
                  config.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: config.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showSyncBottomSheet(BuildContext context, SyncService syncService) {
    Get.bottomSheet(
      Obx(() {
        final state = syncService.syncState.value;

        final pending = syncService.pendingCount.value;

        final config = _getConfig(state, pending);

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: const BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MyColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: config.iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child:
                      state == SyncState.syncing
                          ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: config.iconColor,
                            ),
                          )
                          : Icon(
                            config.icon,
                            size: 27,
                            color: config.iconColor,
                          ),
                ),

                const SizedBox(height: 14),

                Text(
                  config.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  config.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: MyColors.textSecondary,
                  ),
                ),

                if (pending > 0) ...[
                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          size: 20,
                          color: MyColors.primary,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            '$pending transaksi '
                            'belum tersinkron',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
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
                        syncService.isSyncing.value
                            ? null
                            : () async {
                              await syncService.syncNow();
                            },
                    icon: const Icon(Icons.sync_rounded, size: 19),
                    label: Text(
                      syncService.isSyncing.value
                          ? 'Menyinkronkan...'
                          : 'Sinkronkan Sekarang',
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  _SyncConfig _getConfig(SyncState state, int pending) {
    switch (state) {
      case SyncState.syncing:
        return const _SyncConfig(
          icon: Icons.sync_rounded,
          iconColor: MyColors.primary,
          iconBackground: MyColors.primaryLight,
          background: MyColors.primaryLight,
          border: MyColors.primaryLight,
          textColor: MyColors.primary,
          label: 'Sync...',
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
          label: '$pending pending',
          title: '$pending transaksi menunggu',
          description:
              'Transaksi sudah tersimpan aman '
              'di perangkat dan akan dikirim '
              'ke server saat koneksi tersedia.',
        );

      case SyncState.offline:
        return _SyncConfig(
          icon: Icons.cloud_off_rounded,
          iconColor: const Color(0xFFB42318),
          iconBackground: const Color(0xFFFEE4E2),
          background: const Color(0xFFFFF5F5),
          border: const Color(0xFFFECACA),
          textColor: const Color(0xFFB42318),
          label: pending > 0 ? '$pending pending' : 'Offline',
          title: 'Belum terhubung ke server',
          description:
              pending > 0
                  ? '$pending transaksi tetap aman '
                      'di perangkat. Sinkronisasi akan '
                      'dicoba kembali saat koneksi tersedia.'
                  : 'Aplikasi tetap dapat digunakan '
                      'untuk transaksi lokal.',
        );

      case SyncState.synced:
        return const _SyncConfig(
          icon: Icons.cloud_done_rounded,
          iconColor: Color(0xFF027A48),
          iconBackground: Color(0xFFD1FADF),
          background: Color(0xFFF6FEF9),
          border: Color(0xFFA6F4C5),
          textColor: Color(0xFF027A48),
          label: 'Tersinkron',
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
  final String label;
  final String title;
  final String description;

  const _SyncConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.background,
    required this.border,
    required this.textColor,
    required this.label,
    required this.title,
    required this.description,
  });
}
