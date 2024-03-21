import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../../controller/map.dart';
import '../../../utils/general.dart';

class MarkerCursorFollow extends StatelessWidget {
  MarkerCursorFollow({super.key});

  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return mapGetController.latLngCursor.value == null || !mapGetController.countDistance.value
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
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.black54, width: 1)),
                          // child: Icon(Icons.circ, color: Colors.blue,), // Ubah ikon sesuai kebutuhan Anda
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
                                  ? (mapGetController.calculateDistance(
                                              mapGetController.markersLatLng[
                                                  mapGetController.markersLatLng.length - 1],
                                              mapGetController.latLngCursor.value!) >
                                          0
                                      ? "${General.numberFormat.format(mapGetController.calculateDistance(mapGetController.markersLatLng[mapGetController.markersLatLng.length - 1], mapGetController.latLngCursor.value!))} M"
                                      : "")
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
    );
  }
}
