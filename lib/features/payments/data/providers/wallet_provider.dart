import 'package:dio/dio.dart';
import 'package:immoplus_pro/features/payments/data/models/has_pin_response_model.dart';
import 'package:immoplus_pro/features/payments/data/models/pin_request_model.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_collection_model.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_response_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_collection_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_response.dart';

import 'package:retrofit/retrofit.dart';

import '../models/wallet_model.dart';
part 'wallet_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class WalletProvider {
  factory WalletProvider(Dio dio, {String baseUrl}) = _WalletProvider;

  @GET('/wallet/my-wallet')
  // @GET("https://api.npoint.io/0d0f493d0ab3f0f01942")
  Future<WalletResponseModel> getWallet();

  @GET('/wallet/my-transactions')
  // @GET("https://api.npoint.io/48114e6ded6fa91ad6f1")
  Future<TransactionCollectionModel> getTransactions({
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });

  @GET("/wallet/my-withdrawal-request")
  Future<WithdrawalRequestCollectionModel> getWithdrawalRequest({
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });

  @POST("/wallet/withdrawal-request/create")
  Future<WithdrawalRequestModel> createWithdrawalRequest(
      @Body() WithdrawalRequestDto withdrawalRequestDto);

  /// Définir un nouveau code PIN pour le wallet
  @POST('/wallet/set-pin')
  Future<void> setPin(@Body() PinRequestModel pinRequest);

  /// Vérifier le code PIN du wallet
  @POST('/wallet/verify-pin')
  Future<void> verifyPin(@Body() PinRequestModel pinRequest);

  /// Vérifier si l'utilisateur a déjà défini un PIN
  @GET('/wallet/has-pin')
  Future<HasPinResponseModel> hasPin();

  /// Modifier le code PIN existant (PIN connu)
  @POST('/wallet/change-pin')
  Future<void> changePin(@Body() Map<String, dynamic> body);

  /// Demander la réinitialisation du code PIN (Étape 1 : Envoi OTP par SMS)
  @POST('/wallet/request-pin-reset')
  Future<dynamic> requestPinReset();

  /// Réinitialiser le code PIN avec OTP (Étape 2)
  @POST('/wallet/reset-pin')
  Future<void> resetPin(@Body() Map<String, dynamic> body);
}
