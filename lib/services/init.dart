import 'package:flutter_dotenv/flutter_dotenv.dart';

class InitService{
  static final baseUrl = "http://api.binav-avts.id:5000/";
  // static final baseUrl = "https://api.binav-avts.id:5000/";
  // static final baseUrl = dotenv.env['http://api.binav-avts.id:5000/'];
  // static final baseUrl = "https://627b-140-213-58-125.ngrok-free.app/";
  static final baseUrlApi = "${baseUrl}api/";
}