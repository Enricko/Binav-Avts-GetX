import 'package:binav_avts_getx/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordWidget extends StatelessWidget {
  ForgetPasswordWidget({super.key, required this.controller});
  final AuthController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              controller.currentWidget.value = "login";
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
          "Forgot your Password ?",
          style: GoogleFonts.roboto(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Enter your email below, and we'll send an email with confirmation to reset your password",
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
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The Email field is required.";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
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
            Container(
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text(
                  "Send Code",
                  style: TextStyle(
                    color: Colors.white,
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
