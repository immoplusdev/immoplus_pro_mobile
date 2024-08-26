// ignore_for_file: prefer_is_empty

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/utils/booking_utils.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/booking/logic/booking_cubit.dart';
import 'package:immoplus_pro/views/booking/logic/booking_request_state.dart';
import 'package:immoplus_pro/views/booking/widgets/logment_info.dart';
import 'package:immoplus_pro/views/booking/widgets/planing_booking_card_detail.dart';
import 'package:immoplus_pro/views/home_page/home_page.dart';
import 'package:immoplus_pro/views/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/views/shared_widgets/loading_page.dart';

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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LogmentInfo(
                        logmentModel: state.reservationResponse.data.residence),
                  )),
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text('Identifiant de la réservation:'),
                        subtitle:
                            SelectableText(state.reservationResponse.data.id),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: Icon(FontAwesomeIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.reservationResponse.data.id))
                                .then((value) {
                              Vibrate.feedback(FeedbackType.impact);
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
                  // SliverToBoxAdapter(
                  //     child: Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         inspect(state.data.logement);
                  //       },
                  //       child: Text(
                  //           'Teste')), // LogmentInfo(logmentModel: state.data.logement!),
                  // )),
                  SliverToBoxAdapter(child: Divider()),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dense: true,
                        title: Text(
                          "Total pour ${state.reservationResponse.data!.datesReservation!.length} ${(state.reservationResponse.data!.datesReservation!.length >= 1) ? 'Jour' : 'Jours'}",
                        ),
                        trailing: Text(
                          Utils.formatCurrency(state.reservationResponse.data
                              .montantTotalReservation),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    ),
                  ),

                  SliverGap(10),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: BookingUtils.isDateInPastOrToday(
                                  state.reservationResponse.data!
                                      .datesReservation!.first.date!)
                              ? Colors.green.shade400
                              : Colors.blueGrey,
                          child: Icon(
                              BookingUtils.isDateInPastOrToday(state
                                      .reservationResponse
                                      .data!
                                      .datesReservation!
                                      .first
                                      .date!)
                                  ? FontAwesomeIcons.personWalkingLuggage
                                  : FontAwesomeIcons.calendarCheck,
                              color: Colors.white),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dense: true,
                        title: Text(BookingUtils.isDateInPastOrToday(state
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

                  //Gap(8),

                  SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(bottom: 10),
                    child: PlaningBookingCardDetail(
                      reservationModel: state.reservationResponse.data!,
                    ),
                  )),
                  // if (receiptModel.serviceStatus ==
                  //     ServiceStatus.en_cours_validation_user.name)

                  const SliverGap(10),

                  const SliverToBoxAdapter(child: Divider()),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                          ),
                          title: Text("Écrivez-nous sur WhatsApp"),
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: Colors.green,
                          ),
                          onTap: () async {
                            Utils.whatsapp(phoneNumber: "+2250701710065");
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            FontAwesomeIcons.headset,
                            color: Colors.black,
                          ),
                          title: Text("Appeller notre service client"),
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: Colors.black,
                          ),
                          onTap: () async {
                            // Utils.call();
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: SvgPicture.asset(
                            SVGMap.map['gmail']!,
                            height: 30,
                          ),
                          title: const Text("Envoyez-nous un e-mail"),
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          trailing: const Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: Colors.red,
                          ),
                          onTap: () async {
                            Utils.bookingMail(
                                id: state.reservationResponse.data.id);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // CustomButtom(
                  //   text: 'Valider cette réservation',
                  //   onClick: () {},
                  // ),
                  OutlinedButton(
                    // isDestructiveAction: true,
                    onPressed: () {
                      log("TOTO");
                      final _formKey = GlobalKey<FormState>();
                      showModalBottomSheet(
                        backgroundColor: AppColors.scafold,
                        showDragHandle: true,
                        enableDrag: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        context: context,
                        builder: (context) => Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Pour quel raison annulez-vous ?',
                                  style:
                                      Theme.of(context).textTheme.titleMedium!),
                              const Gap(30),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: CustomTextField(
                                  minLines: 4,
                                  labelText: 'Donnez nous la raison',
                                  maxLines: 5,
                                  validator: (value) =>
                                      FormUtils.fieldValidator(value: value),
                                ),
                              ),
                              Gap(10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: CustomButtom(
                                  text: 'Confirmer',
                                  onClick: () {
                                    if (_formKey.currentState!.validate()) {
                                      EasyLoading.show(status: 'Annulement..');
                                      LogmentRepository.annulerReservations(
                                              id: widget.id)
                                          .then(
                                        (value) {
                                          if (value.data.id.isNotEmpty) {
                                            EasyLoading.showSuccess(
                                                'Reservation Annulé');
                                          } else {
                                            EasyLoading.showError(
                                                'Echec Annulement');
                                          }
                                        },
                                      );
                                    }
                                  },
                                  isLoading: false,
                                ),
                              ),
                              const Gap(20),
                              Gap(MediaQuery.of(context).viewInsets.bottom),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Annulers la réservation",
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.red),
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
                  Icon(
                    Icons.remove_circle,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Vous n'avez pas accès à cet élément ou aucun élément correspondant",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(50),
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
                      leading: Icon(CupertinoIcons.chevron_left_circle_fill),
                      title: Text("Retour a la page d'historique"),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return LoadingPage();
      },
    );
  }
}
