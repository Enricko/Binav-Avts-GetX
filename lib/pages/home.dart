import 'dart:convert';

import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart';
import 'package:binav_avts_getx/pages/table/first_profile.dart';
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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0E286C),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this color to the desired color
          ),
          title: (mapGetController.isCalculateDistance.value)
              ? Obx(() {
                  return Row(
                    children: [
                      Text(
                        (mapGetController.markersLatLng.length == 2)
                            ? "${mapGetController.calculateDistance(mapGetController.markersLatLng[0], mapGetController.markersLatLng[1]).toString()} Meter"
                            : "0 Meter",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                          onPressed: () {
                            mapGetController.countDistance.value = false;
                            mapGetController.isCalculateDistance.value = false;
                            mapGetController.markersLatLng.clear();
                            mapGetController.markers.clear();
                          },
                          icon: Icon(Icons.close))
                    ],
                  );
                })
              : Responsive(
                  children: [
                    Div(
                      divison: const Division(
                        colXS: 1,
                        colS: 1,
                        colM: 1,
                        colL: 1,
                        colXL: 1,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            child:
                                Text('Menu', style: TextStyle(color: Colors.white, fontSize: 17)),
                            // icon: const Icon(Icons.menu),
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
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Div(
                    //   divison: const Division(
                    //     colXS: 1,
                    //     colS: 1,
                    //     colM: 1,
                    //     colL: 1,
                    //     colXL: 1,
                    //   ),
                    //   child: SizedBox(
                    //     height: 50,
                    //     child: Center(
                    //       child: PopupMenuButton(
                    //         position: PopupMenuPosition.under,
                    //         child:
                    //             Text('Tools', style: TextStyle(color: Colors.white, fontSize: 17)),
                    //         // icon: const Icon(Icons.menu),
                    //         itemBuilder: (context) => [
                    //           PopupMenuItem(
                    //             value: 'countDistance',
                    //             child: Text('Count Distance'),
                    //           ),
                    //         ],
                    //         onSelected: (item) {
                    //           switch (item) {
                    //             case "countDistance":
                    //               mapGetController.countDistance.value =
                    //                   !mapGetController.countDistance.value;
                    //               mapGetController.isCalculateDistance.value = true;
                    //               print(mapGetController.countDistance.value);
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    SearchVessel(),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.dialog(
                            // transitionDuration: Duration(seconds: 1),
                            Dialog(
                                alignment: Alignment.centerRight,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: FirstProfile()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 25,
                          child: Text("${GetStorage().read("name")[0]}".toUpperCase(),
                              style: TextStyle(fontSize: 15)),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
        ),
        // drawer:  Drawer(
        //   width: 100,
        //   child:  ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: EdgeInsets.zero,
        //     children: [
        //       const DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //         ),
        //         child: Text('Drawer Header'),
        //       ),
        //       ListTile(
        //         title: const Text('Item 1'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       ListTile(
        //         title: const Text('Item 2'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
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
                          const FlutterMapZoomButtons(
                            minZoom: 4,
                            maxZoom: 18,
                            mini: true,
                            padding: 10,
                            alignment: Alignment.bottomRight,
                            zoomInColorIcon: Colors.white,
                            zoomOutColorIcon: Colors.white,
                          ),

                          /// window kanan atas
                          Obx(() {
                            if (mapGetController.getVessel.value) {
                              return Align(
                                  alignment: Alignment.topRight, child: WindowVesselDetail());
                              // WindowVesselDetail();
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 100,
                                height: 50,
                                child: ScaleLayerWidget(
                                  options: ScaleLayerPluginOption(
                                    lineColor: Colors.blue,
                                    lineWidth: 2,
                                    textStyle: const TextStyle(color: Colors.blue, fontSize: 12),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      mapGetController.countDistance.value =
                                          !mapGetController.countDistance.value;
                                      mapGetController.isCalculateDistance.value = true;
                                      mapGetController.latLngCursor.value = null;
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
                          PipelineLayer(),
                          VesselWidget(),
                          // Garis kapal
                          // VesselLineLatlong(),
                          Obx(() {
                            return MarkerLayer(markers: mapGetController.markers.value);
                          }),

                          PolylineLayer(polylines: [
                            Polyline(
                              points: mapGetController.markersLatLng.value.map((e) => e).toList(),
                              color: Colors.blueAccent,
                              strokeWidth: 2,
                            ),
                          ]),
                          Obx(
                            () {
                              return mapGetController.latLngCursor.value == null
                                  ? SizedBox()
                                  : MarkerLayer(
                                      markers: [
                                        Marker(
                                          width: 150.0,
                                          height: 80.0,
                                          point: mapGetController.latLngCursor.value!,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                child: Icon(Icons.place,
                                                    color: Colors
                                                        .red), // Ubah ikon sesuai kebutuhan Anda
                                              ),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.black.withOpacity(0.7),
                                                  ),
                                                  child: Text(
                                                    mapGetController.markersLatLng.length > 0
                                                        ? "${mapGetController.calculateDistance(mapGetController.markersLatLng[mapGetController.markersLatLng.length - 1], mapGetController.latLngCursor.value!)} M"
                                                        : "${mapGetController.markersLatLng.length} M",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),

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
            ),
          ],
        ),
      );
    });
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
