import 'dart:convert';

import 'package:binav_avts_getx/model/get_user_response.dart';
import 'package:binav_avts_getx/model/logout_response.dart';
import 'package:binav_avts_getx/pages/profile/logout.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

import '../model/login_response.dart';

class AuthService extends GetConnect {
  Future<GetUserResponse> checkUser(String token) async {
    var response = await get("${InitService.baseUrlApi}user", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetUserResponse.fromJson(response.body);
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final body = FormData({
        "email": email,
        "password": password,
      });
      var response = await post(
          "${InitService.baseUrlApi}login", body);
      return LoginResponse.fromJson(response.body);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<LoginResponse> sendOtp(String email) async {
    final body = FormData({
      "email": email,
    });
    var response = await post("${InitService.baseUrlApi}forgot-password", body);
    return LoginResponse.fromJson(response.body);
  }

  Future<LoginResponse> checkOtp(String email, String otpCode) async {
    final body = FormData({
      "email": email,
      "otp_code": otpCode,
    });
    var response = await post("${InitService.baseUrlApi}check-code", body);
    return LoginResponse.fromJson(response.body);
  }

  Future<LoginResponse> resetPassword(String email, String otpCode,
      String password, String passwordConfirmation) async {
    final body = FormData({
      "email": email,
      "otp_code": otpCode,
      "password": password,
      "password_confirmation": passwordConfirmation,
    });
    var response = await post("${InitService.baseUrlApi}reset-password", body);
    return LoginResponse.fromJson(response.body);
  }

  Future<LoginResponse> changePassword(String oldpassword, String newpassword, String confirmpassword) async {
    try {
      final body = FormData({
        "old_password": oldpassword,
        "new_password": newpassword,
        "password_confirmation": confirmpassword,
      });
      var response = await post(
          "${InitService.baseUrlApi}change", body);
      return LoginResponse.fromJson(response.body);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  Future<LogoutResponse> logout(String token) async {
    var response = await delete("${InitService.baseUrlApi}/api/logout" ,headers: {
      "Authorization": "Bearer " + token,
    });
    return LogoutResponse.fromJson(response.body);
  }

}
