import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/widget/maps/vessel/vessel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../model/get_kapal_coor.dart';
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
                      Dialog(child: KapalTable()),
                    );
                  case "pipelineList":
                    Get.dialog(
                      Dialog(child: PipelineTable()),
                    );
                  case "clientList":
                    Get.dialog(
                      Dialog(child: ClientTable()),
                    );
                }
              },
            )
          ],
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
                  PipelineLayer(),
                  VesselWidget(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
