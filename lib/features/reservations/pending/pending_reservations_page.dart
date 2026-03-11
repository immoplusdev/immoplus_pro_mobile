import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservation_card.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PendingReservationsPage extends StatefulWidget {
  static const String name = 'PENDING_RESERVATIONS';

  static String routePath() => '/pending-reservations';
  static String route() => routePath();

  const PendingReservationsPage({super.key});

  @override
  State<PendingReservationsPage> createState() =>
      _PendingReservationsPageState();
}

class _PendingReservationsPageState extends State<PendingReservationsPage> {
  late final PendingReservationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PendingReservationsCubit();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reservations en attente'),
        ),
        backgroundColor: AppColors.whiteBackground,
        body: BlocListener<PendingReservationsCubit, RequestState>(
          listener: (context, state) {
            if (state is REQUEST_SUCCESS) {
              ToastUtils.showSuccess(
                  title: "Action effectuéee avec succès",
                  description: state.message);
            } else if (state is REQUEST_ERROR) {
              ToastUtils.showError(
                  description: state.error, title: 'Une erreur est survenue');
            }
          },
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    _cubit.pagingController.refresh();
                  },
                ),
                PagedSliverList<int, ReservationModel>(
                  pagingController: _cubit.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => const BookingLoadingCard(),
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                            "Aucune reservation en attente",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Gap(20),
                          const Text(
                            "Vous n'avez aucune reservation en attente de reponse pour le moment.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context, item, index) =>
                        PendingReservationCard(reservationModel: item),
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
