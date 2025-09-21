// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:immoplus_pro/features/location_module/data/geocoding_api_repository.dart';
import 'package:immoplus_pro/features/location_module/data/places_api_repository.dart';

abstract class AppLocationSettings {
  static const int getLocationTimeLimit = 20; //in seconds
  static const int locationChangeInterval = 5; //in seconds
  static const int locationChangeDistance = 250; //in meters
}

class LocationService extends GetxService {
  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;

  late LocationSettings locationSettings;

  // ignore: unused_field
  Position? _previousPosition;

  GeocodingApiRepository geocodingApiRepository = GeocodingApiRepository();
  PlacesApiRepository placesApiRepository = PlacesApiRepository();

  @override
  void onInit() {
    super.onInit();
    //_toggleServiceStatusStream();
    _init();
  }

  @override
  void onClose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription?.cancel();
    }
  }

  _init() async {
    // locationServiceStatus.listen((p0) {
    //   if (p0 &&
    //       [LocationPermission.always, LocationPermission.whileInUse]
    //           .any((p0) => p0 == locationPermissionStatus.value)) {
    //     listen();
    //   } else {
    //     stopListen();
    //   }
    // });

    // locationPermissionStatus.listen((status) {
    //   if (locationServiceStatus.isTrue &&
    //       [LocationPermission.always, LocationPermission.whileInUse]
    //           .any((p0) => p0 == status)) {
    //     listen();
    //   } else {
    //     stopListen();
    //   }

    //   if ([LocationPermission.always, LocationPermission.whileInUse]
    //       .any((p0) => p0 == status)) {
    //     GetStorage().remove(Constants.locationPermission);
    //   }
    // });

    // if (locationServiceStatus.isTrue &&
    //     [LocationPermission.always, LocationPermission.whileInUse]
    //         .any((p0) => p0 == locationPermissionStatus.value)) {
    //   listen();
    // }
  }

  // Get current position
  static Future<Position> getCurrentPosition() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      locationPermission = await Geolocator.requestPermission();
    }
    if ([
      LocationPermission.always,
      LocationPermission.whileInUse,
    ].any((element) => element == locationPermission)) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } else {
      throw Exception('Location permissions are denied.');
    }
  }

  /// Vérifie si les permissions de localisation sont accordées
  static Future<bool> hasLocationPermission() async {
    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }
}
