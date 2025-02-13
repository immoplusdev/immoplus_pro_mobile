// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';
import 'package:lottie/lottie.dart';

import 'components/map_bottom_sheet.dart';

class LocationMapPage extends StatelessWidget {
  LocationMapPage({super.key});
  static String name = 'LocationMapPage';
  final controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(5.30966, -4.01266)),
            myLocationButtonEnabled: false,
            onMapCreated: controller.onMapCreated,
            onTap: (argument) => controller.moveToLocation(argument),
            onCameraIdle: () => controller.onCameraIdle(),
            onCameraMove: (position) => controller.onCameraMove(position),
          ),
          Lottie.asset(
            "assets/animations/place-marker.json",
            fit: BoxFit.contain,
            width: 100,
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            left: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const MapBottomSheet(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
