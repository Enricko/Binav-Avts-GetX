import 'dart:async';

import 'package:binav_avts/bloc/user/user_bloc.dart';
import 'package:binav_avts/services/user_dataservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController OldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isChangePassword = false;
  bool invisibleOldPass = true;
  bool invisibleNewPass = true;
  bool invisibleConfirmPass = true;
  bool ignorePointer = false;

  Timer? ignorePointerTimer;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    if(ignorePointerTimer != null){ignorePointerTimer!.cancel();}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return SizedBox(
        width: width / 3.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile Page",
                    style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            (isChangePassword)
                ? Container(
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
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                            TextFormField(
                              controller: OldPasswordController,
                              obscureText: invisibleOldPass,
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
                                    icon: Icon(
                                        (invisibleOldPass == true) ? Icons.visibility_outlined : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        invisibleOldPass = !invisibleOldPass;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                                  ),
                                  enabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  disabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  filled: true,
                                  fillColor: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            Text(
                              "New Password ",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                            TextFormField(
                              controller: newPasswordController,
                              obscureText: invisibleNewPass,
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
                                    icon: Icon(
                                        (invisibleNewPass == true) ? Icons.visibility_outlined : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        invisibleNewPass = !invisibleNewPass;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                                  ),
                                  enabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  disabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  filled: true,
                                  fillColor: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Confirm Password ",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: invisibleConfirmPass,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "The Password field is required.";
                                }
                                if (value != newPasswordController.text) {
                                  return "Confirm Password does not match.";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon((invisibleConfirmPass == true)
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        invisibleConfirmPass = !invisibleConfirmPass;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                                  ),
                                  enabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  disabledBorder:
                                      const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                                  filled: true,
                                  fillColor: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IgnorePointer(
                              ignoring: ignorePointer,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              isChangePassword = false;
                                            });
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
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              // Prevent Multiple Clicked
                                              setState(() {
                                                ignorePointer = true;
                                                ignorePointerTimer = Timer(const Duration(seconds: 3), () {
                                                  setState(() {
                                                    ignorePointer = false;
                                                  });
                                                });
                                              });
                                              EasyLoading.show(status: "Loading...");
                                              var data = {
                                                "old_password": OldPasswordController.text,
                                                "new_password": newPasswordController.text,
                                                "password_confirmation": confirmPasswordController.text
                                              };
                                              UserDataService()
                                                  .changePassword(
                                                      token: (state is UserSignedIn) ? state.user.token! : "",
                                                      data: data)
                                                  .then((value) {
                                                if (value.message == "Password has changed successful!") {
                                                  EasyLoading.showSuccess(value.message!,
                                                      duration: const Duration(seconds: 3), dismissOnTap: true);
                                                  Navigator.pop(context);
                                                } else {
                                                  EasyLoading.showError(value.message!,
                                                      duration: const Duration(seconds: 3), dismissOnTap: true);
                                                }
                                              }).whenComplete(() {
                                                Timer(const Duration(seconds: 5), () {
                                                  EasyLoading.dismiss();
                                                });
                                              });
                                            }
                                          },
                                          child: Text("Submit")),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: height - 130,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                              child: CircleAvatar(
                            child: Text(
                              (state is UserSignedIn) ? state.user.user!.name![0] : "",
                              style: TextStyle(fontSize: 30),
                            ),
                            radius: 50,
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            (state is UserSignedIn) ? state.user.user!.name! : "",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text((state is UserSignedIn) ? state.user.user!.email! : ""),
                          SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isChangePassword = true;
                              });
                            },
                            title: Text("Change Password"),
                            trailing: Icon(Icons.key),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      );
    });
  }
}
