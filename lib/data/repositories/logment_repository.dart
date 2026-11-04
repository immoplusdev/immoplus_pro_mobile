import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/auth/withdraw_booking_history_dto.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/motif_echec_reponse_model.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/motifs_echec_response.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/submit_motif_echec_payload.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_collection.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_collection.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/providers/reservation_provider.dart';
import 'package:immoplus_pro/data/providers/residence_provider.dart';
import 'package:immoplus_pro/services/refusal_follow_up_tracker.dart';

class LogmentRepository {
  /// Champ du tarif dans le payload de mise à jour d'une résidence.
  static const String _priceField = 'prixReservation';

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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  static Future<ResidenceResponse> updateResidence(
      {required Map<String, dynamic> fields, required String id}) async {
    try {
      final response =
          await ResidenceProvider(DioClient().dio).update(id, fields);
      inspect(response);
      if (fields.containsKey(_priceField)) {
        getIt<RefusalFollowUpTracker>().onPriceUpdated();
      }
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      getIt<RefusalFollowUpTracker>().onCalendarUpdated();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  static Future<ReservationResponse> accepterReservation(String id) async {
    try {
      final response =
          await ReservationProvider(DioClient().dio).accepterReservation(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      getIt<RefusalFollowUpTracker>().onCalendarUpdated();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  static Future<dynamic> validerPresence({
    required String qrToken,
  }) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .validerPresence({"qrToken": qrToken});
      return response;
    } catch (error) {
      log('Error: $error', name: 'validerPresence');
      rethrow;
    }
  }

  static Future<MotifsEchecResponse> getMotifsEchec(
      String reservationId) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getMotifsEchec(reservationId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  static Future<MotifEchecReponseModel> submitMotifEchec(
    String reservationId, {
    required String reasonCode,
    String? comment,
  }) async {
    try {
      final response = await ReservationProvider(DioClient().dio).submitMotifEchec(
        reservationId,
        SubmitMotifEchecPayload(reasonCode: reasonCode, comment: comment).toJson(),
      );
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  static Future<MotifEchecReponseModel?> getMotifEchecReponse(
      String reservationId) async {
    try {
      final response = await ReservationProvider(DioClient().dio)
          .getMotifEchecReponse(reservationId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      return null;
    } catch (error) {
      log('Error: $error');
      return null;
    }
  }
}
