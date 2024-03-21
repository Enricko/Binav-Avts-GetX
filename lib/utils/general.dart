import 'package:intl/intl.dart';

class General{
  static bool isApiOk(int status){
    if(status >= 200 && status < 300){
      return true;
    }
    return false;
  }
  static var numberFormat = NumberFormat.decimalPattern('en_US');
}