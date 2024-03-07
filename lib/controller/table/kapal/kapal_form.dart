import 'dart:io';

import 'package:binav_avts_getx/services/kapal.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/alerts.dart';
import '../../../utils/general.dart';

class KapalFormController extends GetxController {
  late TextEditingController callSignController;
  late SingleValueDropDownController idClientController;
  late TextEditingController flagController;
  late TextEditingController kelasController;
  late TextEditingController builderController;
  late TextEditingController yearBuiltController;
  late TextEditingController headingdirectionController;
  var vesselSize = "".obs;
  var isSwitched = true.obs;
  late TextEditingController filePickerController;

  Rx<Uint8List?> filePickerVal = Rx<Uint8List?>(null);

  Rx<Uint8List?> webImage_1 = Rx<Uint8List?>(null);
  Rx<File?> file_1 = Rx<File?>(null);
  // Uint8List webImage_1 = Uint8List(8);

  late ImagePicker image_1;
  // Rx<File>? file_1 ;

  var isLoad = false.obs;

  void pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (result != null) {
      filePickerController.text = result.files.single.name;
      filePickerVal.value = result.files.first.bytes;
    }
  }

  void pickImage() async {
    var img = await image_1.pickImage(source: ImageSource.gallery);
    var f = await img!.readAsBytes();

    webImage_1.value = f;
    file_1.value = File(img.path);
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
      headingdirectionController.text = value.data!.first.headingDirection.toString();
      isSwitched.value = value.data!.first.status!;
      vesselSize.value = value.data!.first.size!;
    });
  }

  Future<bool> addData() async {
    bool returnVal = false;
    isLoad.value = true;
    if (webImage_1.value == null) {
      Alerts.snackBarGetx(
          title: "Vessel", message: "Image Required.", alertStatus: AlertStatus.DANGER);
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
      "xml_file": filePickerVal.value == null
          ? null
          : MultipartFile(filePickerVal.value, filename: filePickerController.text),
      "image": MultipartFile(webImage_1.value, filename:"image"),
      "heading_direction":headingdirectionController.text,
    }).then((value) {
      if (General.isApiOk(value.status!.toInt())) {
        Get.back();
        Get.delete<KapalFormController>();
        Alerts.snackBarGetx(
            title: "Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(
            title: "Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(
          title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(
          title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoad.value = false;

    return returnVal;
  }

  Future<bool> updateData(String callSign) async {
    bool returnVal = false;
    isLoad.value = true;

    var token = GetStorage().read("userToken");
    await KapalService().updateData(token, callSign, {
      "new_call_sign": callSignController.text,
      "flag": flagController.text,
      "kelas": kelasController.text,
      "builder": builderController.text,
      "year_built": yearBuiltController.text,
      "size": vesselSize.value,
      "status": isSwitched.value,
      "xml_file": filePickerVal.value != null
          ? MultipartFile(filePickerVal.value, filename: filePickerController.text)
          : null,
      "image": MultipartFile(webImage_1.value, filename: "image"),
      "heading_direction":headingdirectionController.text,
    }).then((value) {
      if (General.isApiOk(value.status!.toInt())) {
        Get.back();
        Get.delete<KapalFormController>();
        Alerts.snackBarGetx(
            title: "Vessel", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;
      } else {
        Alerts.snackBarGetx(
            title: "Vessel", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(
          title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(
          title: "Vessel", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
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
    headingdirectionController = TextEditingController();
    filePickerController = TextEditingController();
    image_1 = ImagePicker();
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
