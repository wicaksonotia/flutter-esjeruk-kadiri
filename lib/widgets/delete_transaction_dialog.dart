import 'package:cashier/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeleteTransactionDialog extends StatefulWidget {
  const DeleteTransactionDialog({super.key});

  @override
  State<DeleteTransactionDialog> createState() =>
      _DeleteTransactionDialogState();
}

class _DeleteTransactionDialogState extends State<DeleteTransactionDialog> {
  final TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: MyColors.red.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: MyColors.red,
                    size: 23,
                  ),
                ),

                const Gap(12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hapus transaksi?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: MyColors.textDark,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Tindakan ini akan membatalkan transaksi.',
                        style: TextStyle(fontSize: 12, color: MyColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Gap(20),

            // ==================================================
            // WARNING
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.red.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColors.red.withValues(alpha: .10)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: MyColors.red,
                    size: 18,
                  ),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'Pastikan transaksi yang dipilih memang perlu dibatalkan.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: MyColors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(16),

            // ==================================================
            // LABEL
            // ==================================================
            const Text(
              'Alasan penghapusan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: MyColors.textDark,
              ),
            ),

            const Gap(7),

            // ==================================================
            // TEXT FIELD
            // ==================================================
            TextField(
              controller: reasonController,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Contoh: Salah input produk',
                hintStyle: TextStyle(
                  color: MyColors.grey.withValues(alpha: .7),
                  fontSize: 12,
                ),
                filled: true,
                fillColor: MyColors.notionBgGrey,
                contentPadding: const EdgeInsets.all(13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: MyColors.primary,
                    width: 1.2,
                  ),
                ),
              ),
            ),

            const Gap(20),

            // ==================================================
            // BUTTON
            // ==================================================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: MyColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const Gap(10),

                Expanded(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: reasonController,
                    builder: (context, value, child) {
                      final canSubmit = value.text.trim().isNotEmpty;

                      return ElevatedButton(
                        onPressed:
                            canSubmit
                                ? () {
                                  Navigator.of(context).pop(value.text.trim());
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: MyColors.red,
                          disabledBackgroundColor: Colors.grey.shade200,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: TextStyle(
                            color:
                                canSubmit ? Colors.white : Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
