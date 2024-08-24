import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/core/dio_client.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_response.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_response.dart';
import 'package:immoplus_pro/data/providers/reservation_provider.dart';
import 'package:immoplus_pro/data/providers/residence_provider.dart';

class LogmentRepository {
  static Future<ReservationsResponse> getReservations(
      int page, int perPage) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ReservationProvider(DioClient().dio).getBookings(page, perPage);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<ReservationsResponse> getReservationsOwner(
      {required String id}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ReservationProvider(DioClient().dio).getBookingsOwner(id);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<ReservationResponse> getReservation(
      {required String id}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ReservationProvider(DioClient().dio).getBooking(id);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<ResidenceResponse> createResidence(
      {required ResidenceCreationModel model}) async {
    try {
      final response =
          await ResidenceProvider(DioClient().dio).createResidence(model);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<ResidencesResponse> getResidences({required int page}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ResidenceProvider(DioClient().dio).getResidences(page);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<ResidenceResponse> getResidence(String id) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ResidenceProvider(DioClient().dio).getResidence(id);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
