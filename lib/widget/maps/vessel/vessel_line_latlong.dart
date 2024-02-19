import 'package:binav_avts_getx/controller/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class VesselLineLatlong extends StatelessWidget {
  VesselLineLatlong({super.key});

  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mapGetController.streamSocketKapal.value.getResponseSingleLatlong,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
          return Obx(
            () {
              if (snapshot.data!.data!.length > 0 && mapGetController.getVessel.value) {
                return PolylineLayer(
                  polylines: [
                    Polyline(
                      strokeWidth: 5,
                      points: [
                        for (var x in snapshot.data!.data!) LatLng(x.latitude!, x.longitude!),
                        // for (var i in value.vesselCoorResult)
                        // if (value.searchKapal != null)
                        //   if (value.searchKapal!.kapal!.callSign == value.onClickVessel)
                        //     LatLng(
                        //         predictLatLong(
                        //                 value.searchKapal!.coor!.coorGga!.latitude!
                        //                     .toDouble(),
                        //                 value.searchKapal!.coor!.coorGga!.longitude!
                        //                     .toDouble(),
                        //                 100,
                        //                 value.searchKapal!.coor!.coorHdt!.headingDegree ??
                        //                     value.searchKapal!.coor!.defaultHeading!
                        //                         .toDouble(),
                        //                 value.predictMovementVessel)
                        //             .latitude,
                        //         predictLatLong(
                        //                 value.searchKapal!.coor!.coorGga!.latitude!
                        //                     .toDouble(),
                        //                 value.searchKapal!.coor!.coorGga!.longitude!
                        //                     .toDouble(),
                        //                 100,
                        //                 value.searchKapal!.coor!.coorHdt!.headingDegree ??
                        //                     value.searchKapal!.coor!.defaultHeading!
                        //                         .toDouble(),
                        //                 value.predictMovementVessel)
                        //             .longitude
                        //         // i.coorGga!.latitude!.toDouble() + (predictMovementVessel * (9.72222 / 111111.1)),
                        //         //   i.coorGga!.longitude!.toDouble()
                        //         ),
                      ],
                      color: Colors.blue,
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
