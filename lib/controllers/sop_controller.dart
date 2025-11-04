import 'package:cashier/models/sop_model.dart';
import 'package:cashier/networks/api_request.dart';
import 'package:get/get.dart';

class SopController extends GetxController {
  var listSop = <SopModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchDataListSop();
    super.onInit();
  }

  void fetchDataListSop() async {
    try {
      isLoading(true);
      var result = await RemoteDataSource.getListSop();
      if (result != null) {
        listSop.assignAll(result);
      }
    } finally {
      isLoading(false);
    }
  }
}
