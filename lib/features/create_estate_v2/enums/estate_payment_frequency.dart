import 'package:immoplus_pro/gen/assets.gen.dart';

enum EstatePaymentFrequency {
  mois('mois', 'Par mois', "assets/svgs/creation_icon/calendar.svg"),
  jour('jour', 'Par jours', "assets/svgs/creation_icon/calendar_jours.svg"),
  heure('heure', 'Par heure', "assets/svgs/creation_icon/calendar_clock.svg"),
  vente('vente', 'À vendre', "assets/svgs/creation_icon/tag.svg");

  final String value;
  final String label;
  final String icon;

  const EstatePaymentFrequency(this.value, this.label, this.icon);
}
