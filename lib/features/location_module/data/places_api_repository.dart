import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/dio_client_exception.dart';
import 'package:immoplus_pro/data/models/configs/autocomplete_response.dart';
import 'package:immoplus_pro/features/location_module/data/places_api_provider.dart';

class PlacesApiRepository {
  /// Get Place Details (New)
  Future<PlaceDetails> getPlaceDetails({required String placeId}) async {
    try {
      final response = await PlacesApiProvider(DioClient().dio).getPlaceDetails(
        key: dotenv.env['GOOGLE_API_KEY']!,
        placeId: placeId,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  Future<AutocompleteResponse> getPlaceAutocomplete(
      {required String input, String? sessionToken}) async {
    try {
      final response = await PlacesApiProvider(DioClient().dio)
          .getPlaceAutocomplete(
              input: input,
              key: dotenv.env['GOOGLE_API_KEY']!,
              sessiontoken: sessionToken);
      return compute(_parsePlacesAutocompleteResponse, response);
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  AutocompleteResponse _parsePlacesAutocompleteResponse(
      AutocompleteResponse data) {
    data.predictions?.forEach((element) => element.reference = null);
    return data;
  }
}
