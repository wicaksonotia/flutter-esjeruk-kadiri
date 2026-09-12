import 'package:cashier/commons/currency.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptService {
  static Future<List<int>> generateReceipt(TransactionModel trx) async {
    final prefs = await SharedPreferences.getInstance();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final bytes = <int>[];

    bytes.addAll(generator.reset());
    bytes.addAll(_header(generator, prefs));
    bytes.addAll(_transactionInfo(generator, trx, prefs));
    bytes.addAll(_items(generator, trx.details ?? []));
    bytes.addAll(_summary(generator, trx));
    bytes.addAll(_footer(generator));

    return bytes;
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  static List<int> _header(Generator g, SharedPreferences prefs) {
    return [
      ...g.text(
        (prefs.getString('kios') ?? '').toUpperCase(),
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
        ),
      ),
      ...g.text(
        prefs.getString('keterangan_print') ?? '',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      ...g.text(
        'Cabang - ${prefs.getString('cabang') ?? '-'}',
        styles: const PosStyles(align: PosAlign.center),
      ),
      ...g.feed(1),
      ...g.text(
        prefs.getString('alamat_cabang') ?? '',
        styles: const PosStyles(align: PosAlign.center),
      ),
      ...g.feed(1),
    ];
  }

  // ==========================================================
  // INFO TRANSAKSI
  // ==========================================================

  static List<int> _transactionInfo(
    Generator g,
    TransactionModel trx,
    SharedPreferences prefs,
  ) {
    return [
      ..._rowText(g, 'Numerator', trx.numerator.toString().padLeft(4, '0')),
      ..._rowText(
        g,
        'Waktu',
        DateFormat(
          'dd-MM-yyyy HH:mm',
        ).format(DateTime.parse(trx.transactionDate!)),
      ),
      ..._rowText(g, 'Kasir', prefs.getString('nama_kasir') ?? '-'),
      ...g.hr(),
    ];
  }

  // ==========================================================
  // LIST ITEM
  // ==========================================================

  static List<int> _items(Generator g, List<ListDetailTransactionModel> items) {
    final bytes = <int>[];

    for (final item in items) {
      bytes.addAll(
        g.row([
          PosColumn(text: item.productName ?? '-', width: 7),
          PosColumn(
            text: '${item.quantity ?? 0}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: CurrencyFormat.convertToIdr(item.totalPrice ?? 0, 0),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]),
      );
    }

    return bytes;
  }

  // ==========================================================
  // TOTAL
  // ==========================================================

  static List<int> _summary(Generator g, TransactionModel trx) {
    final subtotal = (trx.details ?? []).fold<int>(
      0,
      (sum, item) => sum + (item.totalPrice ?? 0),
    );

    return [
      ...g.hr(),
      ..._rowMoney(g, 'Subtotal', subtotal),
      ..._rowMoney(g, 'Discount', trx.discount ?? 0),
      ...g.hr(),
      ...g.row([
        PosColumn(text: 'TOTAL', width: 6, styles: const PosStyles(bold: true)),
        PosColumn(
          text: CurrencyFormat.convertToIdr(trx.grandTotal ?? 0, 0),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
        ),
      ]),
    ];
  }

  // ==========================================================
  // FOOTER
  // ==========================================================

  static List<int> _footer(Generator g) {
    return [
      ...g.hr(),
      ...g.feed(1),
      ...g.text(
        'Pendapat Anda sangat penting',
        styles: const PosStyles(align: PosAlign.center),
      ),
      ...g.text(
        'bagi kami. Kritik & saran:',
        styles: const PosStyles(align: PosAlign.center),
      ),
      ...g.text(
        '0857-5512-4535',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      ...g.feed(3),
    ];
  }

  // ==========================================================
  // HELPER
  // ==========================================================

  static List<int> _rowText(Generator g, String left, String right) {
    return g.row([
      PosColumn(text: left, width: 4),
      PosColumn(
        text: right,
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  static List<int> _rowMoney(Generator g, String title, int value) {
    return g.row([
      PosColumn(text: title, width: 6),
      PosColumn(
        text: CurrencyFormat.convertToIdr(value, 0),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }
}
