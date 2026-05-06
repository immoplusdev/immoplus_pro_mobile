import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/create_residence_v2/create_lodgment_page_v2.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_logment_available_day.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_logment_infos.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/features/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/features/shared_widgets/detail_action_bottom_bar.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_logment_appbar.dart';

class ResidenceDetailsPageV2 extends StatefulWidget {
  const ResidenceDetailsPageV2({
    super.key,
    required this.idProduct,
  });

  final String idProduct;
  static String name = 'RESIDENCE_DETAILS_PAGE_V2';

  static String routePath() => '/residence_details_v2/:id';

  @override
  State<ResidenceDetailsPageV2> createState() => _ResidenceDetailsPageV2State();
}

class _ResidenceDetailsPageV2State extends State<ResidenceDetailsPageV2> {
  @override
  void initState() {
    _getResidenceById();
    super.initState();
  }

  _getResidenceById() {
    context.read<LogmentCubit>().getResidence(id: widget.idProduct);
  }

  void _onEdit(ResidenceModel residence) {
    context
        .pushNamed(CreateLodgmentPageV2.name, extra: residence)
        .then((result) {
      if (result == true && mounted) {
        _getResidenceById();
      }
    });
  }

  Future<void> _onDelete(ResidenceModel residence) async {
    final result = await AppDialog.confirmDialog(
      context: context,
      content:
          'Êtes-vous sûr de vouloir supprimer cette résidence ? Cette action est irréversible.',
    );
    if (result == true && mounted) {
      context.read<LogmentCubit>().deleteResidence(id: residence.id);
    }
  }

  Future<void> _onToggleAvailability(ResidenceModel residence) async {
    if (residence.residenceDisponible) {
      await AppDialog.confirm(
        context: context,
        content:
            'Les résidences indisponibles ne seront pas accessibles aux clients pour effectuer des réservations.',
        rollback: () {
          context.read<LogmentCubit>().updateResidence(
            id: residence.id,
            datas: {'residenceDisponible': false},
          );
          context.pop();
        },
      );
    } else {
      context.read<LogmentCubit>().updateResidence(
        id: residence.id,
        datas: {'residenceDisponible': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogmentCubit, RequestState>(
      listener: (context, state) {
        if (state is REQUEST_SUCCESS) {
          ToastUtils.showSuccess(
              title: "Opération réussie", description: state.message);
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_RESIDENCE_DATA) {
          final residence = state.data;
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: <Widget>[
                // OLD DESIGN APP BAR (Carousel)
                DetailLogmentAppBar(logmentModel: residence),

                // TITLE & PRICE (Inside a SliverToBoxAdapter because it's a Box)
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                residence.nom,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey, size: 16),
                                  const Gap(4),
                                  Expanded(
                                    child: Text(
                                      residence.commune,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Text(
                          Utils.formatCurrency(residence.prixReservation),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // STATS / ROOMS (Components are already Slivers)
                DetailLogmentRooms(logmentModel: residence),

                // INFO (Components are already Slivers)
                const SliverToBoxAdapter(child: Gap(10)),
                DetailLogmentInfos(reservation: residence),

                // DESCRIPTION
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   "À propos de ce logement",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w800,
                        //   ),
                        // ),
                        // const Gap(12),
                        // MarkdownBody(
                        //   data: residence.description ?? '',
                        //   styleSheet: MarkdownStyleSheet(
                        //     p: const TextStyle(
                        //       fontSize: 15,
                        //       color: Colors.black87,
                        //       height: 1.5,
                        //     ),
                        //   ),
                        // ),
                        // const Gap(30),
                        // // const DetailDivider(),
                        // const Gap(30),
                        const Text(
                          "Disponibilité",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CALENDAR / AVAILABLE DAYS (Already a Sliver)
                DetailLogmentAvailableDay(reservation: residence),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const Gap(16),
                        OutlinedButton(
                          onPressed: () =>
                              _showUnavailabilityManager(context, residence),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child:
                              const Text("Gérer les dates d'indisponibilité"),
                        ),
                        const Gap(40),
                        // // const DetailDivider(),
                        // const Gap(30),
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Règles de la maison",
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w800,
                        //     ),
                        //   ),
                        // ),
                        // const Gap(16),
                      ],
                    ),
                  ),
                ),

                // RULES (Already a Sliver)
                // DetailLogmentRules(logmentModel: residence),

                // const SliverToBoxAdapter(child: Gap(100)),
              ],
            ),
            bottomNavigationBar: DetailActionBottomBar(
              isInactive: !residence.residenceDisponible,
              isUpdatingStatus: false,
              onEdit: () => _onEdit(residence),
              onDelete: () => _onDelete(residence),
              onToggleAvailability: () => _onToggleAvailability(residence),
              config: const DetailActionBottomBarConfig(
                editLabel: 'Modifier',
              ),
            ),
          );
        }

        return InitialDetailLogmentScreen(
          idProduct: widget.idProduct,
        );
      },
    );
  }

  void _showUnavailabilityManager(
      BuildContext context, ResidenceModel residence) {
    // Reusing the legacy logic for now as it's quite complex and robust
    // but wrapping it for better look
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const Gap(10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(20),
            Expanded(
              child: _CalendarManager(
                  residence: residence, onRefresh: _getResidenceById),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarManager extends StatefulWidget {
  final ResidenceModel residence;
  final VoidCallback onRefresh;
  const _CalendarManager({required this.residence, required this.onRefresh});

  @override
  State<_CalendarManager> createState() => _CalendarManagerState();
}

class _CalendarManagerState extends State<_CalendarManager> {
  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDates = widget.residence.datesReservation
        .map((dateRes) {
          try {
            return DateTime.parse(dateRes.date);
          } catch (e) {
            return null;
          }
        })
        .where((date) => date != null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            "Gérer les dates",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const Gap(4),
          const Text(
            "Sélectionnez les dates à bloquer pour vos clients",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const Gap(20),
          Expanded(
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.multi,
                selectedDayHighlightColor: AppColors.primary,
                firstDate: DateTime.now(),
              ),
              value: _selectedDates,
              onValueChanged: (dates) => setState(() => _selectedDates = dates),
            ),
          ),
          CustomButtom(
            onClick: () async {
              List<String> formattedDates = _selectedDates
                  .where((date) => date != null)
                  .map((date) =>
                      "${date!.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}")
                  .toList();

              await context.read<LogmentCubit>().updateUnavailabilityDates(
                    id: widget.residence.id,
                    dates: formattedDates,
                  );
              widget.onRefresh();
              context.pop();
            },
            text: 'Valider (${_selectedDates.length} dates)',
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
