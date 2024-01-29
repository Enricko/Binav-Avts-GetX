import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../model/get_kapal_coor.dart';
import '../utils/maps/scale_bar/scale_bar.dart';
import '../utils/maps/zoom_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  var controller = Get.find<MapGetXController>();

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
            Container(
              height: 500,
              child: Obx(() => StreamBuilder(
                    stream: controller.streamSocket.value.getResponse,
                    builder: (BuildContext context, AsyncSnapshot<GetKapalCoor> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
                        return Container(
                          child: Text(snapshot.data!.message!),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
            ),
            // Flexible(
            //   child: FlutterMap(
            //     mapController: controller.mapController,
            //     options: MapOptions(
            //       onMapEvent: (event) {
            //         controller.updatePoint(null);
            //       },
            //       minZoom: 4,
            //       maxZoom: 18,
            //       initialZoom: 10,
            //       initialCenter: const LatLng(-1.089955, 117.360343),
            //       onPositionChanged: (position, hasGesture) {
            //         controller.currentZoom.value = (position.zoom! - 8) * 5;
            //       },
            //     ),
            //     nonRotatedChildren: [
            //       /// button zoom in/out kanan bawah
            //       const FlutterMapZoomButtons(
            //         minZoom: 4,
            //         maxZoom: 18,
            //         mini: true,
            //         padding: 10,
            //         alignment: Alignment.bottomRight,
            //       ),

            //       /// widget skala kiri atas
            //       ScaleLayerWidget(
            //         options: ScaleLayerPluginOption(
            //           lineColor: Colors.blue,
            //           lineWidth: 2,
            //           textStyle: const TextStyle(color: Colors.blue, fontSize: 12),
            //           padding: const EdgeInsets.all(10),
            //         ),
            //       ),

            //       /// widget berisi detail informasi kapal
            //       // if (BlocProvider.of<GeneralCubit>(context).vesselClicked != null) VesselDetail(),
            //     ],
            //     children: [
            //       TileLayer(
            //         urlTemplate:
            //             // Google RoadMap
            //             // 'https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
            //             // Google Altered roadmap
            //             // 'https://mt0.google.com/vt/lyrs=r&hl=en&x={x}&y={y}&z={z}',
            //             // Google Satellite
            //             // 'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}',
            //             // Google Terrain
            //             // 'https://mt0.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}',
            //             // Google Hybrid
            //             'https://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&User-Agent=BinavAvts/1.0',
            //         // Open Street Map
            //         // 'https://c.tile.openstreetmap.org/{z}/{x}/{y}.png',
            //         userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            //         // tileProvider: CancellableNetworkTileProvider(),
            //       ),
            //       Obx(() {
            //         final LatLng? latLng = controller.latLng.value;

            //         return MarkerLayer(
            //           markers: [
            //             if (latLng != null)
            //               Marker(
            //                 width: controller.pointSize.value,
            //                 height: controller.pointSize.value,
            //                 point: latLng,
            //                 child: CircleAvatar(
            //                   child: Image.asset(
            //                     "assets/compass.png",
            //                     width: 250,
            //                     height: 250,
            //                   ),
            //                 ),
            //               ),
            //           ],
            //         );
            //       }),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
