import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:latlong2/latlong.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class DetailLogmentMap extends StatefulWidget {
  DetailLogmentMap({super.key, required this.residence});
  final ResidenceModel residence;
  @override
  _DetailLogmentMapState createState() => _DetailLogmentMapState();
}

class _DetailLogmentMapState extends State<DetailLogmentMap> {
  // Uint8List? markerIcon;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getBytesFromAsset('assets/icon/marker.png', 130).then((value) {
  //     setState(() {
  //       markerIcon = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return (widget.residence.position != null)
        ? SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    print(point);
                  },
                  initialCenter: LatLng(
                    widget.residence.position.coordinates.last,
                    widget.residence.position.coordinates.first,
                  ),
                  initialZoom: 18.4,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  const MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(48.8584, 2.2945), // Position du marqueur
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
