import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/utils/booking_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/booking/booking_detail_page.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  BookingCard({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CupertinoListTile(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: AppColors.scafold,
              showDragHandle: true,
              enableDrag: true,
              isScrollControlled: true,
              useRootNavigator: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              context: context,
              builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: BookingDetailPage(
                    id: reservationModel.id,
                  )),
            );
          },
          backgroundColor: Colors.white,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

          leadingSize: 30,
          leadingToTitle: 5,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: BookingUtils.isDateInPastOrToday(
                            reservationModel.datesReservation.first.date!)
                        ? Colors.green.shade400
                        : Colors.blueGrey,
                    radius: 14,
                    child: Icon(
                      BookingUtils.isDateInPastOrToday(
                              reservationModel.datesReservation.first.date!)
                          ? FontAwesomeIcons.suitcaseRolling
                          : FontAwesomeIcons.calendarCheck,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  AutoSizeText(
                    "Du ${formatDate.format(reservationModel.datesReservation.first.date!)} au ${formatDate.format(reservationModel.datesReservation.last.date!)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Gap(6),
              Wrap(
                children: [
                  Text(
                    reservationModel.residence.nom,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.purple),
                  ),
                  Text(
                      " Pour ${reservationModel.datesReservation.length} jours",
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    Utils.formatCurrency(
                        reservationModel.montantTotalReservation),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.primary),
                  ),
                  Chip(
                    backgroundColor: BookingUtils.isDateInPastOrToday(
                            reservationModel.datesReservation.first.date!)
                        ? Colors.green.shade100
                        : Colors.blueGrey.shade200,
                    label: Text(BookingUtils.isDateInPastOrToday(
                            reservationModel.datesReservation.first.date!)
                        ? 'Séjour en cours'
                        : 'Séjour à venir'),
                  ),
                ],
              ),
            ],
          ),

          // leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
          // titleTextStyle: Theme.of(context).textTheme.titleMedium,
          // subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
