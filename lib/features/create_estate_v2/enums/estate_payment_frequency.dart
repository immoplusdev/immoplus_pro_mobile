import 'package:flutter/material.dart';

enum EstatePaymentFrequency {
  mois('mois', 'Par mois', Icons.calendar_month),
  jour('jour', 'Par jours', Icons.calendar_today),
  heure('heure', 'Par heure', Icons.access_time),
  vente('vente', 'À vendre', Icons.sell);

  final String value;
  final String label;
  final IconData icon;

  const EstatePaymentFrequency(this.value, this.label, this.icon);
}
