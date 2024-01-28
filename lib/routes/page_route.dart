import 'package:binav_avts_getx/pages/login_page.dart';
import 'package:binav_avts_getx/routes/route_name.dart';
import 'package:get/get.dart';

class PageRouteList {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => LoginPage(),
    ),
  ];
}
