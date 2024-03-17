import "dart:math" as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../controller/map.dart';
import '../../../model/get_kapal_coor.dart';

class VesselWidget extends StatefulWidget {
  VesselWidget({super.key});
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  @override
  State<VesselWidget> createState() => _VesselWidgetState();
}

class _VesselWidgetState extends State<VesselWidget> with TickerProviderStateMixin {
  var mapGetController = Get.find<MapGetXController>();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = mapGetController.mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '${VesselWidget._startedId}#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = VesselWidget._finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = VesselWidget._inProgressId;
      }

      hasTriggeredMove |= mapGetController.mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Future<void> vesselOnClick(String callSign, LatLng latLng) async {
    mapGetController.getVessel.value = true;
    mapGetController.socketSingleKapal(callSign);
    mapGetController.socketSingleKapalLatlong(callSign);
    _animatedMapMove(latLng, 17);
  }

  LatLng predictLatLong(
      double latitude, double longitude, double speed, double course, int movementTime) {
    // Convert course from degrees to radians
    double courseRad = degreesToRadians(course);
    // Convert speed from meters per minute to meters per second
    double speedMps = speed / 60.0;
    // Calculate the distance traveled in meters
    double distanceM = speedMps * movementTime;
    // Calculate the change in latitude and longitude
    double deltaLatitude = distanceM * math.cos(courseRad) / 111111.1;
    double deltaLongitude =
        distanceM * math.sin(courseRad) / (111111.1 * math.cos(degreesToRadians(latitude)));
    // Calculate the new latitude and longitude
    double newLatitude = latitude + deltaLatitude;
    double newLongitude = longitude + deltaLongitude;
    return LatLng(newLatitude, newLongitude);
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mapGetController.streamSocketKapal.value.getResponseAll,
      builder: (BuildContext context, AsyncSnapshot<GetKapalCoor> snapshot) {
        if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
          if (snapshot.data!.data!.length <= 0) {
            return SizedBox();
          }
          return Obx(
            () {
              return MarkerLayer(
                markers: snapshot.data!.data!.map(
                  (e) {
                    var latlong = predictLatLong(
                      e.coor!.coorGga!.latitude!,
                      e.coor!.coorGga!.longitude!,
                      100,
                      e.headingDirection!.toDouble() + (e.coor!.coorHdt!.headingDegree ?? e.coor!.defaultHeading!),
                      1,
                    );
                    return Marker(
                      width: ((25 * (math.pow(2, (mapGetController.currentZoom.value)))) / 4000000) * mapGetController.vesselSizes(e.size!),
                      height: ((25 * (math.pow(2, (mapGetController.currentZoom.value)))) / 4000000) * mapGetController.vesselSizes(e.size!),
                      point: LatLng(
                        latlong.latitude,
                        latlong.longitude,
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onDoubleTap: () {
                            vesselOnClick(
                              e.callSign!,
                              LatLng(
                                latlong.latitude - .000005,
                                latlong.longitude,
                              ),
                            );
                          },
                          child: Transform.rotate(
                            angle: mapGetController.degreesToRadians(
                              e.headingDirection!.toDouble() + (e.coor!.coorHdt!.headingDegree ?? e.coor!.defaultHeading!),
                            ),
                            child: Tooltip(
                              message: e.callSign!,
                              child: Image.asset(
                                "assets/ship.png",
                                height:
                                    ((25 * (math.pow(2, (mapGetController.currentZoom.value)))) / 4000000) * mapGetController.vesselSizes(e.size!),
                                width:
                                    ((25 * (math.pow(2, (mapGetController.currentZoom.value)))) / 4000000) * mapGetController.vesselSizes(e.size!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
