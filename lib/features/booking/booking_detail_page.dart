// ignore_for_file: prefer_is_empty

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/features/payment_module/operators_selector_page.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_chip.dart';
import 'package:immoplus_pro/utils/booking_utils.dart';
import 'package:immoplus_pro/utils/contact_utils.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/booking/logic/booking_cubit.dart';
import 'package:immoplus_pro/features/booking/logic/booking_request_state.dart';
import 'package:immoplus_pro/features/booking/widgets/logment_info.dart';
import 'package:immoplus_pro/features/booking/widgets/planing_booking_card_detail.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({super.key, required this.id});
  final String id;
  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getBooking(id: widget.id);
  }

  /// verifier si la demande de visite est payé
  bool hasPaid(ReservationResponse reservationResponse) {
    return reservationResponse.data.statusFacture.toString() ==
        PaymentStatus.paye.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_BOOKING) {
          final codeReservation =
              state.reservationResponse.data.codeReservation;
          final clientName =
              "${state.reservationResponse.data.client.firstName} ${state.reservationResponse.data.client.lastName}";
          return Scaffold(
            backgroundColor: AppColors.scafold,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      this
                          .context
                          .read<BookingCubit>()
                          .getBooking(id: widget.id);
                    },
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      tileColor: CupertinoColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: CircleAvatar(
                        backgroundImage: Utils.getImage(
                            id: state.reservationResponse.data.residence.images
                                .first),
                      ),
                      title: Text(
                          state.reservationResponse.data.residence.nom ??
                              'no name'),
                      subtitle: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: Utils.formatCurrency(state.reservationResponse
                                .data.residence.prixReservation),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: ' Par nuit',
                            style: TextStyle(color: Colors.grey.shade600))
                      ])),
                      trailing: UnconstrainedBox(
                        child: CustomChip(
                          icon: (BookingUtils.getBookingStatus(
                                      state.reservationResponse.data
                                          .datesReservation.first.date!,
                                      state.reservationResponse.data
                                          .datesReservation.last.date!) ==
                                  BookingStatus.ongoing)
                              ? FontAwesomeIcons.suitcaseRolling
                              : CupertinoIcons.calendar_today,
                          iconSize: 12,
                          backgroundColor: (BookingUtils.getBookingStatus(
                                      state.reservationResponse.data
                                          .datesReservation.first.date!,
                                      state.reservationResponse.data
                                          .datesReservation.last.date!) !=
                                  BookingStatus.ongoing)
                              ? Colors.blueGrey.shade200
                              : Colors.green.shade100,
                          label: BookingUtils.getStatusText(
                              startDate: state.reservationResponse.data
                                  .datesReservation.first.date!,
                              endDate: state.reservationResponse.data
                                  .datesReservation.last.date!),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                  )),
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Identifiant de la réservation:'),
                        subtitle:
                            SelectableText(state.reservationResponse.data.id),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(FontAwesomeIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.reservationResponse.data.id))
                                .then((value) {
                              //Vibrate.feedback(FeedbackType.impact);
                              EasyLoading.showToast('Identifiant copié');
                            }).catchError((err) {
                              EasyLoading.showToast(err.toString());
                            });
                          },
                        ),
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.purple),
                      ),
                    ),
                  ),
                  if (hasPaid(state.reservationResponse)) ...[
                    SliverGap(10),
                    _customTile(
                      title: 'Code réservation:'.toUpperCase(),
                      value: codeReservation,
                      onTap: () {
                        Utils.copyToClipboard(codeReservation);
                      },
                    ),
                  ],
                  const SliverToBoxAdapter(child: Divider()),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(bottom: 10),
                    child: PlaningBookingCardDetail(
                      reservationModel: state.reservationResponse.data,
                    ),
                  )),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: Icon(
                          FontAwesomeIcons.headset,
                          color: AppColors.primary,
                        ),
                        title: const AutoSizeText(
                          "Contacter ImmoPLus",
                          maxLines: 1,
                        ),
                        subtitle: const Text(
                            'Contacter le service client pour toute annulation ou réclamation.'),
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.primary),
                        subtitleTextStyle:
                            Theme.of(context).textTheme.bodySmall,
                        trailing: Icon(
                          CupertinoIcons.chevron_right_circle_fill,
                          color: AppColors.primary,
                        ),
                        onTap: () async {
                          ContactUtils.showContact(id: widget.id);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        enabled: true,
                        //dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: const CircleAvatar(
                            //backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                FontAwesomeIcons.solidUser,
                                size: 35,
                                //color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        title: const Text("Joindre le client"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (clientName.trim().isNotEmpty) Text(clientName),
                            Text(state
                                .reservationResponse.data.clientPhoneNumber),
                          ],
                        ),
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                        trailing: Icon(
                          FontAwesomeIcons.phoneFlip,
                          color: AppColors.primary,
                        ),
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.primary),
                        onTap: () async {
                          final phone = state
                              .reservationResponse.data.clientPhoneNumber
                              .split('-');
                          Utils.makePhoneCall(phone.last);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is Error_BOOKINGS) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.remove_circle,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Vous n'avez pas accès à cet élément ou aucun élément correspondant",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(50),
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      onTap: () {
                        context.goNamed(BookingPage.name);
                      },
                      horizontalTitleGap: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      tileColor: AppColors.primaryLite,
                      leading:
                          const Icon(CupertinoIcons.chevron_left_circle_fill),
                      title: const Text("Retour a la page d'historique"),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const LoadingPage();
      },
    );
  }

  Widget _customTile(
      {required String title, required String value, VoidCallback? onTap}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          subtitle: SelectableText(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.purple, fontSize: 18),
          ),
          dense: true,
          onTap: onTap,
          trailing: Icon(
            FontAwesomeIcons.copy,
            color: AppColors.primary,
          ),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
