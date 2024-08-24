import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/utils/booking_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/booking/booking_detail_page.dart';
import 'package:intl/intl.dart';

class VisitCard extends StatelessWidget {
  VisitCard({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: AppColors.scafold,
            showDragHandle: true,
            enableDrag: true,
            isScrollControlled: true,
            useRootNavigator: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: BookingDetailPage(
                  id: reservationModel.id ?? '',
                )),
          );
        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: CircleAvatar(
          backgroundColor: BookingUtils.isDateInPastOrToday(
                  reservationModel.datesReservation!.first.date!)
              ? Colors.green.shade400
              : Colors.blueGrey,
          child: Icon(
              BookingUtils.isDateInPastOrToday(
                      reservationModel.datesReservation!.first.date!)
                  ? FontAwesomeIcons.personWalkingLuggage
                  : FontAwesomeIcons.calendarCheck,
              color: Colors.white),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "du ${formatDate.format(reservationModel.datesReservation!.first.date!)} au ${formatDate.format(reservationModel.datesReservation!.last.date!)}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
                Utils.formatCurrency(reservationModel.montantTotalReservation)),
            Chip(
              backgroundColor: BookingUtils.isDateInPastOrToday(
                      reservationModel.datesReservation!.first.date!)
                  ? Colors.green.shade100
                  : Colors.blueGrey.shade200,
              label: Text(BookingUtils.isDateInPastOrToday(
                      reservationModel.datesReservation!.first.date!)
                  ? 'Séjour en cours'
                  : 'Séjour à venir'),
            )
          ],
        ),
        trailing:
            Text("Pour ${reservationModel.datesReservation!.length} jours"),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
