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
import 'package:searchfield/searchfield.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import '../widget/maps/pipeline_layer.dart';
import '../widget/maps/scale_bar/scale_bar.dart';
import '../widget/maps/zoom_button.dart';
import '../widget/maps/vessel/vessel_detail.dart';
import 'table/client/client.dart';
import 'table/kapal/kapal.dart';
import 'table/pipeline/pipeline.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var mapGetController = Get.find<MapGetXController>();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController SearchVessel = TextEditingController();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            // IconButton(
            //   icon: new Icon(Icons.settings),
            //   onPressed: () {
            //     Scaffold.of(context).openDrawer();
            //     // Scaffold.of(context).openDrawer();
            //   },
            // ),

            // InkWell(
            //     onTap: () {
            //       setState(() {
            //         isSidenavOpen = !isSidenavOpen;
            //         if (isSidenavOpen) {
            //           animationController.forward();
            //         } else {
            //           animationController.reverse();
            //         }
            //       });
            //     },
            //     child: AnimatedIcon(
            //         icon: AnimatedIcons.menu_close, progress: iconAnimation)),
            Row(
              children: [
                SizedBox(
                  width: 500,
                  height: 50,
                  child: SearchField(
                    suggestions: [],
                    controller: SearchVessel,
                    // suggestions: value.vesselCoorResult
                    //     .map(
                    //       (e) => SearchFieldListItem<VesselCoor.Data>(
                    //     e.kapal!.callSign!,
                    //     item: e,
                    //     // Use child to show Custom Widgets in the suggestions
                    //     // defaults to Text widget
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: [
                    //           const SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(e.kapal!.callSign!),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    //     .where((e) => e.searchKey
                    //     .toLowerCase()
                    //     .contains(SearchVessel.text.toLowerCase()))
                    //     .toList(),
                    searchInputDecoration: InputDecoration(
                      hintText: "Pilih Call Sign Kapal",
                      // labelText: "Pilih Call Sign Kapal",
                      hintStyle: const TextStyle(color: Colors.black),
                      // labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.search),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 230, 230, 230),
                      prefixIconColor: Colors.black,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Color.fromARGB(255, 230, 230, 230)),
                        borderRadius: BorderRadius.circular(50),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Color.fromARGB(255, 230, 230, 230)),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    // searchVessel(SearchVessel.text);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),

                GestureDetector(
                    onTap: () {
                      Get.dialog(
                        // transitionDuration: Duration(seconds: 1),
                        Dialog(
                            alignment: Alignment.centerRight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: FirstProfile()),
                      );
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (BuildContext context) {
                      //       return Dialog(
                      //           alignment: Alignment.centerRight,
                      //           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      //           child:FirstProfile());
                      //     });
                    },
                    child: CircleAvatar(
                      child: Text("${GetStorage().read("name")[0]}".toUpperCase(),
                          style: TextStyle(fontSize: 15)),
                    ))
              ],
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
                    child: FlutterMap(
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
                            return WindowVesselDetail();
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
                            textStyle:
                            const TextStyle(color: Colors.blue, fontSize: 12),
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
                          // 'https://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}',
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
                        PipelineLayer(),
                        VesselWidget(),
                        // Garis kapal
                        // VesselLineLatlong(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
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
