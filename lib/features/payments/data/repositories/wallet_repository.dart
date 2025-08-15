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
  //     throw Exception('Failed to load users: ${dioError.message}');
  //   } catch (error) {
  //     // Gérer d'autres types d'exceptions ici
  //     log('Error: $error');
  //     throw Exception('Failed to load users: $error');
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
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
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
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
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
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
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
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
