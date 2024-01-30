import 'dart:convert';

import 'package:binav_avts_getx/controller/mapping.dart';
import 'package:binav_avts_getx/model/get_mapping_response.dart' as GetMapping;
import 'package:binav_avts_getx/services/init.dart';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import '../../controller/map.dart';

class KmlPolygon {
  final List<LatLng> points;
  final String color;

  KmlPolygon({required this.points, required this.color});
  Map<String, dynamic> toJson() {
    // Convert your KmlPolygon properties to a JSON-serializable map
    return {
      'points': points.map((point) => {'latitude': point.latitude, 'longitude': point.longitude}).toList(),
      'color': color,
    };
  }
}

class Points {
  final List<Map<String, double>> points;
  final String color;

  Points({required this.points, required this.color});

  // factory Points.fromJson(List<dynamic> jsonList) {
  //   List<Map<String, double>> pointsList = jsonList.map((jsonMap) {
  //     return {
  //       'latitude': jsonMap['latitude'] as double,
  //       'longitude': jsonMap['longitude'] as double,
  //     };
  //   }).toList();
  //   return Points(points: pointsList);
  // }

  List<dynamic> toJson() {
    return points.toList();
  }
}

class PipelineLayer extends StatelessWidget {
  PipelineLayer({super.key});
  var mapGetController = Get.find<MapGetXController>();
  var mappingController = Get.find<MappingController>();

  Future<void> loadKMZData(BuildContext context, List<GetMapping.Data> mappingData) async {
    // try {
    String url = InitService.baseUrl + "assets/mapping/";
    var box = GetStorage();
    Map<String, dynamic> data = {};

    for (var e in mappingData) {
      if (box.read("kmlOverlayPolygons") != null) {
        data = box.read("kmlOverlayPolygons");
        if ((!data.containsKey(e.file!) && e.file!.isNotEmpty)) {
          if (e.status == true) {
            final response = await http.get(Uri.parse(url + e.file!));
            if (e.file!.endsWith(".kmz")) {
              if (response.statusCode < 400) {
                final kmlData = extractKMLDataFromKMZ(response.bodyBytes);
                if (kmlData != null) {
                  var parse = parseKmlForOverlay(kmzData: kmlData);
                  data[e.file!] = parse.map((e) => e.toJson()).toList();
                }
              } else {
                throw Exception('Failed to load KMZ data: ${response.statusCode}');
              }
            } else if (e.file!.endsWith(".kml")) {
              var parse = parseKmlForOverlay(kmlData: response.body);
              data[e.file!] = parse.map((e) => e.toJson()).toList();
            }
          } else {
            continue;
          }
        }
      } else {
        if (e.status == true) {
          final response = await http.get(Uri.parse(url + e.file!));
          if (e.file!.endsWith(".kmz")) {
            if (response.statusCode < 400) {
              final kmlData = extractKMLDataFromKMZ(response.bodyBytes);
              if (kmlData != null) {
                var parse = parseKmlForOverlay(kmzData: kmlData);
                data[e.file!] = parse.map((e) => e.toJson()).toList();
              }
            } else {
              throw Exception('Failed to load KMZ data: ${response.statusCode}');
            }
          } else if (e.file!.endsWith(".kml")) {
            var parse = parseKmlForOverlay(kmlData: response.body);
            data[e.file!] = parse.map((e) => e.toJson()).toList();
          }
        } else {
          continue;
        }
      }
    }
    box.write('kmlOverlayPolygons', data);
  }

  List<KmlPolygon> parseKmlForOverlay({List<int>? kmzData, String? kmlData}) {
    final List<KmlPolygon> polygons = [];
    xml.XmlDocument? doc;

    if (kmzData != null) {
      doc = xml.XmlDocument.parse(utf8.decode(kmzData));
    } else if (kmlData != null) {
      doc = xml.XmlDocument.parse(kmlData);
    }

    final Iterable<xml.XmlElement> placemarks = doc!.findAllElements('Placemark');
    for (final placemark in placemarks) {
      final xml.XmlElement? extendedDataElement = placemark.getElement("ExtendedData");
      final xml.XmlElement? schemaDataElement = extendedDataElement!.getElement("SchemaData");
      final Iterable<xml.XmlElement> simpleDataElement = schemaDataElement!.findAllElements("SimpleData");
      final subClass =
          simpleDataElement.where((element) => element.getAttribute("name") == "SubClasses").first.innerText;
      if (subClass == "AcDbEntity:AcDb2dPolyline" || subClass == "AcDbEntity:AcDbPolyline") {
        final styleElement = placemark.findAllElements('Style').first;
        final lineStyleElement = styleElement.findElements('LineStyle').first;
        final colorLine = lineStyleElement.findElements('color').first.innerText;

        final xml.XmlElement? polygonElement = placemark.getElement('LineString');
        if (polygonElement != null) {
          final List<LatLng> polygonPoints = [];

          final xml.XmlElement? coordinatesElement = polygonElement.getElement('coordinates');
          if (coordinatesElement != null) {
            final String coordinatesText = coordinatesElement.text;
            final List<String> coordinateList = coordinatesText.split(' ');

            for (final coordinate in coordinateList) {
              final List<String> latLng = coordinate.split(',');
              if (latLng.length >= 2) {
                double? latitude = double.tryParse(latLng[1]);
                double? longitude = double.tryParse(latLng[0]);
                if (latitude != null && longitude != null) {
                  polygonPoints.add(LatLng(latitude, longitude));
                }
              }
            }
          }

          // print(placemark.getElement('styleUrl')!.text);
          if (polygonPoints.isNotEmpty) {
            polygons.add(KmlPolygon(points: polygonPoints, color: colorLine));
          }
        }
      }
    }

    return polygons;
    // MappingLayerStreamController
  }

  List<int>? extractKMLDataFromKMZ(List<int> kmzData) {
    final archive = ZipDecoder().decodeBytes(Uint8List.fromList(kmzData));

    for (final file in archive) {
      if (file.name.endsWith('.kml')) {
        return file.content;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GetMapping.GetMappingResponse>(
      stream: mappingController.streamSocketMapping.value.getResponseAll,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          loadKMZData(context, snapshot.data!.data!);
          var box = GetStorage();
          if (box.read("kmlOverlayPolygons") != null) {
            Map<String, dynamic> data = json.decode(json.encode(box.read("kmlOverlayPolygons")));
            return Stack(
              children: data.entries.map((x) {
                return PolylineLayer(polylines: [
                  for (var y in x.value)
                    Polyline(
                      strokeWidth: 3,
                      points: [for (var k in y['points']) LatLng(k['latitude'], k['longitude'])],
                      color: Color(
                        int.parse(
                          y['color'],
                          radix: 16,
                        ),
                      ),
                    )
                ]);
              }).toList(),
            );
          }
          return SizedBox();
        }
        return Container();
      },
    );
  }
}
