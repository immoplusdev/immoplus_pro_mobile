import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/request_response_exeption.dart';
import 'package:immoplus_pro/data/models/payment/crate_payement_request_dto.dart';
import 'package:immoplus_pro/data/models/payment/payment_authenticate_body.dart';
import 'package:immoplus_pro/data/models/payment/payment_intent_body.dart';
import 'package:immoplus_pro/data/models/payment/payment_itent_model.dart';
import 'package:immoplus_pro/data/models/payment/payments_model_collection.dart';
import 'package:immoplus_pro/data/providers/payment_provider.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:retrofit/dio.dart';

class PaymentRepository {
  static Future<PaymentItentModel> intent(
      {required PaymentIntentBody body}) async {
    try {
      final response =
          await PaymentProvider(DioClient().dio).intentPayment(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<HttpResponse> intentRequest(
      {required CratePayementRequestDto body}) async {
    try {
      final response =
          await PaymentProvider(DioClient().dio).intentPaymentRequest(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      Map<String, dynamic>? rep;
      try {
        rep = dioError.response!.data as Map<String, dynamic>;
        log(rep['message']);

        if (rep['message'] != null) {
          //EasyLoadingHandler.showErrorToast(text: rep['message'].toString());
          AppDialog.info(
            context: NavigationService.navigatorKey.currentContext!,
            content: rep['message'].toString(),
            icon: const FaIcon(FontAwesomeIcons.moneyBills,
              color: Colors.red,
            ),
            rollback: () {
              NavigationService.navigatorKey.currentContext!.pop();
            },
          );
        } else {
          AppDialog.info(
            context: NavigationService.navigatorKey.currentContext!,
            content:
                "Nous n'avons pas pu donner suite à votre demande de retrait. Veuillez réessayer ou contacter notre service client.",
            icon: const FaIcon(FontAwesomeIcons.moneyBills,
              color: Colors.red,
            ),
            rollback: () {
              NavigationService.navigatorKey.currentContext!.pop();
            },
          );
        }
      } catch (e) {}
      throw Exception(dioError.response!.data.toString());
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<PaymentItentModel> authenticate(
      {required PaymentAuthenticateBody body}) async {
    try {
      final response =
          await PaymentProvider(DioClient().dio).authenticate(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<PaymentItentModel> getPayment(String id) async {
    try {
      final response = await PaymentProvider(DioClient().dio).getPayment(id);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<PaymentsModelCollection> getPayments({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
    Map<String, dynamic>? where,
  }) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response = await PaymentProvider(DioClient().dio)
          .getPayments(search, where, page, perPage, orderBy, orderDir);

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
