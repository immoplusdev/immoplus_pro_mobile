import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/features/home_v2/widgets/pending_reservation_card_v2.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/features/reservations/pending/widgets/pending_payment_card_v2.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PendingReservationsPage extends StatefulWidget {
  static const String name = 'PENDING_RESERVATIONS';

  static String routePath() => '/pending-reservations';
  static String route() => routePath();

  final PendingReservationsCubit? cubit;
  final OwnerInvitationsCubit? invitationsCubit;
  final PendingReservationFilter? initialFilter;

  const PendingReservationsPage({
    super.key,
    this.cubit,
    this.invitationsCubit,
    this.initialFilter,
  });

  @override
  State<PendingReservationsPage> createState() =>
      _PendingReservationsPageState();
}

class _PendingReservationsPageState extends State<PendingReservationsPage> {
  late final PendingReservationsCubit _cubit;
  late final OwnerInvitationsCubit _invitationsCubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit ?? PendingReservationsCubit();
    if (widget.initialFilter != null) {
      _cubit.setFilter(widget.initialFilter!);
    }
    if (widget.cubit == null) {
      _cubit.init();
    }
    _invitationsCubit = widget.invitationsCubit ?? OwnerInvitationsCubit();
    if (widget.invitationsCubit == null) {
      _invitationsCubit.load();
    }
  }

  @override
  void dispose() {
    if (widget.cubit == null) {
      _cubit.close();
    }
    if (widget.invitationsCubit == null) {
      _invitationsCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _invitationsCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Réservations en attente',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocListener<PendingReservationsCubit, RequestState>(
          listener: (context, state) {
            if (state is REQUEST_SUCCESS) {
              ToastUtils.showSuccess(
                  title: "Action effectuée avec succès",
                  description: state.message);
            } else if (state is REQUEST_ERROR) {
              ToastUtils.showError(
                  description: state.error, title: 'Une erreur est survenue');
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF1F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoSlidingSegmentedControl<
                          PendingReservationFilter>(
                        groupValue: _cubit.currentFilter,
                        children: {
                          PendingReservationFilter.enAttenteReponse: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              'En attente de réponse',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _cubit.currentFilter ==
                                        PendingReservationFilter
                                            .enAttenteReponse
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _cubit.currentFilter ==
                                        PendingReservationFilter
                                            .enAttenteReponse
                                    ? const Color(0xFF1A1A1A)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          PendingReservationFilter.enAttentePaiement: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              'En attente de paiement',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _cubit.currentFilter ==
                                        PendingReservationFilter
                                            .enAttentePaiement
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _cubit.currentFilter ==
                                        PendingReservationFilter
                                            .enAttentePaiement
                                    ? const Color(0xFF1A1A1A)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _cubit.setFilter(value);
                            });
                          }
                        },
                        backgroundColor: Colors.transparent,
                        thumbColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                          _cubit.pagingController.refresh();
                          if (_cubit.currentFilter ==
                              PendingReservationFilter.enAttenteReponse) {
                            _invitationsCubit.load();
                          }
                        },
                      ),
                      if (_cubit.currentFilter ==
                          PendingReservationFilter.enAttenteReponse)
                        SliverToBoxAdapter(
                          child: BlocBuilder<OwnerInvitationsCubit,
                              OwnerInvitationsState>(
                            builder: (context, state) {
                               return Column(
                                 children: [
                                   if (state is OwnerInvitationsLoaded)
                                     ...state.items.map((item) =>
                                         PendingReservationCardV2(
                                             invitation: item)),
                                 ],
                               );
                            },
                          ),
                        ),
                      PagedSliverList<int, ReservationModel>(
                        pagingController: _cubit.pagingController,
                        builderDelegate: PagedChildBuilderDelegate(
                          firstPageProgressIndicatorBuilder: (context) =>
                              Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: List.generate(
                                5,
                                (index) => const BookingLoadingCard(),
                              ),
                            ),
                          ),
                          noItemsFoundIndicatorBuilder: (context) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Gap(80),
                                SvgPicture.asset(
                                  "assets/svgs/undraw/4.svg",
                                  width: 200,
                                ),
                                const Gap(30),
                                Text(
                                  "Aucune réservation en attente",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Gap(12),
                                Text(
                                  _cubit.currentFilter ==
                                          PendingReservationFilter
                                              .enAttenteReponse
                                      ? "Vous n'avez aucune réservation en attente de réponse pour le moment."
                                      : "Vous n'avez aucune réservation en attente de paiement par le client pour le moment.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (context, item, index) {
                            if (_cubit.currentFilter ==
                                PendingReservationFilter.enAttenteReponse) {
                              return PendingReservationCardV2(
                                reservationModel: item,
                              );
                            }
                            return PendingPaymentCardV2(
                              reservationModel: item,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
