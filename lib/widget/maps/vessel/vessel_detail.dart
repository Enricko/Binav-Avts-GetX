import 'dart:async';

import 'package:binav_avts_getx/controller/map.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import 'package:binav_avts_getx/widget/maps/vessel/vessel_draw.dart';
import 'package:binav_avts_getx/widget/snipping_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../../services/init.dart';

// ignore: must_be_immutable
class VesselDetail extends StatelessWidget {
  VesselDetail({super.key});
  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Obx(
          () => SnappingSheet(
            controller: mapGetController.snappingSheetController.value,
            // child: Background(),
            lockOverflowDrag: true,
            snappingPositions: [
              SnappingPosition.factor(
                snappingCurve: Curves.elasticOut,
                snappingDuration: const Duration(milliseconds: 1750),
                positionFactor: (301.74 / MediaQuery.of(context).size.height),
              ),
              const SnappingPosition.factor(
                positionFactor: 0.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.factor(
                snappingCurve: Curves.elasticOut,
                snappingDuration: const Duration(milliseconds: 1750),
                positionFactor: (500 / MediaQuery.of(context).size.height),
              ),
            ],
            grabbing: GrabbingWidget(),
            grabbingHeight: 75,
            sheetAbove: null,
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: StreamBuilder<KapalCoor.GetKapalCoor>(
                stream: mapGetController.streamSocketKapal.value.socketResponseSingleKapal.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
                    KapalCoor.Data data = snapshot.data!.data!.first;
                    return Obx(
                      () {
                        if (mapGetController.getVessel.value) {
                          String gpsQualityIndicator = data.coor!.coorGga!.gpsQualityIndicator!.split(',')[0].trim();
                          return SingleChildScrollView(
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      mapGetController.snappingSheetController.value.snapToPosition(
                                        const SnappingPosition.factor(positionFactor: -0.5),
                                      );
                                      Timer(const Duration(milliseconds: 300), () {
                                        mapGetController.socketSingleKapalDisconnect();
                                        mapGetController.socketSingleKapalLatlongDisconnect();
                                        mapGetController.getVessel.value = false;
                                        mapGetController.streamSocketKapal.value
                                            .refreshSingleKapal();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: const BoxDecoration(color: Colors.black12),
                                        padding: const EdgeInsets.all(4),
                                        child: const Center(
                                          child: Text(
                                            "X",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data.callSign}",
                                              style: const TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${data.flag}",
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        (data.image! == "" || data.image! == null)
                                            ? Image.asset(
                                                "assets/model_kapal.jpg",
                                                width: 100,
                                              )
                                            : Image.network(
                                                InitService.baseUrl! +
                                                    "assets/kapal_image/" +
                                                    data.image!,
                                                width: 100,
                                              )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Position Information".toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Latitude',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data.coor!.coorGga!.latitude!.toStringAsFixed(8)}",
                                                      // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).latitude.toStringAsFixed(5)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Longitude',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data.coor!.coorGga!.longitude!.toStringAsFixed(8)}",
                                                      // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).longitude.toStringAsFixed(5)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "More Vessel Information".toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Telnet Status',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.circle,
                                                              size: 15,
                                                              color: data.telnetStatus!
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: data.telnetStatus!
                                                                ? "Connected"
                                                                : "Disconnected",
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color:
                                                                  Color.fromARGB(255, 61, 61, 61),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'SOG',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.coor!.coorVtg!.speedInKnots == null
                                                          ? "VTG Not Detected"
                                                          : "${data.coor!.coorVtg!.speedInKnots} KTS",
                                                      // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).longitude.toStringAsFixed(5)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Heading Degree',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data.coor!.coorHdt!.headingDegree ?? data.coor!.defaultHeading}",
                                                      // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).longitude.toStringAsFixed(5)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'SOLN',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${gpsQualityIndicator}",
                                                      // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).longitude.toStringAsFixed(5)}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromARGB(255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const Text(
                                  //   "Vessel",
                                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  // ),
                                  // VesselDrawer(
                                  //     link: InitService.baseUrl! + "assets/kapal/" + data.xmlFile!),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    );
                  }
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
