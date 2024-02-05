import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../model/get_client_response.dart' as GetClient;
import '../../../services/client.dart';
import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class ClientTableController extends GetxController {
  var isLoad = false.obs;
  var page = 1.obs;
  var perpage = 10.obs;
  var total_page = 1.obs;

  var total = 0.obs;

  RxList<GetClient.Data>? data;

  Future<void> getClientData() async {
    isLoad.value = true;
    var token = GetStorage().read("userToken");
    await ClientService().getData(token, page.value, perpage.value).then((value) {
      data = value.data!.obs as RxList<GetClient.Data>?;
      total_page.value = (value.total! / perpage.value).ceil();
    });
    isLoad.value = false;
  }

    Future<void> deleteData({required String idClient}) async {
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await ClientService().deleteData(token, idClient).then((value) {
      if (General.isApiOk(value.status!)) {
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
      } else {
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
    });
    isLoad.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getClientData();
  }
}
