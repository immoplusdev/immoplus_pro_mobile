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
import 'package:iconsax/iconsax.dart';
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
            backgroundColor: Colors.white,
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
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: Utils.getImage(
                            id: state.reservationResponse.data.residence.images
                                .firstOrNull ?? ""),
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
                            text: ' /nuitée',
                            style: TextStyle(color: Colors.grey.shade600))
                      ])),
                      trailing: UnconstrainedBox(
                        child: Builder(
                          builder: (context) {
                            final status = BookingUtils.getBookingStatus(
                                state.reservationResponse.data
                                    .datesReservation.first.date!,
                                state.reservationResponse.data
                                    .datesReservation.last.date!);
                            final statusColor = BookingUtils.getStatusColor(status);
                            
                            return CustomChip(
                              icon: BookingUtils.getStatusIcon(status),
                              iconSize: 14,
                              iconColor: statusColor,
                              backgroundColor: statusColor.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              borderRadius: BorderRadius.circular(10),
                              label: BookingUtils.getStatusText(
                                  startDate: state.reservationResponse.data
                                      .datesReservation.first.date!,
                                  endDate: state.reservationResponse.data
                                      .datesReservation.last.date!),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                            );
                          }
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
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                        ),
                        title: const Text('Identifiant de la réservation'),
                        subtitle:
                            SelectableText(state.reservationResponse.data.id),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(Iconsax.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.reservationResponse.data.id))
                                .then((value) {
                              EasyLoading.showToast('Identifiant copié');
                            }).catchError((err) {
                              EasyLoading.showToast(err.toString());
                            });
                          },
                        ),
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.customBlue, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: InkWell(
                        onTap: () async {
                          ContactUtils.showContact(id: widget.id);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.customBlue.withOpacity(0.08)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.headphone,
                                  color: AppColors.primary.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              const Gap(16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contacter ImmoPLus",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Gap(4),
                                    Text(
                                      'Une question ou besoin d\'assistance ?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Iconsax.arrow_right_3,
                                color: Colors.grey.shade400,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: InkWell(
                        onTap: () async {
                          final phone = state
                              .reservationResponse.data.clientPhoneNumber
                              .split('-');
                          Utils.makePhoneCall(phone.last);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.customBlue.withOpacity(0.08)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.user,
                                  color: AppColors.primary.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Joindre le client",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      clientName.trim().isNotEmpty ? clientName : 'Client ImmoPlus',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.customBlue,
                                      ),
                                    ),
                                    Text(
                                      state.reservationResponse.data.clientPhoneNumber,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Iconsax.call,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
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
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
          ),
          title: Text(title),
          subtitle: SelectableText(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.customBlue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          dense: true,
          onTap: onTap,
          trailing: Icon(
            Iconsax.copy,
            color: AppColors.primary,
          ),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
