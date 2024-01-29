import 'dart:convert';

import 'package:binav_avts_getx/pages/auth/forget_password.dart';
import 'package:binav_avts_getx/services/auth.dart';
import 'package:binav_avts_getx/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key, required this.controller});
  final AuthController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Hai Welcome to Binav AVTS\n"
            "Log in to your Account",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 100),
          ),
          Column(
            children: [
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      TextFormField(
                        autofillHints: [AutofillHints.email],
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
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          // hintStyle: Constants.hintStyle,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                          filled: true,
                          fillColor: Color(0x0f2f2f2f),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofillHints: [AutofillHints.password],
                        keyboardType: TextInputType.text,
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.next,
                        obscureText: controller.invisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "The Password field is required.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon((controller.invisible.value == true)
                                ? Icons.visibility_outlined
                                : Icons.visibility_off),
                            onPressed: () {
                              controller.invisible.value = !controller.invisible.value;
                            },
                          ),
                          // hintStyle: Constants.hintStyle,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          enabledBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                          errorBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                          focusedErrorBorder:
                              const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                          filled: true,
                          fillColor: const Color(0x0f2f2f2f),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.currentWidget.value = "forget-password";
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
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
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            controller.login();
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
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
