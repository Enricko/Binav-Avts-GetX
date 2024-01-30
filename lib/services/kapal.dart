import 'dart:async';

import 'package:binav_avts_getx/model/get_kapal_coor.dart';


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

  Future<void> refreshSingleKapal()async{
    await socketResponseSingleKapal.close();

    socketResponseSingleKapal = StreamController<GetKapalCoor>();
  }

  void dispose() {
    socketResponseAllKapal.close();
    socketResponseSingleKapal.close();
  }
}
