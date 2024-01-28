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

  Future<void> login(BuildContext context)async {
    isLoading.value = true;
    await AuthService().login(emailController.text, passwordController.text).then((value) {
      if(General.isApiOk(value.status!)){
        Alerts.snackBarGetx(title: "Authentication",message: value.message!,alertStatus: AlertStatus.SUCCESS);
      }else{
        Alerts.snackBarGetx(title: "Authentication",message: value.message!,alertStatus: AlertStatus.DANGER);
      }
    }).timeout(const Duration(seconds: 10),onTimeout: (){
        Alerts.snackBarGetx(title: "Authentication",message: "Try Again Later...",alertStatus: AlertStatus.DANGER);
    }).onError((error, stackTrace){
        Alerts.snackBarGetx(title: "Authentication",message: "Try Again Later...",alertStatus: AlertStatus.DANGER);
    });
    isLoading.value = false;
  }
}
