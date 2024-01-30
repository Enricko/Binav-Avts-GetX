import 'dart:async'; 

import 'package:binav_avts_getx/model/get_mapping_response.dart';


class StreamSocketMapping {
  StreamController<GetMappingResponse> socketResponseAll = StreamController<GetMappingResponse>();

  StreamController<GetMappingResponse> socketResponseSingle = StreamController<GetMappingResponse>();

  // void Function(GetMappingResponse) get addResponse => socketResponse.sink.add;

  Stream<GetMappingResponse> get getResponseAll => socketResponseAll.stream;
  void addResponseAll(GetMappingResponse response) {
    socketResponseAll.sink.add(response);
  }
  Stream<GetMappingResponse> get getResponseSingle => socketResponseSingle.stream;
  void addResponseSingle(GetMappingResponse response) {
    socketResponseSingle.sink.add(response);
  }

  Future<void> refreshSingleKapal()async{
    await socketResponseSingle.close();

    socketResponseSingle = StreamController<GetMappingResponse>();
  }

  void dispose() {
    socketResponseAll.close();
    socketResponseSingle.close();
  }
}
