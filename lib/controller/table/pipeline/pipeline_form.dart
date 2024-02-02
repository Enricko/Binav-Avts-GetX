import 'package:binav_avts_getx/services/pipeline.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class PipelineFormController extends GetxController {
  late SingleValueDropDownController idClientController;
  late TextEditingController nameController;
  var isSwitched = true.obs;
  late TextEditingController filePickerController;

  Rx<Uint8List?> filePickerVal = Rx<Uint8List?>(null);

  var isLoad = false.obs;
  
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['kml','kmz']);

    if (result != null) {
      filePickerController.text = result.files.single.name;
      filePickerVal.value = result.files.first.bytes;
    }
  }

  Future<bool> addData() async {
    bool returnVal = false;
    isLoad.value = true;
    if (filePickerVal.value == null) {
      Alerts.snackBarGetx(title: "Pipeline", message: "File Required.", alertStatus: AlertStatus.DANGER);
      isLoad.value = false;
      return false;
    }

    var token = GetStorage().read("userToken");
    await PipelineService().addData(token, {
      "name": nameController.text,
      "id_client": idClientController.dropDownValue!.value.toString(),
      "status": isSwitched.value,
      "file": MultipartFile(filePickerVal.value, filename: filePickerController.text),
    }).then((value) {
      print(value.toJson().toString());
      if (General.isApiOk(value.status!)) {
        Get.back();
        Get.delete<PipelineFormController>();
        Alerts.snackBarGetx(title: "Pipeline", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Pipeline", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Pipeline", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "$error", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  @override
  void onInit() {
    super.onInit();
    idClientController = SingleValueDropDownController();
    nameController = TextEditingController();
    filePickerController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    idClientController.dispose();
    nameController.dispose();
    filePickerController.dispose();
  }
}
