import 'dart:convert';
import 'dart:html' as html;

import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/pages/table/first_profile.dart';
import 'package:binav_avts_getx/widget/maps/ruler/marker_cursor_follow.dart';
import 'package:binav_avts_getx/widget/maps/ruler/ruler_line.dart';
import 'package:binav_avts_getx/widget/maps/vessel/vessel.dart';
import 'package:binav_avts_getx/widget/maps/vessel/vessel_line_latlong.dart';
import 'package:binav_avts_getx/widget/maps/vessel/window_vessel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:searchfield/searchfield.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import '../widget/maps/pipeline_layer.dart';
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
                child: Obx(() {
                  return FlutterMap(
                    mapController: mapGetController.mapController,
                    options: MapOptions(
                      onMapEvent: (event) {
                        mapGetController.updatePoint(null);
                      },
                      onTap: (mapGetController.countDistance.value)
                          ? (TapPosition, LatLong) {
                              mapGetController.handleMapTap(LatLong);
                            }
                          : null,
                      onPointerHover: (PointerHoverEvent, LatLng) {
                        if (mapGetController.countDistance.value) {
                          mapGetController.latLngCursor.value = LatLng;
                        }
                      },
                      onSecondaryTap: (TapPosition, LatLong) {
                        // mapGetController.maxLengthMarker.value --;
                        mapGetController.countDistance.value = false;
                        // mapGetController.markers.clear();
                        // mapGetController.markersLatLng.clear();
                      },
                      minZoom: 4,
                      maxZoom: 18,
                      initialZoom: mapGetController.initialZoom.value,
                      initialCenter: mapGetController.initialCenter.value,
                      onPositionChanged: (position, hasGesture) {
                        mapGetController.setUserCurrentPosition(
                            position.zoom!, position.center!);
                      },
                    ),
                    nonRotatedChildren: [
                      /// button zoom in/out kanan bawah
                      Align(
                        alignment: Alignment.bottomRight,
                        child: const FlutterMapZoomButtons(
                          minZoom: 4,
                          maxZoom: 18,
                          mini: true,
                          padding: 10,
                          zoomInColorIcon: Colors.black,
                          zoomOutColorIcon: Colors.black,
                        ),
                      ),
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
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  padding: const EdgeInsets.all(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// window kanan atas
                      Obx(() {
                        if (mapGetController.getVessel.value) {
                          return Align(
                              alignment: Alignment.topRight,
                              child: WindowVesselDetail());
                          // WindowVesselDetail();
                        }
                        return SizedBox();
                      }),
                      
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Icon(Icons.location_pin),
                      // ),

                      Obx(
                        () {
                          if (mapGetController.getVessel.value) {
                            return VesselDetail();
                          }
                          return SizedBox();
                        },
                      ),

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
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: KapalTable()),
                                      );
                                    case "pipelineList":
                                      Get.dialog(
                                        Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: PipelineTable()),
                                      );
                                    case "clientList":
                                      Get.dialog(
                                        Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClientTable()),
                                      );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SearchVessel(),
                            SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  onPressed: () {
                                    mapGetController.countDistance.value =
                                    !mapGetController.countDistance.value;
                                    if (mapGetController.countDistance.value ==
                                        false) {
                                      mapGetController.markers.clear();
                                      mapGetController.markersLatLng.clear();
                                      html
                                          .window.onContextMenu
                                          .listen((event) {
                                        event.preventDefault();
                                      }).cancel();
                                    }else{
                                      html
                                          .window.onContextMenu
                                          .listen((event) {
                                        event.preventDefault();
                                      });
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
                          ],
                        ),
                      ),
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
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                        // tileProvider: CancellableNetworkTileProvider(),
                      ),

                      // ==== Pipeline Widget ====
                      // PipelineLayer(),
                      // ==== Pipeline Widget ====

                      VesselWidget(),
                      // Garis kapal
                      // VesselLineLatlong(),
                      Obx(() {
                        return MarkerLayer(
                            markers: mapGetController.markers.value);
                      }),

                      RulerLine(),

                      MarkerCursorFollow(),

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
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
    //   Scaffold(
    //   // appBar: AppBar(
    //   //   automaticallyImplyLeading: false,
    //   //   backgroundColor: const Color(0xFF0E286C),
    //   //   // backgroundColor: Colors.transparent,
    //   //   iconTheme: const IconThemeData(
    //   //     color: Colors.white, // Change this color to the desired color
    //   //   ),
    //   //   title: Responsive(
    //   //     children: [
    //   //       Div(
    //   //         divison: const Division(
    //   //           colXS: 1,
    //   //           colS: 1,
    //   //           colM: 1,
    //   //           colL: 1,
    //   //           colXL: 1,
    //   //         ),
    //   //         child: SizedBox(
    //   //           height: 50,
    //   //           child: Center(
    //   //             child: PopupMenuButton(
    //   //               position: PopupMenuPosition.under,
    //   //               child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 17)),
    //   //               // icon: const Icon(Icons.menu),
    //   //               itemBuilder: (context) => [
    //   //                 PopupMenuItem(
    //   //                   value: 'vesselList',
    //   //                   child: Text('Vessel List'),
    //   //                 ),
    //   //                 const PopupMenuItem(
    //   //                   value: 'pipelineList',
    //   //                   child: Text('Pipeline List'),
    //   //                 ),
    //   //                 const PopupMenuItem(
    //   //                   value: 'clientList',
    //   //                   child: Text('Client List'),
    //   //                 ),
    //   //               ],
    //   //               onSelected: (item) {
    //   //                 switch (item) {
    //   //                   case "vesselList":
    //   //                     Get.dialog(
    //   //                       Dialog(
    //   //                           shape:
    //   //                               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   //                           child: KapalTable()),
    //   //                     );
    //   //                   case "pipelineList":
    //   //                     Get.dialog(
    //   //                       Dialog(
    //   //                           shape:
    //   //                               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   //                           child: PipelineTable()),
    //   //                     );
    //   //                   case "clientList":
    //   //                     Get.dialog(
    //   //                       Dialog(
    //   //                           shape:
    //   //                               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   //                           child: ClientTable()),
    //   //                     );
    //   //                 }
    //   //               },
    //   //             ),
    //   //           ),
    //   //         ),
    //   //       ),
    //   //       // SizedBox(
    //   //       //   width: 10,
    //   //       // ),
    //   //       // Div(
    //   //       //   divison: const Division(
    //   //       //     colXS: 1,
    //   //       //     colS: 1,
    //   //       //     colM: 1,
    //   //       //     colL: 1,
    //   //       //     colXL: 1,
    //   //       //   ),
    //   //       //   child: SizedBox(
    //   //       //     height: 50,
    //   //       //     child: Center(
    //   //       //       child: PopupMenuButton(
    //   //       //         position: PopupMenuPosition.under,
    //   //       //         child:
    //   //       //             Text('Tools', style: TextStyle(color: Colors.white, fontSize: 17)),
    //   //       //         // icon: const Icon(Icons.menu),
    //   //       //         itemBuilder: (context) => [
    //   //       //           PopupMenuItem(
    //   //       //             value: 'countDistance',
    //   //       //             child: Text('Count Distance'),
    //   //       //           ),
    //   //       //         ],
    //   //       //         onSelected: (item) {
    //   //       //           switch (item) {
    //   //       //             case "countDistance":
    //   //       //               mapGetController.countDistance.value =
    //   //       //                   !mapGetController.countDistance.value;
    //   //       //               mapGetController.isCalculateDistance.value = true;
    //   //       //               print(mapGetController.countDistance.value);
    //   //       //           }
    //   //       //         },
    //   //       //       ),
    //   //       //     ),
    //   //       //   ),
    //   //       // ),
    //   //       SizedBox(
    //   //         width: 10,
    //   //       ),
    //   //       SearchVessel(),
    //   //       const SizedBox(
    //   //         width: 20,
    //   //       ),
    //   //       GestureDetector(
    //   //         onTap: () {
    //   //           Get.dialog(
    //   //             // transitionDuration: Duration(seconds: 1),
    //   //             Dialog(
    //   //                 alignment: Alignment.centerRight,
    //   //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   //                 child: FirstProfile()),
    //   //           );
    //   //         },
    //   //         child: CircleAvatar(
    //   //           radius: 25,
    //   //           child: Text(
    //   //             "${GetStorage().read("name")[0]}".toUpperCase(),
    //   //             style: TextStyle(
    //   //               fontSize: 15,
    //   //             ),
    //   //           ),
    //   //         ),
    //   //       ),
    //   //       const SizedBox(
    //   //         width: 20,
    //   //       ),
    //   //     ],
    //   //   ),
    //   // ),
    //   // drawer:  Drawer(
    //   //   width: 100,
    //   //   child:  ListView(
    //   //     // Important: Remove any padding from the ListView.
    //   //     padding: EdgeInsets.zero,
    //   //     children: [
    //   //       const DrawerHeader(
    //   //         decoration: BoxDecoration(
    //   //           color: Colors.blue,
    //   //         ),
    //   //         child: Text('Drawer Header'),
    //   //       ),
    //   //       ListTile(
    //   //         title: const Text('Item 1'),
    //   //         onTap: () {
    //   //           // Update the state of the app.
    //   //           // ...
    //   //         },
    //   //       ),
    //   //       ListTile(
    //   //         title: const Text('Item 2'),
    //   //         onTap: () {
    //   //           // Update the state of the app.
    //   //           // ...
    //   //         },
    //   //       ),
    //   //     ],
    //   //   ),
    //   // ),
    //   body: Stack(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(8),
    //         child: Column(
    //           children: [
    //             Flexible(
    //               child: Obx(() {
    //                 return FlutterMap(
    //                   mapController: mapGetController.mapController,
    //                   options: MapOptions(
    //                     onMapEvent: (event) {
    //                       mapGetController.updatePoint(null);
    //                     },
    //                     onTap: (mapGetController.countDistance.value)
    //                         ? (TapPosition, LatLong) {
    //                             mapGetController.handleMapTap(LatLong);
    //                           }
    //                         : null,
    //                     onPointerHover: (PointerHoverEvent, LatLng) {
    //                       if (mapGetController.countDistance.value) {
    //                         mapGetController.latLngCursor.value = LatLng;
    //                       }
    //                     },
    //                     onSecondaryTap: (TapPosition, LatLong){
    //                       mapGetController.markers.clear();
    //                       mapGetController.markersLatLng.clear();
    //                     },
    //                     minZoom: 4,
    //                     maxZoom: 18,
    //                     initialZoom: mapGetController.initialZoom.value,
    //                     initialCenter: mapGetController.initialCenter.value,
    //                     onPositionChanged: (position, hasGesture) {
    //                       mapGetController.setUserCurrentPosition(position.zoom!, position.center!);
    //                     },
    //                   ),
    //                   nonRotatedChildren: [
    //                     /// button zoom in/out kanan bawah
    //                     const FlutterMapZoomButtons(
    //                       minZoom: 4,
    //                       maxZoom: 18,
    //                       mini: true,
    //                       padding: 10,
    //                       alignment: Alignment.bottomRight,
    //                       zoomInColorIcon: Colors.white,
    //                       zoomOutColorIcon: Colors.white,
    //                     ),
    //
    //                     /// window kanan atas
    //                     Obx(() {
    //                       if (mapGetController.getVessel.value) {
    //                         return Align(
    //                             alignment: Alignment.topRight, child: WindowVesselDetail());
    //                         // WindowVesselDetail();
    //                       }
    //                       return SizedBox();
    //                     }),
    //
    //                     Obx(
    //                       () {
    //                         if (mapGetController.getVessel.value) {
    //                           return VesselDetail();
    //                         }
    //                         return SizedBox();
    //                       },
    //                     ),
    //                     Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Container(
    //                           width: 100,
    //                           height: 50,
    //                           child: ScaleLayerWidget(
    //                             options: ScaleLayerPluginOption(
    //                               lineColor: Colors.blue,
    //                               lineWidth: 2,
    //                               textStyle: const TextStyle(color: Colors.blue, fontSize: 12),
    //                               padding: const EdgeInsets.all(20),
    //                             ),
    //                           ),
    //                         ),
    //                         Obx(
    //                           () => Container(
    //                             width: 40,
    //                             height: 40,
    //                             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //                             decoration: BoxDecoration(
    //                               shape: BoxShape.circle,
    //                               color: Colors.white,
    //                             ),
    //                             child: IconButton(
    //                               onPressed: () {
    //                                 mapGetController.countDistance.value =
    //                                     !mapGetController.countDistance.value;
    //                                 if (mapGetController.countDistance.value == false) {
    //                                   mapGetController.markers.clear();
    //                                   mapGetController.markersLatLng.clear();
    //                                 }
    //                                 mapGetController.latLngCursor.value = null;
    //                               },
    //                               icon: Icon(
    //                                 Icons.straighten,
    //                                 color: mapGetController.countDistance.value
    //                                     ? Colors.blue
    //                                     : Colors.grey,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     // Align(
    //                     //   alignment: Alignment.centerLeft,
    //                     //   child: Padding(
    //                     //     padding: const EdgeInsets.all(20),
    //                     //     child: IconButton(
    //                     //         onPressed: () {
    //                     //           mapGetController.countDistance.value =
    //                     //           !mapGetController.countDistance.value;
    //                     //           print(mapGetController.countDistance.value);
    //                     //         },
    //                     //         icon: Icon(
    //                     //           Icons.build,
    //                     //           color: Colors.white,
    //                     //         )),
    //                     //   ),
    //                     // ),
    //
    //                     /// widget skala kiri atas
    //                   ],
    //                   children: [
    //                     TileLayer(
    //                       urlTemplate:
    //                           // Google RoadMap
    //                           // 'https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
    //                           // Google Altered roadmap
    //                           // 'https://mt0.google. com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}',
    //                           // Google Satellite
    //                           // 'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}',
    //                           // Google Terrain
    //                           // 'https://mt0.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}',
    //                           // Google Hybrid
    //                           'https://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
    //                       // Open Street Map
    //                       // 'https://c.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //                       userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    //                       // tileProvider: CancellableNetworkTileProvider(),
    //                     ),
    //
    //                     // ==== Pipeline Widget ====
    //                     // PipelineLayer(),
    //                     // ==== Pipeline Widget ====
    //
    //                     VesselWidget(),
    //                     // Garis kapal
    //                     // VesselLineLatlong(),
    //                     Obx(() {
    //                       return MarkerLayer(markers: mapGetController.markers.value);
    //                     }),
    //
    //                     RulerLine(),
    //
    //                     MarkerCursorFollow(),
    //
    //                     // MarkerLayer(
    //                     //   markers: [
    //                     //     if (mapGetController.latLng.value != null)
    //                     //       Marker(
    //                     //         width: mapGetController.pointSize.value,
    //                     //         height: mapGetController.pointSize.value,
    //                     //         point: mapGetController.latLng.value!,
    //                     //         child: Image.asset(
    //                     //           "assets/compass.png",
    //                     //           width: 250,
    //                     //           height: 250,
    //                     //         ),
    //                     //       ),
    //                     //   ],
    //                     // ),
    //                   ],
    //                 );
    //               }),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
