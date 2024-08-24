import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:intl/intl.dart';

class PlaningBookingCardDetail extends StatelessWidget {
  PlaningBookingCardDetail({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListTile(
              dense: true,
              title: Text('ARRIVÉE'),
              titleTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: Colors.black),
              subtitle: (reservationModel.datesReservation!.isNotEmpty)
                  ? Text(
                      "${formatDate.format(reservationModel.datesReservation!.first.date!)} à ${reservationModel.residence!.heureEntree}")
                  : null,
            ),
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey,
          ),
          Flexible(
            child: ListTile(
              dense: true,
              title: Text('DÉPART'),
              titleTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: Colors.black),
              subtitle: (reservationModel.datesReservation!.isNotEmpty)
                  ? Text(
                      "${formatDate.format(reservationModel.datesReservation!.last.date!)} avant ${reservationModel.residence!.heureDepart} ")
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
