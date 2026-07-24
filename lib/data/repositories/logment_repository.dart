import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/auth/withdraw_booking_history_dto.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_collection.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_collection.dart';
import 'package:immoplus_pro/data/providers/reservation_provider.dart';
import 'package:immoplus_pro/data/providers/residence_provider.dart';

class LogmentRepository {
  static Future<ReservationsCollection> getReservations({
    required int page,
    required int perPage,
    required String? orderBy,
    required String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getBookings(page, where, perPage, orderBy, orderDir);
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

  static Future<ReservationsCollection> getReservationsOwner({
    required String id,
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getBookingsOwner(id, where, page, perPage, orderBy, orderDir);
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

  static Future<ReservationsCollection> getAllReservationsOwner({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
  }) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getAllReservationsOwner(where, page, perPage, orderBy, orderDir);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<WithdrawBookingHistoryDto> getWithdrawReservations({
    required String userId,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ReservationProvider(DioClient().dio).withDrawHistory(userId);
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

  static Future<ReservationResponse> annulerReservations(
      {required String id}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ReservationProvider(DioClient().dio).annulerBookings(id);
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

  static Future<ResidenceResponse> updateResidence(
      {required Map<String, dynamic> fields, required String id}) async {
    try {
      final response =
          await ResidenceProvider(DioClient().dio).update(id, fields);
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

  static Future<bool> deleteResidence({required String id}) async {
    try {
      final httpResponse =
          await ResidenceProvider(DioClient().dio).deleteResidence(id);

      // Vérifie si la suppression s'est bien passée (status 200-299)
      if (httpResponse.response.statusCode == 200) {
        log('Residence supprimé avec succès: $id');
        return true;
      } else {
        log('Erreur lors de la suppression: ${httpResponse.response.statusCode}');
        return false;
      }
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete residence: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to delete residence: $error');
    }
  }

  static Future<ResidenceResponse> addUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    try {
      final response = await ResidenceProvider(DioClient().dio)
          .addUnavailabilityDates(id, {"dates": dates});
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to add unavailability dates: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to add unavailability dates: $error');
    }
  }

  static Future<ResidenceResponse> removeUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    try {
      final response = await ResidenceProvider(DioClient().dio)
          .removeUnavailabilityDates(id, {"dates": dates});
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to remove unavailability dates: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to remove unavailability dates: $error');
    }
  }

  static Future<ReservationsCollection> getReservationsEnAttenteReponse({
    required String ownerId,
    int? perPage,
    int? page,
    String? orderBy,
    String? orderDir,
  }) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getReservationsEnAttenteReponse(
        ownerId,
        perPage: perPage,
        page: page,
        orderBy: orderBy,
        orderDir: orderDir,
      );
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load reservations: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load reservations: $error');
    }
  }

  static Future<ReservationResponse> accepterReservation(String id) async {
    try {
      final response =
          await ReservationProvider(DioClient().dio).accepterReservation(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to accept reservation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to accept reservation: $error');
    }
  }

  static Future<ReservationResponse> refuserReservation(
    String id, {
    String? notes,
  }) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .refuserReservation(id, notes: notes);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to refuse reservation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to refuse reservation: $error');
    }
  }

  static Future<ResidenceResponse> updateUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    try {
      final response = await ResidenceProvider(DioClient().dio)
          .updateUnavailabilityDates(id, {"dates": dates});
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to update unavailability dates: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to update unavailability dates: $error');
    }
  }
}
