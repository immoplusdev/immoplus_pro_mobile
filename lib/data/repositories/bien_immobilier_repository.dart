import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/dio_client.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_response.dart';
import 'package:immoplus_pro/data/providers/bien_immobilier_provider.dart';
import 'package:immoplus_pro/data/providers/reservation_provider.dart';
import 'package:immoplus_pro/data/providers/residence_provider.dart';

class BienImmobilierRepository {
  static Future<BienImmobilierCollection> getBiensImmobiliers(
      int page, int perPage) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(DioClient().dio)
          .getImmobiliers(page, perPage);
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

  static Future<DemandeVisiteCollection> getVisitesOwner(
      {required String id, required int page, required int perPage}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(DioClient().dio)
          .getVisiteOwner(id, page, perPage);
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

  static Future<BienImmobilierModel> createBienImmobilier(
      {required BienImmobilierCreationModel model}) async {
    try {
      final response = await BienImmobilierProvider(DioClient().dio)
          .createBienImmobilier(model);
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

  static Future<BienImmobilierModel> getBiensImmobilier(String id) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await BienImmobilierProvider(DioClient().dio).getImmobilier(id);

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
