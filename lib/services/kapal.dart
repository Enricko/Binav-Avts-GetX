import 'dart:async';

import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/model/get_kapal_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

class StreamSocketKapal {
  StreamController<GetKapalCoor> socketResponseAllKapal = StreamController<GetKapalCoor>();

  StreamController<GetKapalCoor> socketResponseSingleKapal = StreamController<GetKapalCoor>();

  Stream<GetKapalCoor> get getResponseAll => socketResponseAllKapal.stream;
  void addResponseAll(GetKapalCoor response) {
    socketResponseAllKapal.sink.add(response);
  }

  Stream<GetKapalCoor> get getResponseSingle => socketResponseSingleKapal.stream;
  void addResponseSingle(GetKapalCoor response) {
    socketResponseSingleKapal.sink.add(response);
  }

  Future<void> refreshSingleKapal() async {
    await socketResponseSingleKapal.close();

    socketResponseSingleKapal = StreamController<GetKapalCoor>();
  }

  void dispose() {
    socketResponseAllKapal.close();
    socketResponseSingleKapal.close();
  }
}

class KapalService extends GetConnect {
  // Future<Response> getUser() => get("http://127.0.0.1:5000/api/client");

  Future<GetKapalResponse> getData(String token, int page, int perpage) async {
    var response = await get("${InitService.baseUrlApi}/kapal?page=$page&per_page=$perpage", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetKapalResponse.fromJson(response.body);
  }
}
