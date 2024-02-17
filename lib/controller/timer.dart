import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;

  void startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        _timer!.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value = minutes.toString().padLeft(2, "0") + ":" + seconds.toString().padLeft(2, "0");
        remainSeconds--;
      }
    });
  }

  // @override
  // void onReady() {
  //   startTimer(900);
  //   super.onReady();
  // }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }
}
