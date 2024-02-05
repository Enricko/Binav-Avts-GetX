import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../model/get_client_response.dart' as GetClient;
import '../../../services/client.dart';

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
}
