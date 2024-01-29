import 'dart:convert';

import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

import '../model/login_response.dart';

class AuthService extends GetConnect {
  // Future<Response> getUser() => get("http://127.0.0.1:5000/api/client");

  Future<LoginResponse> login(String email, String password) async {
    final body = FormData({
      "email": email,
      "password": password,
    });
    var response = await post("${InitService.baseUrl}login", body);
    return LoginResponse.fromJson(response.body); 
  }
  Future<LoginResponse> sendOtp(String email) async {
    final body = FormData({
      "email": email,
    });
    var response = await post("${InitService.baseUrl}forgot-password", body);
    return LoginResponse.fromJson(response.body); 
  }
  Future<LoginResponse> checkOtp(String email,String otpCode) async {
    final body = FormData({
      "email": email,
      "otp_code":otpCode,
    });
    var response = await post("${InitService.baseUrl}check-code", body);
    return LoginResponse.fromJson(response.body); 
  }
  Future<LoginResponse> resetPassword(String email,String otpCode,String password,String passwordConfirmation) async {
    final body = FormData({
      "email": email,
      "otp_code":otpCode,
      "password":password,
      "password_confirmation":passwordConfirmation,
    });
    var response = await post("${InitService.baseUrl}reset-password", body);
    return LoginResponse.fromJson(response.body); 
  }
}
