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
import 'package:immoplus_pro/features/payment_module/operators_selector_page.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_adapter.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_BOOKING) {
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
                    child: LogmentInfo(
                        logmentModel: state.reservationResponse.data.residence),
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
                        subtitle: Text(
                            "${state.reservationResponse.data.client.firstName} ${state.reservationResponse.data.client.lastName}"),
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        tileColor:
                            state.reservationResponse.data.retraitProEffectue
                                ? Colors.white
                                : Colors.green.shade100,
                        onTap: state.reservationResponse.data.retraitProEffectue
                            ? null
                            : () {
                                context.pushNamed(OperatorsSelectorPage.name,
                                    extra: PaymentPageAdapter(
                                        itemId:
                                            state.reservationResponse.data.id,
                                        collection: 'reservation',
                                        amount: state.reservationResponse.data
                                            .montantTotalReservation
                                            .toInt()));
                              },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              state.reservationResponse.data.retraitProEffectue
                                  ? BorderRadius.circular(20)
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                        ),
                        dense: true,
                        title: Text(
                          "Total pour ${state.reservationResponse.data.datesReservation.length} ${(state.reservationResponse.data.datesReservation.length >= 1) ? 'Jour' : 'Jours'}",
                        ),
                        trailing: Text(
                          "${CurrencyFormatter.format(state.reservationResponse.data.montantTotalReservation.toInt().toString())} F",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  if (!state.reservationResponse.data.retraitProEffectue)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            context.pushNamed(OperatorsSelectorPage.name,
                                extra: PaymentPageAdapter(
                                    itemId: state.reservationResponse.data.id,
                                    collection: 'reservation',
                                    amount: state.reservationResponse.data
                                        .montantTotalReservation
                                        .toInt()));
                            // showModalBottomSheet(
                            //   isScrollControlled: true,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20)),
                            //   context: context,
                            //   builder: (context) => FractionallySizedBox(
                            //     heightFactor: 0.9,
                            //     child: OperatorsSelectorPage(
                            //         paymentPageAdapter: PaymentPageAdapter(
                            //             itemId:
                            //                 state.reservationResponse.data.id,
                            //             collection: 'reservation',
                            //             amount: state.reservationResponse.data
                            //                 .montantTotalReservation
                            //                 .toInt())),
                            //   ),
                            // );
                          },
                          tileColor:
                              state.reservationResponse.data.retraitProEffectue
                                  ? Colors.white
                                  : Colors.green.shade100,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          title: const Text(
                            "Retirer l'argent",
                          ),
                          leading: Icon(
                            FontAwesomeIcons.moneyBills,
                            color: Colors.green.shade500,
                          ),
                          trailing: Icon(
                            FontAwesomeIcons.circleChevronRight,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Chip(
                        avatar: Icon(
                          BookingUtils.isDateInPastOrToday(
                            state.reservationResponse.data.datesReservation
                                .first.date!,
                          )
                              ? FontAwesomeIcons.personWalkingLuggage
                              : FontAwesomeIcons.calendarCheck,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: Text(BookingUtils.isDateInPastOrToday(state
                                .reservationResponse
                                .data
                                .datesReservation
                                .first
                                .date!)
                            ? 'Séjour en cours'
                            : 'Séjour à venir'),
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
}
