import 'package:binav_avts_getx/model/get_user_response.dart' as getUser;
import 'package:binav_avts_getx/services/auth.dart';
import 'package:binav_avts_getx/utils/general.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/alerts.dart';

class AuthCheck extends GetxController {
  Future<void> checkUser() async {
    var box = GetStorage();
    if (box.read("userToken") != null) {
      await AuthService().checkUser(box.read("userToken") as String).then((value) {
        if (General.isApiOk(value.status!)) {
          box.write("user", value.data);
          box.write("isLogin", true);
          Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.SUCCESS);
        } else {
          box.write("isLogin", false);
          Alerts.snackBarGetx(title: "Authentication", message: value.message!, alertStatus: AlertStatus.DANGER);
        }
        return null;
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        box.write("isLogin", false);
        Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      }).onError((error, stackTrace) {
        box.write("isLogin", false);
        Alerts.snackBarGetx(title: "Authentication", message: "Try Again Later...", alertStatus: AlertStatus.DANGER);
      });
    } else {
      box.write("isLogin", false);
      Alerts.snackBarGetx(title: "Authentication", message: "Please login first.", alertStatus: AlertStatus.DANGER);
    }
  }

  @override
  void onInit() {
    checkUser();
    super.onInit();
  }
}
