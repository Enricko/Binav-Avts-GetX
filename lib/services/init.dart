import 'package:flutter_dotenv/flutter_dotenv.dart';

class InitService{
  static final baseUrl = dotenv.env['BASE_URL'];
  static final baseUrlApi = "${baseUrl}api/";
}