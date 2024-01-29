import 'package:binav_avts_getx/pages/auth/forget_password.dart';
import 'package:binav_avts_getx/utils/alerts.dart';
import 'package:binav_avts_getx/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/auth/login.dart';
import '../services/auth.dart';

class AuthController extends GetxController {
  var currentWidget = "login".obs;

  var invisible = true.obs;
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   // emailController = TextEditingController();
  //   // passwordController = TextEditingController();
  //   // passwordConfirmationController = TextEditingController();
  //   // otpController = TextEditingController();
  //   print("INIT");
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   print("DISPOSE");
  // }

  void changeWidget(String nameWidget) {
    currentWidget.value = nameWidget;
  }

  Future<bool> login() async {
    bool returnVal = false;
    isLoading.value = true;
    await AuthService().login(emailController.text, passwordController.text).then((value) {
      if (General.isApiOk(value.status!)) {
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
    await AuthService().resetPassword(emailController.text, otpController.text,passwordController.text,passwordConfirmationController.text).then((value) {
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
