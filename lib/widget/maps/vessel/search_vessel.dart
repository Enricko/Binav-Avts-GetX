import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:searchfield/searchfield.dart';
import 'package:binav_avts_getx/model/get_kapal_coor.dart' as KapalCoor;

import '../../../controller/map.dart';

class SearchVessel extends StatefulWidget {
  const SearchVessel({super.key});

  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  @override
  State<SearchVessel> createState() => _SearchVesselState();
}

class _SearchVesselState extends State<SearchVessel> with TickerProviderStateMixin {
  TextEditingController searchVessel = TextEditingController();
  var mapGetController = Get.find<MapGetXController>();

  Future<void> vesselOnClick(String callSign, LatLng latLng) async {
    mapGetController.getVessel.value = true;
    mapGetController.socketSingleKapal(callSign);
    mapGetController.socketSingleKapalLatlong(callSign);
    _animatedMapMove(latLng, 17);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = mapGetController.mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '${SearchVessel._startedId}#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = SearchVessel._finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = SearchVessel._inProgressId;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 50,
      // width: 500,
      child: SearchField(
        controller: searchVessel,
        suggestions: mapGetController.searchVessel
            .map(
              (e) {
            return SearchFieldListItem<KapalCoor.Data>(
              e.callSign!,
              item: e,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(e.callSign!),
                  ],
                ),
              ),
            );
          },
        )
            .where((e) => e.searchKey
            .toLowerCase()
            .contains(searchVessel.text.toLowerCase()))
            .toList(),
        searchInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: "Pilih Call Sign Kapal",
          // labelText: "Pilih Call Sign Kapal",
          hintStyle: const TextStyle(color: Colors.black),
          // labelStyle: TextStyle(color: Colors.black),
          // prefixIcon: const Padding(
          //   padding: EdgeInsets.all(10),
          //   child: Icon(Icons.search),
          // ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: (){
    if (searchVessel.text != "" || searchVessel.text != null) {
                var lat = mapGetController.searchVessel
                        .where((x) => searchVessel.text == x.callSign!)
                        .first
                        .coor!
                        .coorGga!
                        .latitude;
                    var long = mapGetController.searchVessel
                        .where((x) => searchVessel.text == x.callSign!)
                        .first
                        .coor!
                        .coorGga!
                        .longitude;
                    vesselOnClick(searchVessel.text, LatLng(lat!, long!));
                  }
                }, icon: Icon(Icons.search)),
          ),
          filled: true,
          fillColor: Colors.white,
          // fillColor: const Color.fromARGB(255, 230, 230, 230),
          prefixIconColor: Colors.black,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 3, color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 3, color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 3, color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        
      ),
    );

      // Row(
      //     children: [
      //       SizedBox(
      //         height: 50,
      //         // width: 500,
      //         child: SearchField(
      //           controller: searchVessel,
      //           suggestions: mapGetController.searchVessel
      //               .map(
      //                 (e) {
      //                   return SearchFieldListItem<KapalCoor.Data>(
      //                     e.callSign!,
      //                     item: e,
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: [
      //                           const SizedBox(
      //                             width: 10,
      //                           ),
      //                           Text(e.callSign!),
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               )
      //               .where((e) => e.searchKey
      //                   .toLowerCase()
      //                   .contains(searchVessel.text.toLowerCase()))
      //               .toList(),
      //           searchInputDecoration: InputDecoration(
      //             hintText: "Pilih Call Sign Kapal",
      //             // labelText: "Pilih Call Sign Kapal",
      //             hintStyle: const TextStyle(color: Colors.black),
      //             // labelStyle: TextStyle(color: Colors.black),
      //             prefixIcon: const Padding(
      //               padding: EdgeInsets.all(10),
      //               child: Icon(Icons.search),
      //             ),
      //             filled: true,
      //             fillColor: const Color.fromARGB(255, 230, 230, 230),
      //             prefixIconColor: Colors.black,
      //             border: OutlineInputBorder(
      //               borderSide: const BorderSide(
      //                   width: 3, color: Color.fromARGB(255, 230, 230, 230)),
      //               borderRadius: BorderRadius.circular(50),
      //             ),
      //
      //             enabledBorder: OutlineInputBorder(
      //               borderSide: const BorderSide(
      //                   width: 3, color: Color.fromARGB(255, 230, 230, 230)),
      //               borderRadius: BorderRadius.circular(50),
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         width: 10,
      //       ),
      //       InkWell(
      //         onTap: () {
      //           if (searchVessel.text != "" || searchVessel.text != null) {
      //             var lat = mapGetController.searchVessel
      //                 .where((x) => searchVessel.text == x.callSign!)
      //                 .first
      //                 .coor!
      //                 .coorGga!
      //                 .latitude;
      //             var long = mapGetController.searchVessel
      //                 .where((x) => searchVessel.text == x.callSign!)
      //                 .first
      //                 .coor!
      //                 .coorGga!
      //                 .longitude;
      //             vesselOnClick(searchVessel.text, LatLng(lat!, long!));
      //           }
      //         },
      //         child: Container(
      //           width: 50,
      //           height: 50,
      //           decoration: BoxDecoration(
      //             color: Colors.grey,
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: const Icon(Icons.search),
      //         ),
      //       ),
      //     ],
      //   );
  }
}
