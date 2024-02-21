import 'dart:convert';
import 'dart:math' as math;

import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/model/get_kapal_latlong_response.dart';
import 'package:binav_avts_getx/services/init.dart';
import 'package:binav_avts_getx/services/kapal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/pipeline.dart';

class MapGetXController extends GetxController {
  // MapGetXController({required this.context});
  // late BuildContext context;

  late final MapController mapController;
  Rx<LatLng?> latLng = Rx<LatLng?>(null);

  final pointSize = 50.0.obs;
  final pointY = 75.0.obs;

  var currentZoom = 10.0.obs;

  var initialZoom = 10.0.obs;
  var initialCenter = Rx<LatLng>(LatLng(-1.089955, 117.360343));


  Rx<StreamSocketKapal> streamSocketKapal = StreamSocketKapal().obs;
  

  double vesselSizes(String size) {
    switch (size) {
      case "small":
        return 25.0;
      case "medium":
        return 50.0;
      case "large":
        return 100.0;
      case "extra_large":
        return 150.0;
      default:
        return 25.0;
    }
  }

  LatLng predictLatLong(double latitude, double longitude, double speed, double course, int movementTime) {
    // Convert course from degrees to radians
    double courseRad = degreesToRadians(course);
    // Convert speed from meters per minute to meters per second
    double speedMps = speed / 60.0;
    // Calculate the distance traveled in meters
    double distanceM = speedMps * movementTime;
    // Calculate the change in latitude and longitude
    double deltaLatitude = distanceM * math.cos(courseRad) / 111111.1;
    double deltaLongitude = distanceM * math.sin(courseRad) / (111111.1 * math.cos(degreesToRadians(latitude)));
    // Calculate the new latitude and longitude
    double newLatitude = latitude + deltaLatitude;
    double newLongitude = longitude + deltaLongitude;
    return LatLng(newLatitude, newLongitude);
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  void socketAllKapal() {
    IO.Socket socket = IO.io('${InitService.baseUrl}kapal', IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) => print('connect All'));

    socket.on('kapal_coor', (data) {
      var response = GetKapalCoor.fromJson(data);

      streamSocketKapal.value.addResponseAll(response);
    });
    socket.onDisconnect((_) => print('disconnect All'));
  }

  Rx<IO.Socket>? singleKapalSocket;
  var getVessel = false.obs;

  void socketSingleKapalDisconnect() {
    if (singleKapalSocket != null) {
      singleKapalSocket!.value.disconnect();
      singleKapalSocket = null;
    }
  }

  void socketSingleKapal(String callSign) {
    socketSingleKapalDisconnect();
    // streamSocketKapal.value.socketResponseSingleKapal.close().then((value){});
    String nameEvent = "single_kapal_coor";
    singleKapalSocket = IO
        .io('${InitService.baseUrl}kapal?name_event=$nameEvent&call_sign=$callSign',
            IO.OptionBuilder().setTransports(['websocket']).build())
        .obs;

    singleKapalSocket!.value.onConnect((_) => print('connect Single'));

    singleKapalSocket!.value.on('single_kapal_coor', (data) {
      var response = GetKapalCoor.fromJson(data);

      streamSocketKapal.value.addResponseSingle(response);
    });
    singleKapalSocket!.value.onDisconnect((_) => print('disconnect Single'));
  }
  
  Rx<IO.Socket>? singleKapalLatlongSocket;

  void socketSingleKapalLatlongDisconnect() {
    if (singleKapalLatlongSocket != null) {
      singleKapalLatlongSocket!.value.disconnect();
      singleKapalLatlongSocket = null;
    }
  }

  void socketSingleKapalLatlong(String callSign) {
    socketSingleKapalLatlongDisconnect();
    // streamSocketKapal.value.socketResponseSingleKapal.close().then((value){});
    String nameEvent = "kapal_latlong";
    singleKapalLatlongSocket = IO
        // .io('${InitService.baseUrl}kapal-latlong?call_sign=$callSign',
        .io('${InitService.baseUrl}kapal-latlong?call_sign=$callSign',
            IO.OptionBuilder().setTransports(['websocket']).build())
        .obs;

    singleKapalLatlongSocket!.value.onConnect((_) => print('connect Singleasdasd'));

    singleKapalLatlongSocket!.value.on('kapal_latlong', (data) {
      var response = GetKapalLatlongResponse.fromJson(data);

      streamSocketKapal.value.addResponseSingleLatlong(response);
    });
    singleKapalLatlongSocket!.value.onDisconnect((_) => print('disconnect Single'));
  }

  void updatePoint(MapEvent? event) {
    const pointX = 40;
    latLng.value = mapController.camera.pointToLatLng(math.Point(pointX, pointY.value));
  }

  void userCurrentPosition()async{
    var box = GetStorage();
    if(box.read("currentZoom") != null && box.read("currentLatlong") != null){
      initialZoom.value = box.read("currentZoom");
      currentZoom.value = box.read("currentZoom");
      initialCenter.value = LatLng(box.read("currentLatlong")['coordinates'][1],box.read("currentLatlong")['coordinates'][0]);
    }
  }
  void setUserCurrentPosition(double zoom,LatLng center)async{
    var box = GetStorage();
    currentZoom.value = zoom;
    box.write("currentZoom", zoom);
    box.write("currentLatlong", center);
  }

  @override
  void onInit() {
    super.onInit();
      userCurrentPosition();
    try {
      mapController = MapController();
      socketAllKapal();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePoint(null);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
    streamSocketKapal.value.dispose();
  }
}
