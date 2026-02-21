import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_divider.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/features/residence_detail/components/see_more_button.dart';
import 'package:immoplus_pro/features/shared_widgets/detail_action_bottom_bar.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/features/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:video_player/video_player.dart';

import 'components/detail_logment_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_available_day.dart';
import 'components/detail_logment_infos.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';
import 'components/detail_rules.dart';

class ResidenceDetailsPage extends StatefulWidget {
  const ResidenceDetailsPage({
    super.key,
    required this.idProduct,
  });

  final String idProduct;
  static String name = 'logment_details_page';

  static String routePath() => '/logment_details_page/:id';

  static String route({String? id}) {
    return '/logment_details_page/$id';
  }

  @override
  State<ResidenceDetailsPage> createState() => _ResidenceDetailsPageState();
}

class _ResidenceDetailsPageState extends State<ResidenceDetailsPage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    _getResidenceById();
    super.initState();
  }

  _getResidenceById() {
    context.read<LogmentCubit>().getResidence(id: widget.idProduct);
  }

  void _onEdit(ResidenceModel residence) {
    ResidenceCreationModelBuilder().fromModel(residence);
    context.pushNamed(CreateLodgmentPage.name).then((result) {
      if (result == true && mounted) {
        ResidenceCreationModelBuilder().reset();
        context.read<LogmentCubit>().getResidence(id: residence.id);
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
  void dispose() {
    super.dispose();
    () async {}();
    print('dispose');
    //DataProvider().stopRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogmentCubit, RequestState>(
      listener: (context, state) {
        if (state is REQUEST_SUCCESS) {
          ToastUtils.showSuccess(
              title: "Opération réussie", description: state.message);
          ResidenceCreationModelBuilder().reset();
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_RESIDENCE_DATA) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailLogmentAppBar(logmentModel: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    _getResidenceById();
                  },
                ),
                //productName
                DetailLogmentName(residenceModel: state.data),
                DetailLogmentRooms(logmentModel: state.data),
                //product adress
                DetailLogmentInfos(reservation: state.data),
                //réservation offers
                // const DetailDivider(),
                // const DetailLogmentTitle2(title: 'Ce que propose ce logement'),
                // DetailLogmentAmentities(residenceModel: state.data),
                // const SliverGap(10),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: OutlinedButton(
                //       style: OutlinedButton.styleFrom(
                //           side: BorderSide(color: AppColors.primary)),
                //       onPressed: () {
                //         showModalBottomSheet(
                //           backgroundColor: AppColors.scafold,
                //           showDragHandle: true,
                //           enableDrag: true,
                //           isScrollControlled: true,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(20)),
                //           context: context,
                //           builder: (context) => Container(
                //               child: Padding(
                //             padding: const EdgeInsets.only(bottom: 20),
                //             child: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: state.data.commodites
                //                   .map(
                //                     (e) => Padding(
                //                       padding: const EdgeInsets.only(bottom: 5),
                //                       child: ListTile(
                //                         leading: CircleAvatar(
                //                           child: SvgPicture.asset(
                //                             SVGMap.map[e.icon] ?? '',
                //                             height: 20,
                //                             width: 20,
                //                           ),
                //                         ),
                //                         tileColor: Colors.white,
                //                         title: Text(e.text),
                //                       ),
                //                     ),
                //                   )
                //                   .toList(),
                //             ),
                //           )),
                //         );
                //       },
                //       child: Text(
                //           "Voir tout les ${state.data.commodites.length} commodités"),
                //     ),
                //   ),
                // ),
                // const DetailDivider(),
                // //vidéo section
                // DetailLogmentVideo(logmentModel: state.data),
                // //description next
                // SliverToBoxAdapter(
                //   child: Container(
                //     padding: const EdgeInsets.only(top: 5),
                //     color: Colors.white,
                //     height: 100,
                //     child: Markdown(
                //       physics: const NeverScrollableScrollPhysics(),
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       data: state.data.description ??
                //           '', //state.finishData.data!.description!,
                //       //styleSheet: MarkdownStyleSheet(),
                //     ),
                //   ),
                // ),
                // SeeMoreButton(
                //   text: state.data.description,
                // ),

                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     childCount: 4,
                //     (context, index) => SizedBox(
                //       height: 30,
                //       child: ListTile(
                //         horizontalTitleGap: 0,
                //         leading: Icon(Icons.child_care_outlined),
                //         title: Text('Convient aux bébés (moins de 2 ans)'),
                //       ),
                //     ),
                //   ),
                // ),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10),
                //     child: OutlinedButton(
                //       onPressed: () {},
                //       child: Text("Voir toutes les informations"),
                //     ),
                //   ),
                // ),
                const DetailDivider(),
                const DetailLogmentTitle2(title: 'Jours disponibles'),
                DetailLogmentAvailableDay(
                  reservation: state.data,
                ),

                /// choisir les dates de reservation
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {
                        // Convertir les dates de réservation existantes en DateTime
                        List<DateTime?> selectedDates =
                            state.data.datesReservation
                                .map((dateRes) {
                                  try {
                                    return DateTime.parse(dateRes.date);
                                  } catch (e) {
                                    return null;
                                  }
                                })
                                .where((date) => date != null)
                                .toList();

                        showModalBottomSheet(
                          backgroundColor: AppColors.scafold,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (context) => FractionallySizedBox(
                            heightFactor: 1,
                            child: StatefulBuilder(
                              builder: (context, setModalState) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Gap(MediaQuery.of(context).padding.top +
                                        10),
                                    Container(
                                      height: kToolbarHeight,
                                      alignment: Alignment.topLeft,
                                      child: UnconstrainedBox(
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.blue65BAF0),
                                            child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color: AppColors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Gérer les dates d'indisponibilité",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const Gap(10),
                                    Text(
                                      "Sélectionnez les dates à bloquer",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Transform.scale(
                                          scale: 1,
                                          child: CalendarDatePicker2(
                                            config: CalendarDatePicker2Config(
                                              disableModePicker: true,
                                              firstDayOfWeek: 1,
                                              calendarType:
                                                  CalendarDatePicker2Type.multi,
                                              selectedDayTextStyle:
                                                  const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              selectedDayHighlightColor:
                                                  Colors.transparent,
                                              centerAlignModePicker: true,
                                              customModePickerIcon:
                                                  const SizedBox(),
                                              firstDate: DateTime.now(),
                                              selectableDayPredicate: (day) {
                                                // Empêcher la sélection des dates passées
                                                return day.isAfter(
                                                  DateTime.now().subtract(
                                                      const Duration(days: 1)),
                                                );
                                              },
                                              dayBuilder: ({
                                                required date,
                                                decoration,
                                                isDisabled,
                                                isSelected,
                                                isToday,
                                                textStyle,
                                              }) {
                                                return CircleAvatar(
                                                  backgroundColor: isSelected!
                                                      ? AppColors.primary
                                                          .withOpacity(0.3)
                                                      : Colors.transparent,
                                                  child: Text(
                                                    date.day.toString(),
                                                    style: TextStyle(
                                                      color: isDisabled!
                                                          ? Colors.grey.shade400
                                                          : isSelected
                                                              ? AppColors
                                                                  .primary
                                                              : Colors.black,
                                                      fontWeight: isSelected
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      decoration: isSelected
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                );
                                              },
                                              weekdayLabels: [
                                                'Dim',
                                                'Lun',
                                                'Mar',
                                                'Mer',
                                                'Jeu',
                                                'Ven',
                                                'Sam'
                                              ],
                                              weekdayLabelTextStyle:
                                                  const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controlsHeight: 50,
                                              controlsTextStyle:
                                                  const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            value: selectedDates,
                                            onValueChanged: (dates) {
                                              setModalState(() {
                                                selectedDates = dates;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(20),
                                    CustomButtom(
                                      onClick: () async {
                                        // Formater toutes les dates sélectionnées
                                        List<String> formattedDates =
                                            selectedDates
                                                .where((date) => date != null)
                                                .map((date) {
                                          return "${date!.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                        }).toList();

                                        // Fermer la bottom sheet
                                        // Navigator.pop(context);

                                        // Un seul appel API pour tout mettre à jour
                                        await context
                                            .read<LogmentCubit>()
                                            .updateUnavailabilityDates(
                                              id: state.data.id,
                                              dates: formattedDates,
                                            );

                                        // Rafraîchir la page
                                        _getResidenceById();
                                      },
                                      text:
                                          'Valider (${selectedDates.length} ${selectedDates.length > 1 ? "dates" : "date"})',
                                    ),
                                    const Gap(20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text("Choisir les dates d'indisponibilités"),
                    ),
                  ),
                ),
                //information supplementaire
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                const SliverToBoxAdapter(child: Gap(20)),
                const DetailDivider(),
                // const DetailLogmentTitle2(title: 'Où se situe le logement'),
                // DetailLogmentMap(residence: state.data),
                const DetailDivider(),
                const SliverGap(10),
                const DetailLogmentTitle2(title: 'Règles de la maison'),
                DetailLogmentRules(logmentModel: state.data),

                //DetailLogmentTitle2(title: 'Voir aussi'),
                //SliverToBoxAdapter(child: SimilarProductSection()),
                const SliverToBoxAdapter(child: Gap(15)),
              ],
            ),
            bottomNavigationBar: DetailActionBottomBar(
              isInactive: !state.data.residenceDisponible,
              isUpdatingStatus: false,
              onEdit: () => _onEdit(state.data),
              onDelete: () => _onDelete(state.data),
              onToggleAvailability: () => _onToggleAvailability(state.data),
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
}
