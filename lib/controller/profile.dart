import 'package:binav_avts_getx/utils/alerts.dart';
import 'package:binav_avts_getx/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth.dart';

class ProfileController extends GetxController {
  var currentWidget = "profile_page".obs;
  //
  // var invisible = true.obs;
  var isLoading = false.obs;

  var isChangePassword = false.obs;
  var invisibleOldPass = true.obs;
  var invisibleNewPass = true.obs;
  var invisibleConfirmPass = true.obs;
  var ignorePointer = false.obs;

  late TextEditingController OldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  var name = "";
  var email = "";

  var box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    name = box.read("name");
    email = box.read("email");
    OldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    OldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    // otpController.dispose();
  }

  Future<bool> changepassword() async {
    bool returnVal = false;
    isLoading.value = true;
    var token = GetStorage().read("userToken");
    print(token);
    await AuthService().changePassword(token,OldPasswordController.text, newPasswordController.text, confirmPasswordController.text).then((value) async {
    print(value.status);
      if (General.isApiOk(value.status!)){
          Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.SUCCESS);
          returnVal = true;

      } else {
        Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "${error}", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }

  Future<bool> logout() async {
    bool returnVal = false;
    isLoading.value = true;
    var token = GetStorage().read("userToken");
    print(token);
    await AuthService().logout(token).then((value) async {
      if (General.isApiOk(value.status!)){
        Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        returnVal = true;

      } else {
        Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "${error}", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }

  // void changeWidget(String nameWidget) {
  //   currentWidget.value = nameWidget;
  // }
  //
  // Future<bool> login() async {
  //   bool returnVal = false;
  //   isLoading.value = true;
  //   await AuthService().login(emailController.text, passwordController.text).then((value) {
  //     if (General.isApiOk(value.status!)) {
  //       Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.SUCCESS);
  //       var box = GetStorage();
  //       box.write("userToken", "${value.token}");
  //       returnVal = true;
  //     } else {
  //       Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.DANGER);
  //       returnVal = false;
  //     }
  //   }).timeout(const Duration(seconds: 10), onTimeout: () {
  //     Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   }).onError((error, stackTrace) {
  //     Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   });
  //   isLoading.value = false;
  //   return returnVal;
  // }
  //
  // Future<bool> sendOtp() async {
  //   bool returnVal = false;
  //   isLoading.value = true;
  //   await AuthService().sendOtp(emailController.text).then((value) {
  //     if (General.isApiOk(value.status!)) {
  //       Alerts.snackBarGetx(title: "Forget Password", message: value.message!, alertStatus: AlertStatus.SUCCESS);
  //       passwordController.clear();
  //       passwordConfirmationController.clear();
  //       returnVal = true;
  //     } else {
  //       Alerts.snackBarGetx(title: "Forget Password", message: value.message!, alertStatus: AlertStatus.DANGER);
  //       returnVal = false;
  //     }
  //   }).timeout(const Duration(seconds: 10), onTimeout: () {
  //     Alerts.snackBarGetx(title: "Forget Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   }).onError((error, stackTrace) {
  //     Alerts.snackBarGetx(title: "Forget Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   });
  //   isLoading.value = false;
  //   return returnVal;
  // }
  //
  // Future<bool> checkOtp() async {
  //   bool returnVal = false;
  //   isLoading.value = true;
  //   await AuthService().checkOtp(emailController.text, otpController.text).then((value) {
  //     if (General.isApiOk(value.status!)) {
  //       Alerts.snackBarGetx(title: "Check OTP", message: value.message!, alertStatus: AlertStatus.SUCCESS);
  //       passwordController.clear();
  //       passwordConfirmationController.clear();
  //       returnVal = true;
  //     } else {
  //       Alerts.snackBarGetx(title: "Check OTP", message: value.message!, alertStatus: AlertStatus.DANGER);
  //       returnVal = false;
  //     }
  //   }).timeout(const Duration(seconds: 10), onTimeout: () {
  //     Alerts.snackBarGetx(title: "Check OTP", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   }).onError((error, stackTrace) {
  //     Alerts.snackBarGetx(title: "Check OTP", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   });
  //   isLoading.value = false;
  //   return returnVal;
  // }
  //
  // Future<bool> resetPassword() async {
  //   bool returnVal = false;
  //   isLoading.value = true;
  //   await AuthService()
  //       .resetPassword(
  //       emailController.text, otpController.text, passwordController.text, passwordConfirmationController.text)
  //       .then((value) {
  //     if (General.isApiOk(value.status!)) {
  //       Alerts.snackBarGetx(title: "Reset Password", message: value.message!, alertStatus: AlertStatus.SUCCESS);
  //       otpController.clear();
  //       passwordController.clear();
  //       passwordConfirmationController.clear();
  //       returnVal = true;
  //     } else {
  //       Alerts.snackBarGetx(title: "Reset Password", message: value.message!, alertStatus: AlertStatus.DANGER);
  //       returnVal = false;
  //     }
  //   }).timeout(const Duration(seconds: 10), onTimeout: () {
  //     Alerts.snackBarGetx(title: "Reset Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   }).onError((error, stackTrace) {
  //     Alerts.snackBarGetx(title: "Reset Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
  //     returnVal = false;
  //   });
  //   isLoading.value = false;
  //   return returnVal;
  // }
}
