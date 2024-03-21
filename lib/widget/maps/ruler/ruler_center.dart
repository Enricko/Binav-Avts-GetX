import 'package:binav_avts_getx/controller/map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/general.dart';

class RulerCenter extends StatelessWidget {
   RulerCenter({super.key});

  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (mapGetController.countDistance.value) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_searching_outlined, color: Colors.white, size: 15),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Text(
                          mapGetController.markersLatLng.isNotEmpty
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
            ),
          ],
        );
      }
      return SizedBox();
    });
  }
}
