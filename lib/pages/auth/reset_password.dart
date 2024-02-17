import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth.dart';

class ResetPasswordWidget extends StatelessWidget {
  ResetPasswordWidget({super.key, required this.controller});
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
        Text(
          "Create New Password",
          style: GoogleFonts.roboto(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "this password should be different from the previous password",
          style: GoogleFonts.roboto(fontSize: 15, color: Colors.black38),
        ),
        SizedBox(
          height: 40,
        ),
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The Password field is required.";
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                      hintText: "Enter New Password",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      filled: true,
                      fillColor: Color(0x0f2f2f2f),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.passwordConfirmationController,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The Password Confirmation field is required.";
                      }
                      if (value != controller.passwordConfirmationController.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                      hintText: "Enter Confirm Password",
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                      errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder:
                          const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      filled: true,
                      fillColor: const Color(0x0f2f2f2f),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
           Obx(()=> Container(
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
                          await controller.resetPassword().then((value) {
                            if (value) controller.currentWidget.value = "reset-success";
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
                        "Reset Password",
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
