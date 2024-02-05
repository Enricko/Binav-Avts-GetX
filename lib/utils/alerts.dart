import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

enum AlertStatus { SUCCESS, WARNING, DANGER, INFO, INSERT, UPDATE, DELETE }

class Alerts {
  static showMessage(String message, BuildContext context) {
    // print("item deleted!");
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 2),
      curve: Curves.elasticOut,
    );
  }

  static showAlert(String message, BuildContext context) {
    // print("item deleted!");
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 5),
      curve: Curves.elasticOut,
    );
  }

  static showAlertYesNo(
      {required String title,
      required VoidCallback onPressYes,
      required VoidCallback onPressNo,
      required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: SizedBox(
            height: 80,
            width: 80,
            child: Lottie.asset(
              'assets/lottie/animation_delete.json',
              fit: BoxFit.contain,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // judul
          title: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            // tombel yes
            SizedBox(
              width: 90,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: onPressYes,
                child: Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ),
            //tombol no
            SizedBox(
              width: 90,
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.black38,
                    ),
                  ),
                )),
                onPressed: onPressNo,
                child: Text('No', style: TextStyle(color: Colors.black38)),
              ),
            ),
          ],
        );
      },
    );
  }

  static showAlertYesNoConfirm(
      {required String title,
      required VoidCallback onPressYes,
      required VoidCallback onPressNo,
      required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: SizedBox(
            height: 80,
            width: 80,
            child: Lottie.asset(
              'assets/lottie/mail.json',
              fit: BoxFit.contain,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // judul
          title: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            // tombel yes
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                onPressed: onPressYes,
                child: Text('Send Mail', style: TextStyle(color: Colors.white)),
              ),
            ),
            //tombol no
            SizedBox(
              width: 90,
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.black38,
                    ),
                  ),
                )),
                onPressed: onPressNo,
                child: Text('No', style: TextStyle(color: Colors.black38)),
              ),
            ),
          ],
        );
      },
    );
  }

  static void loading(BuildContext context, bool isLoad) async {
    if (isLoad) {
      showDialog(
          barrierDismissible: false, //Don't close dialog when click outside
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(), //Loading Indicator you can use any graphic
                    SizedBox(
                      height: 20,
                    ),
                    Text('Loading...')
                  ],
                ),
              ),
            );
          });
    } else {
      Navigator.of(context).pop(); //Close the dialog
    }
  }

  static Future<void> snackBarGetx(
      {required String title, required String message, required AlertStatus alertStatus}) async {
    var color = {
      AlertStatus.SUCCESS: Colors.green,
      AlertStatus.INFO: Colors.blue,
      AlertStatus.WARNING: Colors.yellow,
      AlertStatus.DANGER: Colors.red,
      AlertStatus.INSERT: Colors.green,
      AlertStatus.UPDATE: Colors.yellow,
      AlertStatus.DELETE: Colors.red,
    };
    var icon = {
      AlertStatus.SUCCESS: Icons.check,
      AlertStatus.INFO: Icons.info,
      AlertStatus.WARNING: Icons.warning,
      AlertStatus.DANGER: Icons.dangerous,
      AlertStatus.INSERT: Icons.create,
      AlertStatus.UPDATE: Icons.system_update_alt,
      AlertStatus.DELETE: Icons.delete,
    };

    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      animationDuration: Duration(milliseconds: 200),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.white,
      borderColor: color[alertStatus],
      borderWidth: 4,
      borderRadius: 15,
      icon: Icon(
        icon[alertStatus],
        color: color[alertStatus],
        weight: 100,
        size: 42,
      ),
      maxWidth: 400,
      isDismissible: true,
      margin: EdgeInsets.only(top: 25, bottom: 25),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
