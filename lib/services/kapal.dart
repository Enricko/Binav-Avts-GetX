import 'dart:async';

import 'package:binav_avts_getx/model/get_ip_vessel.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/model/get_kapal_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

import '../model/get_kapal_latlong_response.dart';

class StreamSocketKapal {
  StreamController<GetKapalCoor> socketResponseAllKapal = StreamController<GetKapalCoor>();

  StreamController<GetKapalCoor> socketResponseSingleKapal = StreamController<GetKapalCoor>();

  StreamController<GetKapalLatlongResponse> socketResponseSingleKapalLatlong =
      StreamController<GetKapalLatlongResponse>();

  Stream<GetKapalCoor> get getResponseAll => socketResponseAllKapal.stream;
  void addResponseAll(GetKapalCoor response) {
    socketResponseAllKapal.sink.add(response);
  }

  Stream<GetKapalCoor> get getResponseSingle => socketResponseSingleKapal.stream;
  void addResponseSingle(GetKapalCoor response) {
    socketResponseSingleKapal.sink.add(response);
  }

  Stream<GetKapalLatlongResponse> get getResponseSingleLatlong =>
      socketResponseSingleKapalLatlong.stream;
  void addResponseSingleLatlong(GetKapalLatlongResponse response) {
    socketResponseSingleKapalLatlong.sink.add(response);
  }

  Future<void> refreshSingleKapal() async {
    await socketResponseSingleKapal.close();

    socketResponseSingleKapal = StreamController<GetKapalCoor>();
    socketResponseSingleKapalLatlong = StreamController<GetKapalLatlongResponse>();
  }

  void dispose() {
    socketResponseAllKapal.close();
    socketResponseSingleKapal.close();
    socketResponseSingleKapalLatlong.close();
  }
}

class KapalService extends GetConnect {
  // Future<Response> getUser() => get("http://127.0.0.1:5000/api/client");

  Future<GetKapalResponse> getData(String token, int page, int perpage) async {
    var response =
        await get("${InitService.baseUrlApi}kapal?page=$page&per_page=$perpage", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }

  Future<GetKapalResponse> getDataByID(String token, String callSign) async {
    var response = await get("${InitService.baseUrlApi}kapal/$callSign", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }

  Future<GetKapalResponse> deleteData(String token, String callSign) async {
    var response = await delete("${InitService.baseUrlApi}kapal/$callSign", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }

  Future<GetKapalResponse> addData(String token, Map<String, dynamic> data) async {
    final body = FormData({
      "call_sign": data['call_sign'],
      "id_client": data['id_client'],
      "flag": data['flag'],
      "kelas": data['kelas'],
      "builder": data['builder'],
      "year_built": data['year_built'],
      "size": data['size'],
      "status": data['status'],
      "xml_file": data['xml_file'],
    });
    var response = await post("${InitService.baseUrlApi}kapal", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }

  Future<GetKapalResponse> updateData(
      String token, String callSign, Map<String, dynamic> data) async {
    final body = FormData({
      "new_call_sign": data['new_call_sign'],
      "flag": data['flag'],
      "kelas": data['kelas'],
      "builder": data['builder'],
      "year_built": data['year_built'],
      "size": data['size'],
      "status": data['status'],
      "xml_file": data['xml_file'],
    });
    var response = await put("${InitService.baseUrlApi}kapal/$callSign", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }

  Future<GetIpVessel> getIpVessel(String token, String call_sign) async {
    var response = await get("${InitService.baseUrlApi}ip_kapal/${call_sign}", headers: {
      "Authorization": "Bearer " + token,
    });
    print(response.body);
    return GetIpVessel.fromJson(response.body);
  }

  Future<GetKapalResponse> addIpVessel(
    String token,
    String call_sign,
    Map<String, dynamic> data,
  ) async {
    final body = FormData({
      "type_ip": data['type_ip'],
      "ip": data['ip'],
      "port": data['port'],
    });
    var response = await post("${InitService.baseUrlApi}ip_kapal/${call_sign}", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }
}
