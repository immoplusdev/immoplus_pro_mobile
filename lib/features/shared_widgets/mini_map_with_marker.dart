import 'package:flutter/material.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:map_launcher/map_launcher.dart' as mpl;

/// Carte miniature réutilisable avec un marqueur cliquable (ouvre l'app cartes).
class MiniMapWithMarker extends StatefulWidget {
  const MiniMapWithMarker({
    super.key,
    required this.lat,
    required this.lng,
    required this.title,
    this.markerColor,
    this.height = 200,
    this.borderRadius = 12,
    this.horizontalPadding = 16,
  });

  final double lat;
  final double lng;
  final String title;
  final Color? markerColor;
  final double height;
  final double borderRadius;
  final double horizontalPadding;

  @override
  State<MiniMapWithMarker> createState() => _MiniMapWithMarkerState();
}

class _MiniMapWithMarkerState extends State<MiniMapWithMarker> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker();
  }

  Future<void> _addMarker() async {
    final lat = widget.lat;
    final lng = widget.lng;
    final title = widget.title;
    final color = widget.markerColor ?? AppColors.primary;

    final customMarker = await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: const MarkerId('detailMarker'),
        position: LatLng(lat, lng),
        onTap: () async {
          if (await mpl.MapLauncher.isMapAvailable(mpl.MapType.google) ??
              false) {
            mpl.MapLauncher.showDirections(
              destinationTitle: title,
              destination: mpl.Coords(lat, lng),
              directionsMode: mpl.DirectionsMode.driving,
              mapType: mpl.MapType.google,
            );
          } else {
            final availableMaps = await mpl.MapLauncher.installedMaps;
            if (availableMaps.isNotEmpty) {
              await availableMaps.first.showDirections(
                destinationTitle: title,
                destination: mpl.Coords(lat, lng),
                directionsMode: mpl.DirectionsMode.driving,
              );
            }
          }
        },
      ),
      shape: MarkerShape.bubble,
      imagePixelRatio: 2,
      title: title,
      textSize: 35,
      backgroundColor: color,
    );

    if (mounted) {
      setState(() => _markers.add(customMarker));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: SizedBox(
          height: widget.height,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lng),
              zoom: 14,
            ),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {},
          ),
        ),
      ),
    );
  }
}
