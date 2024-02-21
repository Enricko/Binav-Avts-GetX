import 'package:flutter/material.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../../controller/map.dart';

class WindowVesselDetail extends StatelessWidget {
   WindowVesselDetail({Key? key}) : super(key: key);
  final SnappingSheetController snappingSheetController = SnappingSheetController();
  var mapGetController = Get.find<MapGetXController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KapalCoor.GetKapalCoor>(
        stream: mapGetController.streamSocketKapal.value
            .socketResponseSingleKapal.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.done ||
              snapshot.hasData) {
            KapalCoor.Data data =
                snapshot.data!.data!.first;
            if (mapGetController.getVessel.value) {
              return Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(10),
                  // width: 100,
                  // height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(
                              10),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1,
                                    color: Colors
                                        .black),
                                left: BorderSide(
                                    width: 1,
                                    color: Colors
                                        .black),
                                right: BorderSide(
                                    width: 1,
                                    color: Colors
                                        .black),
                              )),
                          child: Center(
                            child: Text(
                              '${data.callSign!}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(
                                    255, 61, 61, 61),
                                fontWeight: FontWeight
                                    .w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Table(
                            // defaultColumnWidth: FlexColumnWidth(100),
                            border: TableBorder.all(
                                width: 1,
                                color: Colors.black),

                            // Set default column width constraints
                            columnWidths: {
                              0: FlexColumnWidth(2.0),
                              1: FlexColumnWidth(4.0),
                            },
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(
                                        ' East'),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' John Doe'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(
                                        ' North'),
                                  ),
                                  TableCell(
                                    child: Text(' 30'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(' Lat'),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' New York'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(
                                        ' Long'),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' New York'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(
                                      ' Heading(True)',
                                      overflow: TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' New York'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(' SOG'),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' New York'),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Text(
                                        ' Soin'),
                                  ),
                                  TableCell(
                                    child:
                                    Text(' New York'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Container(
                        //       width: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration:
                        //       BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        //       child: const Text(
                        //         'East',
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Color.fromARGB(255, 61, 61, 61),
                        //           fontWeight: FontWeight.w700,
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration:
                        //       BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        //       child: Text(
                        //         "15052004.m",
                        //         // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).longitude.toStringAsFixed(5)}",
                        //         style: const TextStyle(
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.w600,
                        //           color: Color.fromARGB(255, 61, 61, 61),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Container(
                        //       width: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration:
                        //       BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        //       child: const Text(
                        //         'North',
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Color.fromARGB(255, 61, 61, 61),
                        //           fontWeight: FontWeight.w700,
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration:
                        //       BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        //       child: Text(
                        //         "15052004.m",
                        //         // "${predictLatLong(vesselData.coor!.coorGga!.latitude!.toDouble(), vesselData.coor!.coorGga!.longitude!.toDouble(), 100, vesselData.coor!.coorHdt!.headingDegree ?? vesselData.coor!.defaultHeading!, predictMovementVessel).latitude.toStringAsFixed(5)}",
                        //         style: const TextStyle(
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.w600,
                        //           color: Color.fromARGB(255, 61, 61, 61),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox();
          }
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
