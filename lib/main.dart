import 'dart:ui';

import 'package:binav_avts_getx/pages/login_page.dart';
import 'package:binav_avts_getx/pages/not_found.dart';
import 'package:binav_avts_getx/routes/page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'routes/route_name.dart';

void main() async {
  await GetStorage.init();
  await dotenv.load(fileName: "env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print("Token : ${JwtDecoder.isExpired("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwNjUxOTMzMiwianRpIjoiYjg2YTVhOTUtN2EyMS00YjdhLWI3ODctNTNlMTExOTkxM2ViIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IktIcm82T1E2azlXNWpuQ21EZ0p5ZHo4dVlUYVhkcnpWbWZiIiwibmJmIjoxNzA2NTE5MzMyLCJjc3JmIjoiYzViZjM3M2ItMjM5Zi00MGZlLWJmNjgtZmQ1YTZiNjMyYzk4IiwiZXhwIjoxNzA2NjkyMTMyfQ.Fh0JWQmSPy9l0eoMrQbVIYq3i6Y7oMKpsNQtzvM95m8")}");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Binav Avts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          fontFamily: 'Helvetica'
      ),
      unknownRoute: GetPage(
        name: RouteName.notFound,
        page: () => NotFound(),
      ),
      initialRoute: '/login',
      getPages: PageRouteList.pages,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
    );
  }
}
