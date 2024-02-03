import 'dart:io';

import 'package:binav_avts_getx/services/kapal.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class KapalFormController extends GetxController {
  late TextEditingController callSignController;
  late SingleValueDropDownController idClientController;
  late TextEditingController flagController;
  late TextEditingController kelasController;
  late TextEditingController builderController;
  late TextEditingController yearBuiltController;
  var vesselSize = "".obs;
  var isSwitched = true.obs;
  late TextEditingController filePickerController;

  Rx<Uint8List?> filePickerVal = Rx<Uint8List?>(null);

  var isLoad = false.obs;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (result != null) {
      filePickerController.text = result.files.single.name;
      filePickerVal.value = result.files.first.bytes;
    }
  }

  Future<void> getUpdatedData(String callSign) async {
    var token = GetStorage().read("userToken");

    await KapalService().getDataByID(token, callSign).then((value) {
      callSignController.text = value.data!.first.callSign!;
      flagController.text = value.data!.first.flag!;
      kelasController.text = value.data!.first.kelas!;
      builderController.text = value.data!.first.builder!;
      yearBuiltController.text = value.data!.first.yearBuilt!;
      filePickerController.text = value.data!.first.xmlFile!;
      isSwitched.value = value.data!.first.status!;
      vesselSize.value = value.data!.first.size!;
    });
  }

  Future<bool> addData() async {
    bool returnVal = false;
    isLoad.value = true;
    if (filePickerVal.value == null) {
      Alerts.snackBarGetx(title: "Vessel", message: "Xml File Required.", alertStatus: AlertStatus.DANGER);
      isLoad.value = false;
      return false;
    }

    var token = GetStorage().read("userToken");
    await KapalService().addData(token, {
      "call_sign": callSignController.text,
      "id_client": idClientController.dropDownValue!.value.toString(),
      "flag": flagController.text,
      "kelas": kelasController.text,
      "builder": builderController.text,
      "year_built": yearBuiltController.text,
      "size": vesselSize.value,
      "status": isSwitched.value,
      "xml_file": MultipartFile(filePickerVal.value, filename: filePickerController.text),
    }).then((value) {
      if (General.isApiOk(value.status!)) {
        Get.back();
        Get.delete<KapalFormController>();
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  Future<bool> updateData(String callSign) async {
    bool returnVal = false;
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await KapalService().updateData(token, callSign,{
      "new_call_sign": callSignController.text,
      "flag": flagController.text,
      "kelas": kelasController.text,
      "builder": builderController.text,
      "year_built": yearBuiltController.text,
      "size": vesselSize.value,
      "status": isSwitched.value,
      "xml_file": filePickerVal.value != null ? MultipartFile(filePickerVal.value, filename: filePickerController.text) : null,
    }).then((value) {
      if (General.isApiOk(value.status!)) {
        Get.back();
        Get.delete<KapalFormController>();
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  @override
  void onInit() {
    super.onInit();
    callSignController = TextEditingController();
    idClientController = SingleValueDropDownController();
    flagController = TextEditingController();
    kelasController = TextEditingController();
    builderController = TextEditingController();
    yearBuiltController = TextEditingController();
    filePickerController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    callSignController.dispose();
    idClientController.dispose();
    flagController.dispose();
    kelasController.dispose();
    builderController.dispose();
    yearBuiltController.dispose();
    filePickerController.dispose();
  }
}
