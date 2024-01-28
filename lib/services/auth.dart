import 'dart:convert';

import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

import '../model/login_response.dart';

class AuthService extends GetConnect {
  Future<void> fetchData() async {
    final response = await get('http://127.0.0.1:5000/api/client',
        headers: {"Access-Control-Allow-Origin": "*", 'Content-Type': 'application/json', 'Accept': '*/*'});
    if (response.status.hasError) {
      // Handle error
      print('Error: ${response.statusText}');
    } else {
      // Parse and handle successful response
      final responseData = response.body;
      print('Response: $responseData');
    }
    
  }

  Future<Response> getUser() => get("http://127.0.0.1:5000/api/client");

  Future<LoginResponse> login(String email, String password) async {
    final body = FormData({
      "email": email,
      "password": password,
    });
    var response = await post("${InitService.baseUrl}login", body);
    return LoginResponse.fromJson(response.body); 
  }
}
