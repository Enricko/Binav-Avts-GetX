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
            points: mapGetController.markersLatLng.value.map((e) => e).toList(),
            color: Colors.blueAccent,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}
