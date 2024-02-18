import 'package:binav_avts_getx/model/get_client_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

class ClientService extends GetConnect {
  Future<GetClientResponse> getData(String token, int page, int perpage) async {
    var response = await get("https://627b-140-213-58-125.ngrok-free.app/api/client?page=$page&per_page=$perpage", headers: {
      "Authorization": "Bearer " + token,
      'ngrok-skip-browser-warning': 'true'
    });
    return GetClientResponse.fromJson(response.body);
  }

  Future<GetClientResponse> getDataByID(String token, String idClient) async {
    var response = await get("${InitService.baseUrlApi}client/$idClient", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }

  Future<GetClientResponse> deleteData(String token, String idClient) async {
    var response = await delete("${InitService.baseUrlApi}client/$idClient", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }

  Future<GetClientResponse> sendEmailDetail(String token, String idClient) async {
    var response = await get("${InitService.baseUrlApi}client_email/$idClient", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }

  Future<GetClientResponse> addData(String token, Map<String, dynamic> data) async {
    final body = FormData({
      "name": data['name'],
      "email": data['email'],
      "status": data['status'],
      "password": data['password'],
      "password_confirmation": data['password_confirmation'],
    });
    var response = await post("${InitService.baseUrlApi}client", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }

  Future<GetClientResponse> updateData(String token, String idClient, Map<String, dynamic> data) async {
    final body = FormData({
      "name": data['name'],
      "email": data['email'],
      "status": data['status'],
    });
    var response = await put("${InitService.baseUrlApi}client/$idClient", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetClientResponse.fromJson(response.body);
  }
}
