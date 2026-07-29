import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/payment/crate_payement_request_dto.dart';
import 'package:immoplus_pro/data/models/payment/payment_authenticate_body.dart';
import 'package:immoplus_pro/data/models/payment/payment_itent_data.dart';
import 'package:immoplus_pro/data/repositories/payment_repository.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:retrofit/dio.dart';

class PaymentServices {
  // static Future initPayment({
  //   required BuildContext context,
  //   required String number,
  //   required String collection,
  //   required String itemID,
  //   required Function(PaymentItentData p) onSuccess,
  //   required Function() onFailed,
  // }) async {
  //   try {
  //     PaymentItentModel paymentIntentModel = await PaymentRepository.intent(
  //         body: PaymentIntentBody(
  //       collection: collection,
  //       itemId: itemID,
  //       paymentMethod: OrderPaymentController.selectedOperator.value,
  //       paymentCredentials: number.trim(),
  //     ));

  //     if (paymentIntentModel.data.amount == 0 ||
  //         paymentIntentModel.data.itemId.isEmpty) {
  //       onFailed();
  //     } else if (paymentIntentModel.data.itemId.isNotEmpty) {
  //       log("SUCCESS");
  //       inspect(paymentIntentModel);
  //       onSuccess(paymentIntentModel.data);
  //     }
  //   } catch (e) {
  //     log(e.toString(), name: 'ERROR INIT');
  //     EasyLoading.showToast("Une erreur s'est produite");
  //     onFailed();
  //   }
  // }

  static Future initPaymentRequest({
    required BuildContext context,
    required String number,
    required String collection,
    required String itemID,
    required Function() onSuccess,
    required Function() onFailed,
  }) async {
    try {
      HttpResponse paymentIntentModel = await PaymentRepository.intentRequest(
          body: CratePayementRequestDto(
        // reservationId: collection,
        reservationId: itemID,
        paymentMethod: OrderPaymentController.selectedOperator.value,
        paymentAddress: number.trim(),
      ));
      if (paymentIntentModel.response.statusCode! >= 200 &&
          paymentIntentModel.response.statusCode! < 300) {
        onSuccess();
      } else {
        getIt<AnalyticsService>().logPaymentFailed(
          operator: OrderPaymentController.selectedOperator.value,
          step: 'processing',
        );
        onFailed();
      }
      // if (paymentIntentModel.data.amount == 0 ||
      //     paymentIntentModel.data.itemId.isEmpty) {
      //   onFailed();
      // } else if (paymentIntentModel.data.itemId.isNotEmpty) {
      //   log("SUCCESS");
      //   inspect(paymentIntentModel);
      //  // onSuccess(paymentIntentModel.data);
      // }
    } catch (e) {
      getIt<AnalyticsService>().logPaymentFailed(
        operator: OrderPaymentController.selectedOperator.value,
        step: 'processing',
      );
      onFailed();
    }
  }

  static Future authenticatePayment({
    required String otp,
    required String itemId,
    required String collection,
    required BuildContext context,
    required Function() onSuccess,
    required Function() onFailed,
  }) async {
    //print(UserModel.singleton.accessToken);_formKey.currentState!.validate()

    try {
      EasyLoading.show(status: 'Vérification en cours...');
      await PaymentRepository.authenticate(
          body: PaymentAuthenticateBody(
        collection: collection,
        itemId: itemId,
        otp: otp,
      ));

      log("SUCCESS");

      EasyLoading.dismiss();
      getIt<AnalyticsService>().logPaymentCompleted(
        operator: OrderPaymentController.selectedOperator.value,
      );
      onSuccess();
    } catch (e) {
      EasyLoading.showToast(
        "La tentative d'authentification a échoué. Assurez-vous que le code OTP est correct.",
      );
      getIt<AnalyticsService>().logPaymentFailed(
        operator: OrderPaymentController.selectedOperator.value,
        step: 'otp',
      );
      onFailed();
    }
  }
}
