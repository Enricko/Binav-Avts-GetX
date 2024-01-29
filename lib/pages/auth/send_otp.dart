import 'dart:async';

import 'package:binav_avts_getx/controller/timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controller/auth.dart';

class SendOtpWidget extends StatelessWidget {
  SendOtpWidget({super.key, required this.controller});
  final AuthController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              controller.currentWidget.value = "forget-password";
            },
            child: Icon(Icons.arrow_back)),
        SizedBox(
          height: 15,
        ),
        Image.asset(
          "assets/logo.png",
          height: 40,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Add the Code",
          style: GoogleFonts.roboto(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "We have sent the code to ${controller.emailController.text}",
          style: GoogleFonts.roboto(fontSize: 15, color: Colors.black54),
        ),
        SizedBox(
          height: 40,
        ),
        Column(
          children: [
            Form(
              key: _formKey,
              child: PinCodeTextField(
                validator: (value) {
                  if (value == null || value.isEmpty || value == "") {
                    return "The OTP field is required.";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid Code';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                autoDisposeControllers: false,
                appContext: context,
                autoFocus: true,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                textInputAction: TextInputAction.next,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                onChanged: (value) {
                  // Handle OTP changes
                },
                onCompleted: (value) async {
                  if (_formKey.currentState!.validate()) {
                    await controller.checkOtp().then((value) {
                      if (value) controller.currentWidget.value = "reset-password";
                    });
                  }
                },
                controller: controller.otpController,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Make sure to check your Spam Folder",
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.black54),
            ),
            SizedBox(
              height: 5,
            ),
            GetX<TimerController>(
              init: TimerController(),
              initState: (con) {
                con.controller!.startTimer(60);
              },
              builder: (con) {
                return con.remainSeconds != 0
                    ? Text("Send Code Again 00:${con.time.value}")
                    : RichText(
                        text: TextSpan(
                          text: "No Message Received? ",
                          style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Resend Code',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  con.startTimer(60);
                                  await controller.sendOtp();
                                },
                            ),
                          ],
                        ),
                      );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Container(
                margin: const EdgeInsets.only(bottom: 25),
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF133BAD)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await controller.checkOtp().then((value) {
                              if (value) controller.currentWidget.value = "reset-password";
                            });
                          }
                        },
                  child: controller.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "Verification",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
