import 'package:cashier/networks/api_request.dart';
import 'package:cashier/services/printer_service.dart';
import 'package:cashier/services/receipt_service.dart';
import 'package:get/get.dart';

class PrintNotaController extends GetxController {
  Future<void> printTransaction(int id) async {
    try {
      final transaction = await RemoteDataSource.getDetailTransaction({
        "id_transaction": id,
      });

      if (transaction == null) {
        Get.snackbar('Error', 'Transaksi tidak ditemukan');
        return;
      }

      final bytes = await ReceiptService.generateReceipt(transaction);

      await PrinterService.print(bytes);
    } catch (e) {
      Get.snackbar(
        'Print',
        'Gagal mencetak nota',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
