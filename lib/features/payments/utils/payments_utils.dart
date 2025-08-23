// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_model.dart';
import 'package:immoplus_pro/features/payments/utils/enums.dart';

Widget getIconStatus({required String status}) {
  // PaymentStatus
  if (status == PaymentStatus.successful.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  } else if (status == PaymentStatus.pending.name ||
      status == PaymentStatus.waiting_for_validation.name) {
    return const Icon(Icons.access_time_filled, color: Colors.grey);
  } else if (status == PaymentStatus.action_required.name) {
    return const Icon(Icons.timer, color: Colors.orange);
  } else if (status == PaymentStatus.payment_required.name) {
    return const Icon(Icons.payments_outlined, color: Colors.purple);
  } else if (status == PaymentStatus.failed.name) {
    return const Icon(Icons.close, color: Colors.red);
  } else if (status == PaymentStatus.processing.name) {
    return const Icon(Icons.rocket_launch_outlined, color: Colors.blue);
  } else if (status == PaymentStatus.paye.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  }
  // WalletWithdrawalStatus
  else if (status == WalletWithdrawalStatus.PENDING.name) {
    return const Icon(Icons.access_time_filled, color: Colors.grey);
  } else if (status == WalletWithdrawalStatus.APPROVED.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.blue);
  } else if (status == WalletWithdrawalStatus.REJECTED.name) {
    return const Icon(Icons.close, color: Colors.red);
  } else if (status == WalletWithdrawalStatus.COMPLETED.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  } else if (status == WalletWithdrawalStatus.FAILED.name) {
    return const Icon(Icons.close, color: Colors.red);
  }
  // WalletPaymentType
  else if (status == WalletPaymentType.CREDIT.name) {
    return const Icon(Icons.arrow_downward, color: Colors.green);
  } else if (status == WalletPaymentType.DEBIT.name) {
    return const Icon(Icons.arrow_upward, color: Colors.red);
  } else if (status == WalletPaymentType.BLOCK.name) {
    return const Icon(Icons.lock, color: Colors.orange);
  } else if (status == WalletPaymentType.UNBLOCK.name) {
    return const Icon(Icons.lock_open, color: Colors.green);
  } else if (status == WalletPaymentType.WITHDRAWAL.name) {
    return const Icon(Icons.money_off, color: Colors.blue);
  }
  return const Icon(Icons.close, color: Colors.red);
}

Color getColorStatus({required String status}) {
  // PaymentStatus
  if (status == PaymentStatus.successful.name ||
      status == PaymentStatus.paye.name) {
    return Colors.green.shade100;
  } else if (status == PaymentStatus.pending.name ||
      status == PaymentStatus.waiting_for_validation.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.action_required.name) {
    return Colors.orange.shade100;
  } else if (status == PaymentStatus.payment_required.name) {
    return Colors.purple.shade100;
  } else if (status == PaymentStatus.failed.name) {
    return Colors.red.shade100;
  } else if (status == PaymentStatus.processing.name) {
    return Colors.blue.shade100;
  }
  // WalletWithdrawalStatus
  else if (status == WalletWithdrawalStatus.PENDING.name) {
    return Colors.grey.shade100;
  } else if (status == WalletWithdrawalStatus.APPROVED.name) {
    return Colors.blue.shade100;
  } else if (status == WalletWithdrawalStatus.REJECTED.name) {
    return Colors.red.shade100;
  } else if (status == WalletWithdrawalStatus.COMPLETED.name) {
    return Colors.green.shade100;
  } else if (status == WalletWithdrawalStatus.FAILED.name) {
    return Colors.red.shade100;
  }
  // WalletPaymentType
  else if (status == WalletPaymentType.CREDIT.name) {
    return Colors.lightGreen;
  } else if (status == WalletPaymentType.DEBIT.name) {
    return Colors.red.shade100;
  } else if (status == WalletPaymentType.BLOCK.name) {
    return Colors.blueGrey.shade400;
  } else if (status == WalletPaymentType.UNBLOCK.name) {
    return Colors.green;
  } else if (status == WalletPaymentType.WITHDRAWAL.name) {
    return Colors.blue.shade100;
  }
  return Colors.red.shade200;
}

String getPaymentStatusName({required String status}) {
  if (status == WalletWithdrawalStatus.PENDING.name) {
    return "Retrait en attente";
  } else if (status == WalletWithdrawalStatus.APPROVED.name) {
    return "Retrait approuvé";
  } else if (status == WalletWithdrawalStatus.REJECTED.name) {
    return "Retrait rejeté";
  } else if (status == WalletWithdrawalStatus.COMPLETED.name) {
    return "Retrait effectué";
  } else if (status == WalletWithdrawalStatus.FAILED.name) {
    return "Retrait échoué";
  }
  // PaymentStatus
  if (status == PaymentStatus.successful.name) {
    return "Effectué";
  } else if (status == PaymentStatus.pending.name ||
      status == PaymentStatus.waiting_for_validation.name) {
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
  // WalletWithdrawalStatus
  else if (status == WalletWithdrawalStatus.PENDING.name) {
    return "Retrait en attente";
  } else if (status == WalletWithdrawalStatus.APPROVED.name) {
    return "Retrait approuvé";
  } else if (status == WalletWithdrawalStatus.REJECTED.name) {
    return "Retrait rejeté";
  } else if (status == WalletWithdrawalStatus.COMPLETED.name) {
    return "Retrait effectué";
  } else if (status == WalletWithdrawalStatus.FAILED.name) {
    return "Retrait échoué";
  }
  // WalletPaymentType
  else if (status == WalletPaymentType.CREDIT.name) {
    return "Crédit";
  } else if (status == WalletPaymentType.DEBIT.name) {
    return "Débit";
  } else if (status == WalletPaymentType.BLOCK.name) {
    return "Blocage";
  } else if (status == WalletPaymentType.UNBLOCK.name) {
    return "Déblocage";
  } else if (status == WalletPaymentType.WITHDRAWAL.name) {
    return "Retrait";
  }
  return "Échoué";
}

String getTransactionTitle(TransactionModel item) {
  if (item.type == WalletPaymentType.CREDIT.name) {
    return "Rechargement";
  } else if (item.type == WalletPaymentType.DEBIT.name) {
    return "Retrait";
  } else if (item.type == WalletPaymentType.BLOCK.name) {
    return "Paiement ${item.source!.toLowerCase()}";
  } else if (item.type == WalletPaymentType.UNBLOCK.name) {
    return "Versement sur compte principal";
  } else if (item.type == WalletPaymentType.WITHDRAWAL.name) {
    return "Retrait";
  }
  return "Transaction";
}
