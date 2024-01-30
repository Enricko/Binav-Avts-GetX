import 'package:binav_avts_getx/controller/auth.dart';
import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/middleware/authentication.dart';
import 'package:binav_avts_getx/pages/home.dart';
import 'package:binav_avts_getx/pages/login_page.dart';
import 'package:binav_avts_getx/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRouteList {
  // PageRouteList({required this.context});
  // final BuildContext context;
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => LoginPage(),
      binding: BindingsBuilder((){
        Get.put<AuthController>(AuthController());
      }),
      middlewares: [
        AuthMiddleware()
      ],
    ),
    GetPage(
      name: RouteName.home,
      page: () => HomePage(),
      binding: BindingsBuilder((){
        Get.put(MapGetXController());
      }),
      middlewares: [
        AuthMiddleware()
      ],
    ),
  ];
}