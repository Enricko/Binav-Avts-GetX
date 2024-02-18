import 'package:flutter/material.dart';

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
                          onPressed: () {
                            // context.read<UserBloc>().add(SignOut());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text("Logout"),
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
