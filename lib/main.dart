import 'package:binav_avts_getx/routes/page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/login",
      getPages: PageRouteList.pages,
    );
  }
}

class Counter {
  var count;

  Counter({this.count});
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var counter = Counter(count: 0).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            return Text("${counter.value.count}");
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        counter.update((val) {
          counter.value.count += 1;
        });
      }),
    );
  }
}
