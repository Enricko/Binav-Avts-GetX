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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0E286C),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to the desired color
        ),
        title: Responsive(
          children: [
            PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.menu),
              itemBuilder: (context) =>
              [
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius
                            .circular(10)),
                        child: FirstProfile()),
                  );
                },
                child: CircleAvatar(
                  radius: 25,
                  child: Text("${GetStorage().read("name")[0]}".toUpperCase(),
                      style: TextStyle(fontSize: 15)),
                ))
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
                        minZoom: 4,
                        maxZoom: 18,
                        initialZoom: mapGetController.initialZoom.value,
                        initialCenter: mapGetController.initialCenter.value,
                        onPositionChanged: (position, hasGesture) {
                          mapGetController.setUserCurrentPosition(
                              position.zoom!, position.center!);
                          print(mapGetController.jumlahGarisBujur.value);
                          print(mapGetController.scaleBujur.value);
                          print(position.zoom);
                          if (position.zoom! <= 11.3) {
                            mapGetController.jumlahGarisBujur.value = 720;
                            mapGetController.scaleBujur.value = 0.125;
                            mapGetController.jumlahGarisLintang.value = 1440;
                            mapGetController.scaleLintang.value = 0.125;
                          }
                          if (position.zoom! <= 10.5) {
                            mapGetController.jumlahGarisBujur.value = 360;
                            mapGetController.scaleBujur.value = 0.25;
                            mapGetController.jumlahGarisLintang.value = 720;
                            mapGetController.scaleLintang.value = 0.25;
                          }
                          if (position.zoom! <= 9) {
                            mapGetController.jumlahGarisBujur.value = 180;
                            mapGetController.scaleBujur.value = 0.50;
                            mapGetController.jumlahGarisLintang.value = 360;
                            mapGetController.scaleLintang.value = 0.50;
                          }
                          if (position.zoom! <= 8.3) {
                            mapGetController.jumlahGarisBujur.value = 36;
                            mapGetController.scaleBujur.value = 2.5;
                            mapGetController.jumlahGarisLintang.value = 72;
                            mapGetController.scaleLintang.value = 2.5;
                          }
                          if (position.zoom! <= 7.5) {
                            mapGetController.jumlahGarisBujur.value = 18;
                            mapGetController.scaleBujur.value = 5;
                            mapGetController.jumlahGarisLintang.value = 36;
                            mapGetController.scaleLintang.value = 5;
                          }
                          if (position.zoom! < 5 ) {
                            mapGetController.jumlahGarisBujur.value = 9;
                            mapGetController.scaleBujur.value = 10;
                            mapGetController.jumlahGarisLintang.value = 18;
                            mapGetController.scaleLintang.value = 10;
                          }
                          // if (position.zoom! < 9) {
                          //   mapGetController.jumlahGarisBujur.value = 18;
                          //   mapGetController.scaleBujur.value = 5;
                          //   mapGetController.jumlahGarisLintang.value = 36;
                          //   mapGetController.scaleLintang.value = 5;
                          // }else{
                          //   mapGetController.jumlahGarisBujur.value = 36;
                          //   mapGetController.scaleBujur.value = 2.5;
                          //   mapGetController.jumlahGarisLintang.value = 72;
                          //   mapGetController.scaleLintang.value = 2.5;
                          // }
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

                        /// window kanan atas
                        Obx(() {
                          if (mapGetController.getVessel.value) {
                            return Align(
                                alignment: Alignment.topRight,
                                child: WindowVesselDetail()
                            );
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

                        /// widget skala kiri atas
                        ScaleLayerWidget(
                          options: ScaleLayerPluginOption(
                            lineColor: Colors.blue,
                            lineWidth: 2,
                            textStyle: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
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
                          return PolylineLayer(
                            polylines: [
                              ///Bujur
                              Polyline(
                                points: [
                                  LatLng(0, -180), // Garis Khatulistiwa
                                  LatLng(0, 180),
                                ],
                                color: Colors.white54, // Warna Garis Khatulistiwa
                                strokeWidth: 1, // Lebar Garis Khatulistiwa
                              ),
                              for(int i = 1; i <=
                                  mapGetController.jumlahGarisBujur.value; i++)
                                Polyline(
                                  points: [
                                    LatLng(mapGetController.scaleBujur.value *
                                        i.toDouble(), -180),
                                    // Garis Bujur Positive
                                    LatLng(mapGetController.scaleBujur.value *
                                        i.toDouble(), 180),
                                  ],
                                  color: Colors.white54,
                                  strokeWidth: 1,
                                ),
                              for(int i = 1; i <= mapGetController.jumlahGarisBujur.value; i++)
                                Polyline(
                                  points: [
                                    LatLng(-mapGetController.scaleBujur.value * i.toDouble(), -180),
                                    // Garis Bujur Negative
                                    LatLng(-mapGetController.scaleBujur.value * i.toDouble(), 180),
                                  ],
                                  color: Colors.white54,
                                  strokeWidth: 1,
                                ),

                              /// Lintang
                              Polyline(
                                points: [
                                  LatLng(-90, 0), // Garis Lintang
                                  LatLng(90, 0),
                                ],
                                color: Colors.white54, // Warna garis lintang
                                strokeWidth: 1, // Lebar garis lintang
                              ),
                              for(int i = 1; i <= mapGetController.jumlahGarisLintang.value; i++)
                                Polyline(
                                  points: [
                                    LatLng(-90, mapGetController.scaleLintang.value * i.toDouble()),
                                    // Garis Lintang Positive
                                    LatLng(90, mapGetController.scaleLintang.value * i.toDouble()),
                                  ],
                                  color: Colors.white54, // Warna garis lintang
                                  strokeWidth: 1, // Lebar garis lintang
                                ),
                              for(int i = 1; i <= mapGetController.jumlahGarisLintang.value; i++)
                                Polyline(
                                  points: [
                                    LatLng(-90, -mapGetController.scaleLintang.value * i.toDouble()),
                                    // Garis Lintang Negative
                                    LatLng(90, -mapGetController.scaleLintang.value * i.toDouble()),
                                  ],
                                  color: Colors.white54, // Warna garis lintang
                                  strokeWidth: 1, // Lebar garis lintang
                                ),
                            ],
                          );
                        })
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
