import 'package:binav_avts_getx/services/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class ClientFormController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationtController;
  var isSwitched = true.obs;

  var isLoad = false.obs;

  Future<void> getUpdatedData(String callSign) async {
    var token = GetStorage().read("userToken");

    await ClientService().getDataByID(token, callSign).then((value) {
      nameController.text = value.data!.first.user!.name!;
      emailController.text = value.data!.first.user!.email!;
      isSwitched.value = value.data!.first.status!;
    });
  }

  Future<bool> addData() async {
    bool returnVal = false;
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await ClientService().addData(token, {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": passwordConfirmationtController.text,
      "status": isSwitched.value,
    }).then((value) {
      if (General.isApiOk(value.status!)) {
        Get.back();
        Get.delete<ClientFormController>();
        Alerts.snackBarGetx(title: "Client", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Client", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Client", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Client", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  Future<bool> updateData(String idClient) async {
    bool returnVal = false;
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await ClientService().updateData(token, idClient, {
      "name": nameController.text,
      "email": emailController.text,
      "status": isSwitched.value,
    }).then((value) {
      if (General.isApiOk(value.status!)) {
        Get.back();
        Get.delete<ClientFormController>();
        Alerts.snackBarGetx(title: "Client", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Client", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Client", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Client", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationtController = TextEditingController();
  }
}
