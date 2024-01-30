import 'package:binav_avts_getx/controller/auth_check.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../utils/alerts.dart';

class AuthMiddleware extends GetMiddleware {
  // @override
  // // TODO: implement priority
  // int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    var box = GetStorage();
    if (box.read("userToken") != null) {
      if (!JwtDecoder.isExpired(box.read("userToken"))) {
        if (route == "/login") {
          return const RouteSettings(name: "/home");
        }
      } else if (route != "/login") {
        box.remove("userToken");
        Alerts.snackBarGetx(
            title: "Authentication", message: "Authentication Expired.", alertStatus: AlertStatus.DANGER);
        return const RouteSettings(name: "/login");
      }
    } else {
      if (route != "/login") {
        Alerts.snackBarGetx(title: "Authentication", message: "Please login first.", alertStatus: AlertStatus.DANGER);
        return const RouteSettings(name: "/login");
      }
    }
    return null;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    // TODO: implement onBindingsStart
    return super.onBindingsStart(bindings);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    // TODO: implement onPageBuildStart
    return super.onPageBuildStart(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    // TODO: implement onPageBuilt
    return super.onPageBuilt(page);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // TODO: implement onPageCalled
    return super.onPageCalled(page);
  }

  @override
  void onPageDispose() {
    // TODO: implement onPageDispose
    super.onPageDispose();
  }

  // @override
  // RouteSettings? redirect(String? route) {
  //   // var box = GetStorage();
  //   // // TODO: implement redirect
  //   // if(box.read("userToken") != null){
  //   //   if(!JwtDecoder.isExpired(box.read("userToken"))){
  //   //     // return RouteSettings(name: "/login");
  //   //   }
  //   // }
  //   return RouteSettings(name: "/login");
  // }
}
