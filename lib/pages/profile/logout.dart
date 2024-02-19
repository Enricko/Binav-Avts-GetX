import 'package:binav_avts_getx/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/auth.dart';
import '../../controller/profile.dart';
class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key, required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.exit_to_app,
                    size: 64,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Do You Wanna Log Out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            // context.read<ProfileWidgetBloc>().add(Profile());
                            controller.currentWidget.value = "profile_page";
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.red)),
                          ),
                          child: Text("Cancel",style: TextStyle(color: Colors.red),),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 10,
                      ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed:  controller.isLoading.value
                              ? null
                              : () async {
                              await controller.logout()
                                  .then((value) async {
                                    print(value);
                                if (value) {
                                  // Get.put(AuthController());
                                  Get.offAllNamed("/login");
                                  // Get.offAll(LoginPage());
                                }
                              });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child:
                          controller.isLoading.value
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
                              :
                          Text("Logout"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
  }
}
