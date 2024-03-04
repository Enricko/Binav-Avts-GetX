import 'package:binav_avts_getx/model/get_ip_vessel.dart' as GetIpKapal;
import 'package:binav_avts_getx/model/get_kapal_response.dart' as GetKapal;
import 'package:binav_avts_getx/services/kapal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class IpTableController extends GetxController {
  var isLoad = false.obs;
  late TextEditingController ipController;
  late TextEditingController portController ;
  var type = "".obs;
  var ignorePointer = false.obs;

  RxList<GetIpKapal.Data>? dataIp;


  Future<void> getIpKapal(String callSign) async {
    isLoad.value = true;
    var token = GetStorage().read("userToken");
    await KapalService().getIpVessel(token, callSign).then((value) {
      dataIp = value.data!.obs as RxList<GetIpKapal.Data>?;
    });
    isLoad.value = false;
  }

  Future<bool> addIpKapal(String callSign) async {
    bool returnVal = false;
    isLoad.value = true;
    var token = GetStorage().read("userToken");
    await KapalService().addIpVessel(token, callSign ,{
      "type_ip": type,
      "ip": ipController.text,
      "port": portController.text,
    },
    ).then((value) {
      if (General.isApiOk(value.status!.toInt())) {
        Get.back();
        Get.delete<IpTableController>();
        Alerts.snackBarGetx(title: "IP Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "IP Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "IP Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "IP Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }



  @override
  void onInit() {
    super.onInit();
    ipController = TextEditingController();
    portController = TextEditingController();
  }
}
