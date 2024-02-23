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
      stream: mapGetController.streamSocketKapal.value.socketResponseSingleWindowKapal.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
          KapalCoor.Data data = snapshot.data!.data!.first;
          // if (mapGetController.getVessel.value) {
          return Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              // width: 100,
              // height: 300,
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
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
                          '${data.callSign!}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 61, 61, 61),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Table(
                        // defaultColumnWidth: FlexColumnWidth(100),
                        border: TableBorder.all(width: 1, color: Colors.black),

                        // Set default column width constraints
                        columnWidths: {
                          0: const FlexColumnWidth(2.0),
                          1: const FlexColumnWidth(4.0),
                        },
                        children: <TableRow>[
                          // const TableRow(
                          //   children: <Widget>[
                          //     TableCell(
                          //       child: Text(' East'),
                          //     ),
                          //     TableCell(
                          //       child: Text(' John Doe'),
                          //     ),
                          //   ],
                          // ),
                          // const TableRow(
                          //   children: <Widget>[
                          //     TableCell(
                          //       child: Text(' North'),
                          //     ),
                          //     TableCell(
                          //       child: Text(' 30'),
                          //     ),
                          //   ],
                          // ),
                          TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Text(' Lat'),
                              ),
                              TableCell(
                                child: Text(textAlign: TextAlign.right," ${data.coor!.coorGga!.latitude!.toStringAsFixed(5)}"),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Text(' Long'),
                              ),
                              TableCell(
                                child: Text(
                                  textAlign: TextAlign.right,' ${data.coor!.coorGga!.longitude!.toStringAsFixed(5)}'),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Text(
                                  ' Heading(True)',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TableCell(
                                child: Text(textAlign: TextAlign.right,' ${data.coor!.coorHdt!.headingDegree ?? data.coor!.defaultHeading}'),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Text(' SOG'),
                              ),
                              TableCell(
                                child: Text(textAlign: TextAlign.right,' ${data.coor!.coorVtg!.speedInKnots} kts'),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Text(' Soin'),
                              ),
                              TableCell(
                                child: Text(textAlign: TextAlign.right,' ${data.coor!.coorGga!.gpsQualityIndicator}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // }
          // return SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}
