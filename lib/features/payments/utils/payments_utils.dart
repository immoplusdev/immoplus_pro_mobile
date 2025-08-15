// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/constantes.dart';

Widget getIconStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    );
  } else if (status == PaymentStatus.pending.name) {
    return const Icon(
      Icons.access_time_filled,
      color: Colors.grey,
    );
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return const Icon(
      Icons.access_time_filled,
      color: Colors.grey,
    );
  } else if (status == PaymentStatus.action_required.name) {
    return const Icon(
      Icons.timer,
      color: Colors.orange,
    );
  } else if (status == PaymentStatus.payment_required.name) {
    return const Icon(
      Icons.payments_outlined,
      color: Colors.purple,
    );
  } else if (status == PaymentStatus.failed.name) {
    return const Icon(
      Icons.close,
      color: Colors.red,
    );
  } else if (status == PaymentStatus.processing.name) {
    return const Icon(
      Icons.rocket_launch_outlined,
      color: Colors.blue,
    );
  } else if (status == PaymentStatus.paye.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  }
  return const Icon(Icons.close, color: Colors.red);
}

Color getColorStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return Colors.green.shade100;
  } else if (status == PaymentStatus.pending.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.action_required.name) {
    return Colors.orange.shade100;
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.payment_required.name) {
    return Colors.purple.shade100;
  } else if (status == PaymentStatus.failed.name) {
    return Colors.red.shade100;
  } else if (status == PaymentStatus.processing.name) {
    return Colors.blue.shade100;
  } else if (status == PaymentStatus.paye.name) {
    return Colors.green.shade100;
  }
  return Colors.red.shade200;
}

String getPaymentStatusName({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return "Effectué";
  } else if (status == PaymentStatus.pending.name) {
    return "En attente";
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return "En attente";
  } else if (status == PaymentStatus.action_required.name) {
    return "Action requise";
  } else if (status == PaymentStatus.payment_required.name) {
    return "Paiement requis";
  } else if (status == PaymentStatus.failed.name) {
    return "Échoué";
  } else if (status == PaymentStatus.processing.name) {
    return "En cours";
  } else if (status == PaymentStatus.paye.name) {
    return "Payé";
  }
  return "Échoué";
}

enum TransactionType {
  CREDIT,
  DEBIT,
}
