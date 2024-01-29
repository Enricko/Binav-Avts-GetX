import 'dart:async';

import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

// STEP1:  Stream setup
class StreamSocket {
  StreamController<GetKapalCoor> _socketResponse = StreamController<GetKapalCoor>();

  // void Function(GetKapalCoor) get addResponse => _socketResponse.sink.add;

  Stream<GetKapalCoor> get getResponse => _socketResponse.stream;
  void addResponse(GetKapalCoor response) {
    // Parse the data and convert it to a list of KapalCoor objects
    // List<KapalCoor> kapalData = response.map((item) => KapalCoor.fromJson(item)).toList();

    _socketResponse.sink.add(response);
  }

  void dispose() {
    _socketResponse.close();
  }
}
