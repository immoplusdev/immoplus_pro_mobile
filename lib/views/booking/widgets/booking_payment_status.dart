import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/shared_widgets/status_chip.dart';

class BookingPaymentStatus extends StatelessWidget {
  const BookingPaymentStatus({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          FontAwesomeIcons.moneyBillWave,
          color: Colors.green,
        ),
        radius: 15,
      ),
      horizontalTitleGap: 3,
      dense: true,
      title: Text('Statut de paiement :'),
      trailing: StatusChip(
          text: Utils.getServiceStatus(reservationModel.statusFacture ?? ''),
          status: reservationModel.statusFacture!),
    );
  }
}
