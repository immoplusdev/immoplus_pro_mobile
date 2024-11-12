import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:latlong2/latlong.dart';

class DetailEstateMap extends StatefulWidget {
  DetailEstateMap({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  _DetailEstateMapState createState() => _DetailEstateMapState();
}

class _DetailEstateMapState extends State<DetailEstateMap> {
  // Uint8List? markerIcon;

  @override
  Widget build(BuildContext context) {
    return (widget.bienImmobilier.position.coordinates.isNotEmpty)
        ? SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    print(point);
                  },
                  initialCenter: LatLng(
                    widget.bienImmobilier.position.coordinates.last,
                    widget.bienImmobilier.position.coordinates.first,
                  ),
                  initialZoom: 13.4,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          widget.bienImmobilier.position.coordinates.last,
                          widget.bienImmobilier.position.coordinates.first,
                        ), // Position du marqueur
                        child: const Icon(
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
