import 'package:binav_avts_getx/utils/alerts.dart';
import 'package:binav_avts_getx/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth.dart';

class AuthController extends GetxController {
  var currentWidget = "login".obs;

  var invisible = true.obs;
  var isLoading = false.obs;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;
  late TextEditingController otpController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    otpController.dispose();
  }

  void changeWidget(String nameWidget) {
    currentWidget.value = nameWidget;
  }

  Future<bool> login() async {
    bool returnVal = false;
    isLoading.value = true;
    await AuthService().login(emailController.text, passwordController.text).then((value) async {
      if (General.isApiOk(value.status!)){
        await AuthService().checkUser(value.token!).then((val) {
          var box = GetStorage();
          box.write("email", "${val.data!.first.email}");
          box.write("name", "${val.data!.first.name}");
          Alerts.snackBarGetx(title: "Success", message: value.message!, alertStatus: AlertStatus.SUCCESS);
          box.write("userToken", "${value.token}");
          returnVal = true;
        });

      } else {
        Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }

  Future<bool> sendOtp() async {
    bool returnVal = false;
    isLoading.value = true;
    await AuthService().sendOtp(emailController.text).then((value) {
      if (General.isApiOk(value.status!)) {
        Alerts.snackBarGetx(title: "Forget Password", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        passwordController.clear();
        passwordConfirmationController.clear();
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Forget Password", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Forget Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Forget Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }

  Future<bool> checkOtp() async {
    bool returnVal = false;
    isLoading.value = true;
    await AuthService().checkOtp(emailController.text, otpController.text).then((value) {
      if (General.isApiOk(value.status!)) {
        Alerts.snackBarGetx(title: "Check OTP", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        passwordController.clear();
        passwordConfirmationController.clear();
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Check OTP", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Check OTP", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Check OTP", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }

  Future<bool> resetPassword() async {
    bool returnVal = false;
    isLoading.value = true;
    await AuthService()
        .resetPassword(
            emailController.text, otpController.text, passwordController.text, passwordConfirmationController.text)
        .then((value) {
      if (General.isApiOk(value.status!)) {
        Alerts.snackBarGetx(title: "Reset Password", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        otpController.clear();
        passwordController.clear();
        passwordConfirmationController.clear();
        returnVal = true;
      } else {
        Alerts.snackBarGetx(title: "Reset Password", message: value.message!, alertStatus: AlertStatus.DANGER);
        returnVal = false;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      Alerts.snackBarGetx(title: "Reset Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    }).onError((error, stackTrace) {
      Alerts.snackBarGetx(title: "Reset Password", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      returnVal = false;
    });
    isLoading.value = false;
    return returnVal;
  }
}
