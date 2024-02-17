import 'package:binav_avts_getx/model/get_pipeline_response.dart' as GetPipeline;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/pipeline.dart';
import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class PipelineTableController extends GetxController {
  var isLoad = false.obs;
  var page = 1.obs;
  var perpage = 10.obs;
  var total_page = 1.obs;

  var total = 0.obs;

  RxList<GetPipeline.Data>? data;

  Future<void> getPipelineData() async {
    isLoad.value = true;
    var token = GetStorage().read("userToken");
    await PipelineService().getData(token, page.value, perpage.value).then((value) {
      data = value.data!.obs as RxList<GetPipeline.Data>?;
      total_page.value = (value.total! / perpage.value).ceil();
    });
    isLoad.value = false;
  }

  Future<void> deleteData({required String idMapping}) async {
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await PipelineService().deleteData(token, idMapping).then((value) {
      if (General.isApiOk(value.status!)) {
        Alerts.snackBarGetx(title: "Pipeline", message: value.message!, alertStatus: AlertStatus.SUCCESS);
      } else {
        Alerts.snackBarGetx(title: "Pipeline", message: value.message!, alertStatus: AlertStatus.DANGER);
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Pipeline", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Pipeline", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
    });
    isLoad.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getPipelineData();
  }
}
