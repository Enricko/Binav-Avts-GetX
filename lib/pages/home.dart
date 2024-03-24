import 'dart:convert';
import 'dart:html' as html;

import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/pages/table/first_profile.dart';
import 'package:binav_avts_getx/utils/alerts.dart';
import 'package:binav_avts_getx/widget/maps/ruler/marker_cursor_follow.dart';
import 'package:binav_avts_getx/widget/maps/ruler/ruler_detail.dart';
import 'package:binav_avts_getx/widget/maps/ruler/ruler_line.dart';
import 'package:binav_avts_getx/widget/maps/vessel/vessel.dart';
import 'package:binav_avts_getx/widget/maps/vessel/vessel_line_latlong.dart';
import 'package:binav_avts_getx/widget/maps/vessel/window_vessel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:searchfield/searchfield.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import '../widget/maps/pipeline_layer.dart';
import '../widget/maps/ruler/ruler_center.dart';
import '../widget/maps/scale_bar/scale_bar.dart';
import '../widget/maps/vessel/search_vessel.dart';
import '../widget/maps/zoom_button.dart';
import '../widget/maps/vessel/vessel_detail.dart';
import 'table/client/client.dart';
import 'table/kapal/kapal.dart';
import 'table/pipeline/pipeline.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var mapGetController = Get.find<MapGetXController>();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // ///animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Flexible(
                child: Obx(
                  () => FlutterMap(
                    mapController: mapGetController.mapController,
                    options: MapOptions(
                      onMapEvent: (event) {
                        mapGetController.updatePoint(null);
                      },
                      onTap: (mapGetController.countDistance.value)
                          ? (TapPosition, LatLong) {
                              if (mapGetController.rulerMode.value == RulerMode.FOLLOW) {
                                mapGetController.handleMapTap(LatLong);
                              }
                            }
                          : null,
                      onPointerHover: (PointerHoverEvent, LatLng) {
                        if (mapGetController.countDistance.value) {
                          if (mapGetController.rulerMode.value == RulerMode.FOLLOW) {
                            mapGetController.latLngCursor.value = LatLng;
                          }
                        }
                      },
                      // onSecondaryTap: (TapPosition, LatLong) {
                      // mapGetController.maxLengthMarker.value --;
                      // mapGetController.countDistance.value = false;
                      // mapGetController.markers.clear();
                      // mapGetController.markersLatLng.clear();
                      // },
                      minZoom: 4,
                      maxZoom: 18,
                      initialZoom: mapGetController.initialZoom.value,
                      initialCenter: mapGetController.initialCenter.value,
                      onPositionChanged: (position, hasGesture) {
                        mapGetController.setUserCurrentPosition(position.zoom!, position.center!);
                        if (mapGetController.rulerMode.value == RulerMode.CENTER) {
                          mapGetController.latLngCursor.value =
                              mapGetController.mapController.center;
                        }
                      },
                    ),
                    nonRotatedChildren: [
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: ScaleLayerWidget(
                                options: ScaleLayerPluginOption(
                                  lineColor: Colors.white,
                                  lineWidth: 2,
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                                  padding: const EdgeInsets.all(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Obx(() {
                        if (mapGetController.rulerMode.value == RulerMode.CENTER) {
                          return RulerCenter();
                        }
                        return SizedBox();
                      }),

                      Obx(
                        () {
                          if (mapGetController.getVessel.value) {
                            return VesselDetail();
                          }
                          return SizedBox();
                        },
                      ),

                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  width: 50,
                                  height: 50,
                                  child: PopupMenuButton(
                                    position: PopupMenuPosition.under,
                                    icon: const Icon(
                                      Icons.menu,
                                    ),
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'vesselList',
                                        child: Text('Vessel List'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'pipelineList',
                                        child: Text('Pipeline List'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'clientList',
                                        child: Text('Client List'),
                                      ),
                                    ],
                                    onSelected: (item) {
                                      switch (item) {
                                        case "vesselList":
                                          Get.dialog(
                                            Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: KapalTable()),
                                          );
                                        case "pipelineList":
                                          Get.dialog(
                                            Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: PipelineTable()),
                                          );
                                        case "clientList":
                                          Get.dialog(
                                            Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: ClientTable()),
                                          );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(child: SearchVessel()),
                                SizedBox(
                                  width: 10,
                                ),
                                Obx(
                                  () => SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Tooltip(
                                      message: "Ruler",
                                      child: IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors.white)),
                                        onPressed: () {
                                          mapGetController.countDistance.value =
                                              !mapGetController.countDistance.value;
                                          if (mapGetController.countDistance.value == false) {
                                            mapGetController.markers.clear();
                                            mapGetController.markersLatLng.clear();
                                          } else {
                                            mapGetController.latLngCursor.value = null;
                                          }
                                        },
                                        icon: Icon(
                                          Icons.straighten,
                                          color: mapGetController.countDistance.value
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),

                          /// window kanan atas
                          Obx(() {
                            return Wrap(
                              children: [
                                if (mapGetController.getVessel.value)
                                  Align(alignment: Alignment.topRight, child: WindowVesselDetail()),
                                if (mapGetController.countDistance.value)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        RulerDetail(),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Tooltip(
                                                message: "Change MODE",
                                                child: IconButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Colors.white)),
                                                  onPressed: () {
                                                    mapGetController.rulerMode.value =
                                                        mapGetController.rulerMode.value ==
                                                                RulerMode.CENTER
                                                            ? RulerMode.FOLLOW
                                                            : RulerMode.CENTER;
                                                  },
                                                  icon: Icon(
                                                    mapGetController.rulerMode.value ==
                                                            RulerMode.CENTER
                                                        ? Icons.center_focus_strong
                                                        : Icons.mouse,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Tooltip(
                                                message: "Undo Ruler",
                                                child: IconButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Colors.white)),
                                                  onPressed: mapGetController.markers.isEmpty
                                                      ? null
                                                      : () {
                                                          mapGetController.markers.removeLast();
                                                          mapGetController.markersLatLng
                                                              .removeLast();
                                                          // mapGetController.latLngCursor.removeLast();
                                                        },
                                                  icon: Icon(
                                                    Icons.undo,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Tooltip(
                                                message: "Add Ruler",
                                                child: IconButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(Colors.blue),
                                                  ),
                                                  onPressed: (mapGetController.countDistance.value)
                                                      ? () {
                                                          mapGetController.latLngCursor.value =
                                                              mapGetController.latLngCursor.value!;
                                                          mapGetController.handleMapTap(
                                                              mapGetController.latLngCursor.value!);
                                                        }
                                                      : null,
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Tooltip(
                              message: "Location",
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: () async {
                                    ///check apakah button get current location active
                                    if (mapGetController.currentPositionActive.value == false) {
                                      /// check permission
                                      mapGetController.permission =
                                          await Geolocator.checkPermission();
                                      if (mapGetController.permission ==
                                          LocationPermission.denied) {
                                        mapGetController.permission =
                                            await Geolocator.requestPermission();
                                        if (mapGetController.permission ==
                                            LocationPermission.denied) {
                                          return Future.error('Location permissions are denied');
                                        }
                                      }

                                      if (mapGetController.permission ==
                                          LocationPermission.deniedForever) {
                                        return Future.error(
                                            'Location permissions are permanently denied, we cannot request permissions.');
                                      }

                                      /// when getting the lattng,button currentposition is active
                                      Position position = await Geolocator.getCurrentPosition(
                                              desiredAccuracy: LocationAccuracy.high)
                                          .whenComplete(() {
                                        mapGetController.currentPositionActive.value = true;
                                      });
                                      mapGetController.currentPosition.value =
                                          LatLng(position.latitude, position.longitude);
                                      mapGetController.mapController
                                          .move(LatLng(position.latitude, position.longitude), 15);
                                    } else {
                                      mapGetController.currentPositionActive.value = false;
                                      mapGetController.currentPosition.value = null;
                                    }
                                  },
                                  child: Icon(Icons.location_searching_outlined,
                                      color: mapGetController.currentPositionActive.value
                                          ? Colors.blue
                                          : Colors.black),
                                ),
                              ),
                            ),
                            FlutterMapZoomButtons(
                              minZoom: 4,
                              maxZoom: 18,
                              mini: true,
                              padding: 10,
                              zoomInColorIcon: Colors.black,
                              zoomOutColorIcon: Colors.black,
                            ),
                            // Obx(
                            //   () => AnimatedContainer(
                            //     duration: Duration(milliseconds: 500),
                            //     // Sesuaikan durasi animasi sesuai kebutuhan
                            //     height: mapGetController.countDistance.value
                            //         ? kBottomNavigationBarHeight
                            //         : 0,
                            //     child: Container(
                            //       color: Colors.white,
                            //       child: Padding(
                            //         padding: EdgeInsets.symmetric(horizontal: 20),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               "Klik Icon (+) untuk mengukur jarak",
                            //               style: TextStyle(color: Colors.black54),
                            //             ),
                            //             Row(
                            //               children: [
                            //                 IconButton(
                            //                   style: ButtonStyle(
                            //                       backgroundColor:
                            //                           MaterialStateProperty.all(Colors.white)),
                            //                   onPressed: mapGetController.markers.isEmpty
                            //                       ? null
                            //                       : () {
                            //                           mapGetController.markers.removeLast();
                            //                           mapGetController.markersLatLng.removeLast();
                            //                           // mapGetController.latLngCursor.removeLast();
                            //                         },
                            //                   icon: Icon(
                            //                     Icons.undo,
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 IconButton(
                            //                   style: ButtonStyle(
                            //                     backgroundColor:
                            //                         MaterialStateProperty.all(Colors.blue),
                            //                   ),
                            //                   onPressed: (mapGetController.countDistance.value)
                            //                       ? () {
                            //                           mapGetController.latLngCursor.value =
                            //                               mapGetController.mapController.center;
                            //                           mapGetController.handleMapTap(
                            //                               mapGetController.mapController.center);
                            //                         }
                            //                       : null,
                            //                   icon: Icon(
                            //                     Icons.add,
                            //                     color: Colors.white,
                            //                   ),
                            //                 ),
                            //               ],
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //       // height: 80,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )

                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(20),
                      //     child: IconButton(
                      //         onPressed: () {
                      //           mapGetController.countDistance.value =
                      //           !mapGetController.countDistance.value;
                      //           print(mapGetController.countDistance.value);
                      //         },
                      //         icon: Icon(
                      //           Icons.build,
                      //           color: Colors.white,
                      //         )),
                      //   ),
                      // ),

                      /// widget skala kiri atas
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            // Google RoadMap
                            // 'https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
                            // Google Altered roadmap
                            // 'https://mt0.google. com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}',
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

                      // ==== Pipeline Widget ====
                      // PipelineLayer(),
                      // ==== Pipeline Widget ====

                      VesselWidget(),
                      // Garis kapal
                      // VesselLineLatlong(),
                      RulerLine(),

                      Obx(() {
                        return MarkerLayer(markers: mapGetController.markers.value);
                      }),
                      Obx(() {
                        if (mapGetController.rulerMode.value == RulerMode.FOLLOW) {
                          return MarkerCursorFollow();
                        } else {
                          return mapGetController.currentPosition.value != null
                              ? MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 10,
                                      point: mapGetController.currentPosition.value!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox();
                        }
                      }),

                      // MarkerCursorFollow(),

                      // MarkerLayer(
                      //   markers: [
                      //     if (mapGetController.latLng.value != null)
                      //       Marker(
                      //         width: mapGetController.pointSize.value,
                      //         height: mapGetController.pointSize.value,
                      //         point: mapGetController.latLng.value!,
                      //         child: Image.asset(
                      //           "assets/compass.png",
                      //           width: 250,
                      //           height: 250,
                      //         ),
                      //       ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SidebarModel extends ChangeNotifier {
  List<String> title = ["Vessel", "Pipeline", "Client"];
  String? hoveredTitle;

  void setHoveredTitle(String? title) {
    hoveredTitle = title;
    notifyListeners();
  }
}
