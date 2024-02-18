
import 'package:flutter/material.dart';

import '../../controller/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.controller});
  final ProfileController controller;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return  Container(
      height: height - 130,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: CircleAvatar(
                  child: Text(
                    controller.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 30),
                  ),
                  radius: 50,
                )),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   "K",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Text(controller.email),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                controller.currentWidget.value = "send_change_pass";
                // context.read<ProfileWidgetBloc>().add(ChangePassword());
              },
              title: Text("Change Password"),
              trailing: Icon(Icons.key),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                controller.currentWidget.value = "log_out";
                // context.read<ProfileWidgetBloc>().add(LogOut());
              },
              title: Text("Log Out"),
              trailing: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
}}
