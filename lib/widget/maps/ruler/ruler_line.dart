import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../../controller/map.dart';

class RulerLine extends StatelessWidget {
  RulerLine({super.key});

  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PolylineLayer(
        polylines: [
          Polyline(
            points: [
              for (var x in mapGetController.markersLatLng.value) x,
              if (mapGetController.markersLatLng.length > 0) mapGetController.latLngCursor.value!
            ],
            color: Colors.blueAccent,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}
