import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_collection_model.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_model.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_response_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_collection_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_response.dart';
import 'package:immoplus_pro/features/payments/data/providers/wallet_provider.dart';

class WalletRepository {
  // static Future<WalletModel> getWithdrawReservations({
  //   required String userId,
  // }) async {
  //   //DioClient().dio.options.queryParameters['meta'] = '*';
  //   try {
  //     final response = await WalletProvider(DioClient().dio).getWallet();
  //     inspect(response);
  //     return response;
  //   } on DioException catch (dioError) {
  //     // Gérer les exceptions Dio ici
  //     log('DioError: ${dioError.message}');
  //     throw AppErrorMapper.from(dioError);
  //   } catch (error) {
  //     // Gérer d'autres types d'exceptions ici
  //     log('Error: $error');
  //     throw AppErrorMapper.from(error);
  //   }
  // }

  static Future<WalletResponseModel> getWallet() async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await WalletProvider(DioClient().dio).getWallet();
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

  static Future<TransactionCollectionModel> getTransactions({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await WalletProvider(DioClient().dio).getTransactions(
        page: page,
        perPage: perPage,
        orderBy: orderBy,
        orderDir: orderDir,
      );
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

  static Future<WithdrawalRequestCollectionModel> getWithdrawalRequest({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await WalletProvider(DioClient().dio).getWithdrawalRequest(
        page: page,
        perPage: perPage,
        orderBy: orderBy,
        orderDir: orderDir,
      );
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

  static Future<WithdrawalRequestModel> createWithdrawalRequest(
      WithdrawalRequestDto withdrawalRequestDto) async {
    try {
      final response = await WalletProvider(DioClient().dio)
          .createWithdrawalRequest(withdrawalRequestDto);
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

  /// Crée une demande de retrait directement liée à une réservation dont la
  /// présence vient d'être validée par scan QR — le montant est calculé côté
  /// backend à partir de la réservation, pas de champ `amount` ici.
  static Future<void> createWithdrawalRequestFromQr({
    required String reservationId,
    required String phoneNumber,
    required String operator,
  }) async {
    try {
      await WalletProvider(DioClient().dio).createWithdrawalRequestFromQr({
        'reservationId': reservationId,
        'phoneNumber': phoneNumber,
        'operator': operator,
      });
    } on DioException catch (dioError) {
      log('DioError createWithdrawalRequestFromQr: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error createWithdrawalRequestFromQr: $error');
      throw Exception('Erreur inconnue lors de la demande de retrait');
    }
  }

  static Future<void> changePin(String oldPin, String newPin) async {
    try {
      await WalletProvider(DioClient().dio).changePin({
        "oldPin": oldPin,
        "newPin": newPin,
      });
    } on DioException catch (dioError) {
      log('DioError changePin: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error changePin: $error');
      throw Exception('Erreur inconnue lors du changement de PIN');
    }
  }

  static Future<void> requestPinReset() async {
    try {
      await WalletProvider(DioClient().dio).requestPinReset();
    } on DioException catch (dioError) {
      log('DioError requestPinReset: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error requestPinReset: $error');
      throw Exception('Erreur inconnue lors de la demande de réinitialisation');
    }
  }

  static Future<void> resetPin(String otp, String newPin) async {
    try {
      await WalletProvider(DioClient().dio).resetPin({
        "otp": otp,
        "newPin": newPin,
      });
    } on DioException catch (dioError) {
      log('DioError resetPin: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error resetPin: $error');
      throw Exception('Erreur inconnue lors de la validation du code PIN');
    }
  }
}
