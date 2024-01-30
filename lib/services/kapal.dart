
import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:get/get.dart';

import 'dart:async';

import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocketKapal {
  StreamController<GetKapalCoor> socketResponseAllKapal = StreamController<GetKapalCoor>();
  
  StreamController<GetKapalCoor> socketResponseSingleKapal = StreamController<GetKapalCoor>();

  // void Function(GetKapalCoor) get addResponse => socketResponse.sink.add;

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
