import 'package:binav_avts_getx/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../../controller/map.dart';

class RulerDetail extends StatefulWidget {
  RulerDetail({Key? key}) : super(key: key);
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  @override
  State<RulerDetail> createState() => _RulerDetailState();
}

class _RulerDetailState extends State<RulerDetail> with TickerProviderStateMixin {
  var mapGetController = Get.find<MapGetXController>();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = mapGetController.mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '${RulerDetail._startedId}#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = RulerDetail._finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = RulerDetail._inProgressId;
      }

      hasTriggeredMove |= mapGetController.mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Future<void> viewMarkerRuler(LatLng latLng) async {
    _animatedMapMove(latLng, GetStorage().read("currentZoom"));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (!mapGetController.isRulerDetail.value)
          ? Tooltip(
              message: "Ruler Detail",
              child: Container(
                margin: EdgeInsets.all(10),
                child: IconButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    mapGetController.isRulerDetail.value = true;
                  },
                  icon: Icon(
                    Icons.design_services,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          : Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  Container(
                    width: 320,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 20,
                              // width: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                                    elevation: MaterialStatePropertyAll(0),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                                onPressed: () {
                                  mapGetController.isRulerDetail.value = false;
                                },
                                child: Text("X"),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 3,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Column(
                            children: [
                              Container(
                                // width: 300,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: const BorderSide(width: 1, color: Colors.black),
                                    left: BorderSide(width: 1, color: Colors.black),
                                    right: BorderSide(width: 1, color: Colors.black),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Ruler Detail',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 61, 61, 61),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxHeight: 300),
                                child: SingleChildScrollView(
                                  child: Table(
                                    // defaultColumnWidth: FlexColumnWidth(100),
                                    border: TableBorder.all(width: 1, color: Colors.black),

                                    // Set default column width constraints
                                    columnWidths: {
                                      0: const FlexColumnWidth(1.0),
                                      1: const FlexColumnWidth(4.0),
                                      2: const FlexColumnWidth(2.0),
                                    },
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              ' No.',
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              ' Distance from latest marker',
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              " View Marker",
                                            ),
                                          ),
                                        ],
                                      ),
                                      for (var i = 0;
                                          i < mapGetController.markersLatLng.length;
                                          i++)
                                        TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                (i + 1).toString(),
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                i > 0
                                                    ? "${General.numberFormat.format(mapGetController.calculateDistance(mapGetController.markersLatLng[i - 1], mapGetController.markersLatLng[i]))} M"
                                                    : "0 M",
                                              ),
                                            ),
                                            TableCell(
                                              child: IconButton(
                                                onPressed: () {
                                                  viewMarkerRuler(
                                                      mapGetController.markersLatLng[i]);
                                                },
                                                icon: Icon(
                                                  Icons.location_on,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                // width: 300,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: const BorderSide(width: 1, color: Colors.black),
                                    left: BorderSide(width: 1, color: Colors.black),
                                    right: BorderSide(width: 1, color: Colors.black),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Total',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 61, 61, 61),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxHeight: 300),
                                child: SingleChildScrollView(
                                  child: Table(
                                    // defaultColumnWidth: FlexColumnWidth(100),
                                    border: TableBorder.all(width: 1, color: Colors.black),

                                    // Set default column width constraints
                                    columnWidths: {
                                      0: const FlexColumnWidth(4.0),
                                      1: const FlexColumnWidth(4.0),
                                    },
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              ' Total Marker',
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              ' Total Distance From Start to End',
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          TableCell(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              ' ${General.numberFormat.format(mapGetController.markersLatLng.length)}',
                                            ),
                                          ),
                                          TableCell(
                                            child: Obx(
                                              () {
                                                var total = 0.0;

                                                for (var i = 1;
                                                    i < mapGetController.markersLatLng.length;
                                                    i++) {
                                                  total += mapGetController.calculateDistance(
                                                      mapGetController.markersLatLng[i - 1],
                                                      mapGetController.markersLatLng[i]);
                                                }
                                                return Text(
                                                  textAlign: TextAlign.center,
                                                  ' ${General.numberFormat.format(total)} M',
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
