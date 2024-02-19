import 'dart:async';

import 'package:binav_avts_getx/controller/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

//
// class SendChangePassword extends StatefulWidget {
//   const SendChangePassword({Key? key}) : super(key: key);
//
//   @override
//   State<SendChangePassword> createState() => _SendChangePasswordState();
// }
//
// class _SendChangePasswordState extends State<SendChangePassword> {
//   TextEditingController OldPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   bool isChangePassword = false;
//   bool invisibleOldPass = true;
//   bool invisibleNewPass = true;
//   bool invisibleConfirmPass = true;
//   bool ignorePointer = false;
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Container(
//         height: height - 130,
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                     child: SvgPicture.asset(
//                   "assets/vector2.svg",
//                   height: 200,
//                 )),
//                 Text(
//                   "Change Password ",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "Old Password ",
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87),
//                 ),
//                 TextFormField(
//                   controller: OldPasswordController,
//                   obscureText: invisibleOldPass,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value == "") {
//                       return "The Old Password field is required.";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.all(10),
//                       suffixIcon: IconButton(
//                         icon: Icon((invisibleOldPass == true)
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           setState(() {
//                             invisibleOldPass = !invisibleOldPass;
//                           });
//                         },
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide:
//                             BorderSide(width: 1, color: Colors.blueAccent),
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       disabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       errorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       focusedErrorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       filled: true,
//                       fillColor: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Divider(),
//                 Text(
//                   "New Password ",
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87),
//                 ),
//                 TextFormField(
//                   controller: newPasswordController,
//                   obscureText: invisibleNewPass,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value == "") {
//                       return "The New Password field is required.";
//                     }
//                     return null;
//                   },
//                   // obscuringCharacter: "\u2022",
//                   decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.all(10),
//                       suffixIcon: IconButton(
//                         icon: Icon((invisibleNewPass == true)
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           setState(() {
//                             invisibleNewPass = !invisibleNewPass;
//                           });
//                         },
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide:
//                             BorderSide(width: 1, color: Colors.blueAccent),
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       disabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       errorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       focusedErrorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       filled: true,
//                       fillColor: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   "Confirm Password ",
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87),
//                 ),
//                 TextFormField(
//                   controller: confirmPasswordController,
//                   obscureText: invisibleConfirmPass,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value == "") {
//                       return "The Password field is required.";
//                     }
//                     if (value != newPasswordController.text) {
//                       return "Confirm Password does not match.";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         icon: Icon((invisibleConfirmPass == true)
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           setState(() {
//                             invisibleConfirmPass = !invisibleConfirmPass;
//                           });
//                         },
//                       ),
//                       contentPadding: const EdgeInsets.all(10),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide:
//                             BorderSide(width: 1, color: Colors.blueAccent),
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       disabledBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black38)),
//                       errorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       focusedErrorBorder: const OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.redAccent)),
//                       filled: true,
//                       fillColor: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 IgnorePointer(
//                   ignoring: ignorePointer,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           height: 40,
//                           child: OutlinedButton(
//                               onPressed: () {
//                                 // context.read<ProfileWidgetBloc>().add(Profile());
//                               },
//                               child: Text("Cancel")),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 40,
//                           child: ElevatedButton(
//                               style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.blue)),
//                               onPressed: () {
//                                 // if (_formKey.currentState!.validate()) {
//                                 //   // Prevent Multiple Clicked
//                                 //   setState(() {
//                                 //     ignorePointer = true;
//                                 //     Timer(const Duration(seconds: 3), () {
//                                 //       setState(() {
//                                 //         ignorePointer = false;
//                                 //       });
//                                 //     });
//                                 //   });
//                                 //   EasyLoading.show(status: "Loading...");
//                                 //   var data = {
//                                 //     "old_password": OldPasswordController.text,
//                                 //     "new_password": newPasswordController.text,
//                                 //     "password_confirmation":
//                                 //         confirmPasswordController.text
//                                 //   };
//                                 //   UserDataService()
//                                 //       .changePassword(
//                                 //           token: (state is UserSignedIn)
//                                 //               ? state.user.token!
//                                 //               : "",
//                                 //           data: data)
//                                 //       .then((value) {
//                                 //     if (value.message ==
//                                 //         "Password has changed successful!") {
//                                 //       EasyLoading.showSuccess(value.message!,
//                                 //           duration: const Duration(seconds: 3),
//                                 //           dismissOnTap: true);
//                                 //       Navigator.pop(context);
//                                 //     } else {
//                                 //       EasyLoading.showError(value.message!,
//                                 //           duration: const Duration(seconds: 3),
//                                 //           dismissOnTap: true);
//                                 //     }
//                                 //   }).whenComplete(() {
//                                 //     Timer(const Duration(seconds: 5), () {
//                                 //       EasyLoading.dismiss();
//                                 //     });
//                                 //   });
//                                 // }
//                               },
//                               child: Text("Submit")),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//   }
// }

class SendChangePassword extends StatelessWidget {
  SendChangePassword({super.key, required this.controller});

  final ProfileController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Obx(() => Container(
          height: height - 130,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    "assets/vector2.svg",
                    height: 200,
                  )),
                  Text(
                    "Change Password ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Old Password ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  TextFormField(
                    controller: controller.OldPasswordController,
                    obscureText: controller.invisibleOldPass.value,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The Old Password field is required.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon((controller.invisibleOldPass.value == true)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off),
                          onPressed: () {
                            controller.invisibleOldPass.value =
                                !controller.invisibleOldPass.value;
                            // setState(() {
                            //   invisibleOldPass = !invisibleOldPass;
                            // });
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Text(
                    "New Password ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: controller.invisibleNewPass.value,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The New Password field is required.";
                      }
                      return null;
                    },
                    // obscuringCharacter: "\u2022",
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon((controller.invisibleNewPass.value == true)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off),
                          onPressed: () {
                            // setState(() {
                            //   invisibleNewPass = !invisibleNewPass;
                            // });
                            controller.invisibleNewPass.value =
                                !controller.invisibleNewPass.value;
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Confirm Password ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.invisibleConfirmPass.value,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "The Password field is required.";
                      }
                      if (value != controller.newPasswordController.text) {
                        return "Confirm Password does not match.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              (controller.invisibleConfirmPass.value == true)
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off),
                          onPressed: () {
                            controller.invisibleConfirmPass.value =
                                !controller.invisibleConfirmPass.value;
                            // setState(() {
                            //   invisibleConfirmPass = !invisibleConfirmPass;
                            // });
                          },
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.redAccent)),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IgnorePointer(
                    ignoring: controller.ignorePointer.value,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    side: MaterialStateProperty.all(
                                        BorderSide(color: Colors.red))),
                                onPressed: () {
                                  controller.currentWidget.value =
                                      "profile_page";
                                  // context.read<ProfileWidgetBloc>().add(Profile());
                                },
                                child: Text("Cancel")),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                onPressed:
                                controller.isLoading.value
                                ? null
                                : () async {
                          if (_formKey.currentState!.validate()) {
                          await controller.changepassword()
                              .then((value) async {
                          if (value) {
                            controller.currentWidget.value =
                            "profile_page";
                          }
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
                                  :
                              Text("Submit")),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
