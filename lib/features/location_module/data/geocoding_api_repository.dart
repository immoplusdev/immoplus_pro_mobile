import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/dio_client_exception.dart';
import 'package:immoplus_pro/data/models/configs/reverse_geocoding_response.dart';
import 'package:immoplus_pro/features/location_module/data/geocoding_api_provider.dart';

class GeocodingApiRepository {
  /// Reverse geocoding (address lookup)
  Future<ReverseGeocodingResponse> geocodingAddressLookup(
      {double? latitude, double? longitude}) async {
    try {
      final response =
          await GeocodingApiProvider(DioClient().dio).geocodingAddressLookup(
        key: dotenv.env['GOOGLE_API_KEY']!,
        latlng: (latitude != null && longitude != null)
            ? [latitude, longitude].join(",")
            : null,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  /// Geocoding (latitude/longitude lookup)
  Future<ReverseGeocodingResponse> geocodingLatLngLookup(
      {String? placeId}) async {
    try {
      final response =
          await GeocodingApiProvider(DioClient().dio).geocodingLatLngLookup(
        key: dotenv.env['GOOGLE_API_KEY']!,
        placeId: placeId,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }
}
