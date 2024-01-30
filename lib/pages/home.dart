import 'package:binav_avts_getx/controller/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../model/get_kapal_coor.dart';
import '../widget/maps/scale_bar/scale_bar.dart';
import '../widget/maps/zoom_button.dart';
import '../widget/vessel_detail.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var mapGetController = Get.find<MapGetXController>();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = mapGetController.mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget = '${HomePage._startedId}#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = HomePage._finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = HomePage._inProgressId;
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
    _animatedMapMove(latLng, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0E286C),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to the desired color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: mapGetController.mapController,
                options: MapOptions(
                  onMapEvent: (event) {
                    mapGetController.updatePoint(null);
                  },
                  minZoom: 4,
                  maxZoom: 18,
                  initialZoom: 10,
                  initialCenter: const LatLng(-1.089955, 117.360343),
                  onPositionChanged: (position, hasGesture) {
                    mapGetController.currentZoom.value = position.zoom!;
                  },
                ),
                nonRotatedChildren: [
                  /// button zoom in/out kanan bawah
                  const FlutterMapZoomButtons(
                    minZoom: 4,
                    maxZoom: 18,
                    mini: true,
                    padding: 10,
                    alignment: Alignment.bottomRight,
                  ),

                  /// widget skala kiri atas
                  ScaleLayerWidget(
                    options: ScaleLayerPluginOption(
                      lineColor: Colors.blue,
                      lineWidth: 2,
                      textStyle: const TextStyle(color: Colors.blue, fontSize: 12),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  Obx(
                    () {
                      if (mapGetController.getVessel.value) {
                        return VesselDetail();
                      }
                      return SizedBox();
                    },
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        // Google RoadMap
                        // 'https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
                        // Google Altered roadmap
                        // 'https://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}',
                        // Google Satellite
                        // 'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}',
                        // Google Terrain
                        // 'https://mt0.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}',
                        // Google Hybrid
                        'https://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
                    // Open Street Map
                    // 'https://c.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    // tileProvider: CancellableNetworkTileProvider(),
                  ),
                  Obx(
                    () {
                      final LatLng? latLng = mapGetController.latLng.value;

                      return MarkerLayer(
                        markers: [
                          if (latLng != null)
                            Marker(
                              width: mapGetController.pointSize.value,
                              height: mapGetController.pointSize.value,
                              point: latLng,
                              child: CircleAvatar(
                                child: Image.asset(
                                  "assets/compass.png",
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: mapGetController.streamSocket.value.getResponseAll,
                    builder: (BuildContext context, AsyncSnapshot<GetKapalCoor> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
                        return Obx(
                          () => MarkerLayer(
                            markers: snapshot.data!.data!.map(
                              (e) {
                                return Marker(
                                  width: mapGetController.vesselSizes(e.size!) +
                                      (mapGetController.currentZoom.value - 8) * 6,
                                  height: mapGetController.vesselSizes(e.size!) +
                                      (mapGetController.currentZoom.value - 8) * 6,
                                  point: LatLng(e.coor!.coorGga!.latitude!, e.coor!.coorGga!.longitude!),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        vesselOnClick(
                                          e.callSign!,
                                          LatLng(
                                            e.coor!.coorGga!.latitude! - .005,
                                            e.coor!.coorGga!.longitude!,
                                          ),
                                        );
                                      },
                                      child: Transform.rotate(
                                        angle: mapGetController.degreesToRadians(
                                          e.coor!.coorHdt!.headingDegree ?? e.coor!.defaultHeading!,
                                        ),
                                        child: Tooltip(
                                          message: e.callSign!,
                                          child: Image.asset(
                                            "assets/ship.png",
                                            height: mapGetController.vesselSizes(e.size!.toString()) +
                                                (mapGetController.currentZoom.value - 8) * 6,
                                            width: mapGetController.vesselSizes(e.size!.toString()) +
                                                (mapGetController.currentZoom.value - 8) * 6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
