import 'dart:async';

import 'package:binav_avts_getx/model/get_pipeline_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

class StreamSocketPipeline {
  StreamController<GetPipelineResponse> socketResponseAll =
      StreamController<GetPipelineResponse>();

  StreamController<GetPipelineResponse> socketResponseSingle =
      StreamController<GetPipelineResponse>();

  // void Function(GetPipelineResponse) get addResponse => socketResponse.sink.add;

  Stream<GetPipelineResponse> get getResponseAll => socketResponseAll.stream;

  void addResponseAll(GetPipelineResponse response) {
    socketResponseAll.sink.add(response);
  }

  Stream<GetPipelineResponse> get getResponseSingle =>
      socketResponseSingle.stream;

  void addResponseSingle(GetPipelineResponse response) {
    socketResponseSingle.sink.add(response);
  }

  Future<void> refreshSingleKapal() async {
    await socketResponseSingle.close();

    socketResponseSingle = StreamController<GetPipelineResponse>();
  }

  void dispose() {
    socketResponseAll.close();
    socketResponseSingle.close();
  }
}

class PipelineService extends GetConnect {
  // Future<Response> getUser() => get("http://127.0.0.1:5000/api/client");

  Future<GetPipelineResponse> getData(
      String token, int page, int perpage) async {
    var response = await get(
        "${InitService.baseUrlApi}mapping?page=$page&per_page=$perpage",
        headers: {
          "Authorization": "Bearer " + token,
        });
    return GetPipelineResponse.fromJson(response.body);
  }

  Future<GetPipelineResponse> getDataByID(
      String token, String idMapping) async {
    var response =
        await get("${InitService.baseUrlApi}mapping/$idMapping", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetPipelineResponse.fromJson(response.body);
  }

  Future<GetPipelineResponse> addData(
      String token, Map<String, dynamic> data) async {
    final body = FormData({
      "name": data['name'],
      "id_client": data['id_client'],
      "status": data['status'],
      data['file'] != null ? "file" : data['file']: null
    });

    var response =
        await post("${InitService.baseUrlApi}mapping", body, headers: {
      "Authorization": "Bearer " + token,
    });
    return GetPipelineResponse.fromJson(response.body);
  }

  Future<GetPipelineResponse> editData(
      String token, String idMapping, Map<String, dynamic> data) async {
    final body = FormData({
      "name": data['name'],
      "status": data['status'],
      data['file'] != null ? "file" : data['file'] : null,
      // "file": data['file'],
    });
    var response = await put(
        "${InitService.baseUrlApi}mapping/$idMapping", body,
        headers: {
          "Authorization": "Bearer " + token,
        });
    return GetPipelineResponse.fromJson(response.body);
  }

  Future<GetPipelineResponse> deleteData(String token, String idMapping) async {
    var response =
        await delete("${InitService.baseUrlApi}mapping/$idMapping", headers: {
      "Authorization": "Bearer " + token,
    });
    return GetPipelineResponse.fromJson(response.body);
  }
}
