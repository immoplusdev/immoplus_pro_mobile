import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_single.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/date_demande_visite.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/visit_programmer_body.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_collection.dart';
import 'package:immoplus_pro/data/providers/bien_immobilier_provider.dart';
import 'package:immoplus_pro/data/providers/reservation_provider.dart';
import 'package:immoplus_pro/data/providers/residence_provider.dart';

class BienImmobilierRepository {
  static Future<BienImmobilierCollection> getBiensImmobiliers({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(DioClient().dio)
          .getImmobiliers(page, where, perPage, orderBy, orderDir);
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

  static Future<DemandeVisitResponse> getVisit({required String id}) async {
    try {
      final response =
          await BienImmobilierProvider(DioClient().dio).getVisite(id);
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

  static Future<DemandeVisiteCollection> getVisitesOwner({
    required String id,
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(DioClient().dio)
          .getVisiteOwner(id, where, page, perPage, orderBy, orderDir);
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

  static Future<BienImmobilierSingle> createBienImmobilier(
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

  static Future<BienImmobilierSingle> update(
      {required String id, required Map<String, dynamic> fields}) async {
    try {
      final response =
          await BienImmobilierProvider(DioClient().dio).update(id, fields);
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

  static Future<ResidencesCollection> getResidences({
    required int page,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await ResidenceProvider(DioClient().dio)
          .getResidences(where, page, orderBy, orderDir);

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

  static Future<BienImmobilierSingle> getBiensImmobilier(String id) async {
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

  static Future<DemandeVisiteModel?> programmerVisit(
      String id, DateTime date) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(DioClient().dio).programmer(
          id,
          VisitProgrammerBody(
              datesDemandeVisite: [DateDemandeVisite(date: date)]));

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      return null;
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      return null;
    }
  }

  static Future<bool> deleteBienImmobilier({required String id}) async {
    try {
      final httpResponse = await BienImmobilierProvider(DioClient().dio)
          .deleteBienImmobilier(id);

      // Vérifie si la suppression s'est bien passée (status 200-299)
      if (httpResponse.response.statusCode == 200) {
        log('Bien immobilier supprimé avec succès: $id');
        return true;
      } else {
        log('Erreur lors de la suppression: ${httpResponse.response.statusCode}');
        return false;
      }
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete property: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to delete property: $error');
    }
  }
}
