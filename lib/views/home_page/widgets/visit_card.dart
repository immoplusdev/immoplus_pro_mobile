import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/views/booking/booking_detail_page.dart';
import 'package:intl/intl.dart';

class VisitCard extends StatelessWidget {
  VisitCard({super.key, required this.demandeVisiteModel});
  final DemandeVisiteModel demandeVisiteModel;
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
                  id: demandeVisiteModel.id ?? '',
                )),
          );
        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: const CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Icon(FontAwesomeIcons.calendarCheck, color: Colors.white),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              demandeVisiteModel.montantDemandeVisiteSansCommission.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),

            // Chip(
            //   backgroundColor: BookingUtils.isDateInPastOrToday(
            //           demandeVisiteModel.datesReservation!.first.date!)
            //       ? Colors.green.shade100
            //       : Colors.blueGrey.shade200,
            //   label: Text(BookingUtils.isDateInPastOrToday(
            //           demandeVisiteModel.datesReservation!.first.date!)
            //       ? 'Séjour en cours'
            //       : 'Séjour à venir'),
            // )
          ],
        ),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
