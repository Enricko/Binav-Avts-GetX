import 'dart:convert';
import 'dart:math' as math;

import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MapGetXController extends GetxController {
  // MapGetXController({required this.context});
  // late BuildContext context;

  late final MapController mapController;
  Rx<LatLng?> latLng = Rx<LatLng?>(null);

  final pointSize = 50.0.obs;
  final pointY = 75.0.obs;

  var currentZoom = 15.0.obs;

  Rx<StreamSocket> streamSocket = StreamSocket().obs;

  @override
  void onInit() {
    super.onInit();
    try {
      mapController = MapController();
      connectAndListen();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePoint(null);
      });
    } catch (e) {
      print(e);
    }
  }

  void connectAndListen() {
    print("asdasdasd");
    IO.Socket socket = IO.io('http://127.0.0.1:5000/', IO.OptionBuilder().setTransports(['websocket']).build());
    // IO.Socket socket = IO.io('http://127.0.0.1:5000/', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    // });

    socket.onConnect((_) {
      print('connect');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('kapal_coor', (data) {
      try {
        // print('Received kapal_coor event: ${data.toString()}');
        // Do something with the received data, for example:
        // updateState(data);
        var response = GetKapalCoor.fromJson(data);

        streamSocket.value.addResponse(response);
      } catch (e) {
        print(e);
      }
    });
    // socket.on('kapal_coor', (data) => streamSocket.value.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }

  void updatePoint(MapEvent? event) {
    const pointX = 40;
    latLng.value = mapController.camera.pointToLatLng(math.Point(pointX, pointY.value));
  }
}
