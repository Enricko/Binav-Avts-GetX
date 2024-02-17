import 'package:binav_avts_getx/pages/auth/login.dart';
import 'package:binav_avts_getx/pages/auth/reset_password.dart';
import 'package:binav_avts_getx/pages/auth/reset_password_success.dart';
import 'package:binav_avts_getx/pages/auth/send_otp.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/auth.dart';
import '../utils/intro_screen.dart';
import 'auth/forget_password.dart';

class Caraousel {
  var currentIndex;
  var screenList;

  Caraousel({
    this.currentIndex,
    this.screenList,
  });
}

class LoginPage extends StatelessWidget {
  var controller = Get.find<AuthController>();
  var listWidget = {
    "login": LoginWidget(controller: Get.find<AuthController>()),
    "forget-password": ForgetPasswordWidget(controller: Get.find<AuthController>()),
    "send-otp": SendOtpWidget(controller: Get.find<AuthController>()),
    "reset-password": ResetPasswordWidget(controller: Get.find<AuthController>()),
    "reset-success": ResetPasswordSuccessWidget(controller: Get.find<AuthController>()),
  };

  var introPages = Caraousel(currentIndex: 0, screenList: [
    const IntroScreen(
      title: "Identifikasi Kapal",
      description: "Kemudahan dalam mengakses informasi terkait Identitas dan Lokasi Kapal.",
      imageAsset: AssetImage("assets/intro1.jpg"),
    ),
    const IntroScreen(
      title: "Pelacakan Real Time",
      description: "Efisiensi dalam mengetahui Koordinat kapal secara Real Time pada peta.",
      imageAsset: AssetImage("assets/intro2.jpg"),
    ),
    const IntroScreen(
      title: "Optimalisasi",
      description: "Pengoptimalan Rute dan operasi Kapal dengan data yang akurat tentang pergerakan kapal.",
      imageAsset: AssetImage("assets/intro3.jpg"),
    ),
  ]).obs;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "AVTS - Automated Vessel Tracking System",
          style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E286C),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to the desired color
        ),
      ),
      body: Row(
        children: [
          width <= 540
              ? Container()
              : SizedBox(
                  width: width / 2,
                  height: double.infinity,
                  child: Obx(
                    () => Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            viewportFraction: 1.0,
                            autoPlayInterval: Duration(seconds: 5),
                            aspectRatio: 16 / 9,
                            // enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              introPages.update((val) {
                                introPages.value.currentIndex = index;
                              });
                            },
                          ),
                          items: introPages.value.screenList,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: DotsIndicator(
                              dotsCount: introPages.value.screenList.length,
                              position: introPages.value.currentIndex,
                              decorator: const DotsDecorator(
                                color: Colors.grey,
                                activeColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          SingleChildScrollView(
            child: Container(
              width: width <= 540 ? width : width / 2,
              padding: const EdgeInsets.all(30),
              child: Obx(
                () {
                  return listWidget[controller.currentWidget.value]!;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
