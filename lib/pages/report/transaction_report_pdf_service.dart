import 'package:cashier/commons/currency.dart';
import 'package:cashier/models/transaction_history_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionReportPdfService {
  static Future<pw.Document> generate({
    required List<TransactionModel> transactions,
    required String filterBy,
    required int month,
    required int year,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final pdf = pw.Document();

    final kios = prefs.getString('kios') ?? '';
    final cabang = prefs.getString('cabang') ?? '-';
    final alamat = prefs.getString('alamat_cabang') ?? '';
    final kasir = prefs.getString('nama_kasir') ?? '-';

    final activeTransactions =
        transactions.where((item) => item.deleteStatus == false).toList();

    final totalTransaction = activeTransactions.length;

    final totalItem = activeTransactions.fold<int>(0, (sum, trx) {
      final details = trx.details ?? [];

      return sum +
          details.fold<int>(
            0,
            (detailSum, detail) => detailSum + (detail.quantity ?? 0),
          );
    });

    final totalOmzet = activeTransactions.fold<int>(
      0,
      (sum, trx) => sum + (trx.grandTotal ?? 0),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        header: (context) {
          return _header(
            kios: kios,
            cabang: cabang,
            alamat: alamat,
            kasir: kasir,
            filterBy: filterBy,
            month: month,
            year: year,
            startDate: startDate,
            endDate: endDate,
          );
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Halaman ${context.pageNumber} / ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
          );
        },
        build: (context) {
          return [
            _summary(
              totalTransaction: totalTransaction,
              totalItem: totalItem,
              totalOmzet: totalOmzet,
            ),

            pw.SizedBox(height: 15),

            _transactionTable(activeTransactions),
          ];
        },
      ),
    );

    return pdf;
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  static pw.Widget _header({
    required String kios,
    required String cabang,
    required String alamat,
    required String kasir,
    required String filterBy,
    required int month,
    required int year,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            kios.toUpperCase(),
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),

        pw.SizedBox(height: 3),

        pw.Center(
          child: pw.Text(
            'LAPORAN TRANSAKSI',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ),

        pw.SizedBox(height: 3),

        pw.Center(
          child: pw.Text(
            'Cabang - $cabang',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),

        if (alamat.isNotEmpty)
          pw.Center(
            child: pw.Text(alamat, style: const pw.TextStyle(fontSize: 9)),
          ),

        pw.SizedBox(height: 10),

        pw.Divider(),

        pw.SizedBox(height: 5),

        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                'Kasir : $kasir',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Text(
              _periodText(
                filterBy: filterBy,
                month: month,
                year: year,
                startDate: startDate,
                endDate: endDate,
              ),
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        pw.SizedBox(height: 10),
      ],
    );
  }

  // ==========================================================
  // PERIOD
  // ==========================================================

  static String _periodText({
    required String filterBy,
    required int month,
    required int year,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (filterBy == 'bulan') {
      return 'Periode : ${_monthName(month)} $year';
    }

    return 'Periode : ${_date(startDate)} - ${_date(endDate)}';
  }

  static String _monthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month];
  }

  static String _date(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  // ==========================================================
  // SUMMARY
  // ==========================================================

  static pw.Widget _summary({
    required int totalTransaction,
    required int totalItem,
    required int totalOmzet,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _summaryBox('Total Transaksi', totalTransaction.toString()),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(child: _summaryBox('Total Item', totalItem.toString())),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _summaryBox(
            'Total Omzet',
            CurrencyFormat.convertToIdr(totalOmzet, 0),
          ),
        ),
      ],
    );
  }

  static pw.Widget _summaryBox(String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TRANSACTION TABLE
  // ==========================================================

  static pw.Widget _transactionTable(List<TransactionModel> transactions) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellPadding: const pw.EdgeInsets.all(5),
      columnWidths: {
        0: const pw.FixedColumnWidth(30),
        1: const pw.FixedColumnWidth(65),
        2: const pw.FixedColumnWidth(55),
        3: const pw.FlexColumnWidth(2),
        4: const pw.FixedColumnWidth(35),
        5: const pw.FixedColumnWidth(70),
        6: const pw.FixedColumnWidth(70),
      },
      headers: [
        'No',
        'Tanggal',
        'Numerator',
        'Produk',
        'Qty',
        'Subtotal',
        'Total',
      ],
      data: _buildTableRows(transactions),
    );
  }

  static List<List<String>> _buildTableRows(
    List<TransactionModel> transactions,
  ) {
    final rows = <List<String>>[];

    int no = 1;

    for (final trx in transactions) {
      final details = trx.details ?? [];

      if (details.isEmpty) {
        rows.add([
          '$no',
          _transactionDate(trx),
          trx.numerator?.toString().padLeft(4, '0') ?? '-',
          '-',
          '0',
          CurrencyFormat.convertToIdr(0, 0),
          CurrencyFormat.convertToIdr(trx.grandTotal ?? 0, 0),
        ]);

        no++;
        continue;
      }

      for (final detail in details) {
        rows.add([
          '$no',
          _transactionDate(trx),
          trx.numerator?.toString().padLeft(4, '0') ?? '-',
          detail.productName ?? '-',
          '${detail.quantity ?? 0}',
          CurrencyFormat.convertToIdr(detail.totalPrice ?? 0, 0),
          CurrencyFormat.convertToIdr(trx.grandTotal ?? 0, 0),
        ]);
      }

      no++;
    }

    return rows;
  }

  static String _transactionDate(TransactionModel trx) {
    if (trx.transactionDate == null) {
      return '-';
    }

    try {
      final date = DateTime.parse(trx.transactionDate!);

      return '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}\n'
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return trx.transactionDate!;
    }
  }
}
