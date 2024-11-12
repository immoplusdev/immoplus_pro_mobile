// ignore_for_file: prefer_is_empty

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/utils/contact_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/views/visits/logic/booking_cubit.dart';
import 'package:immoplus_pro/views/visits/logic/visit_manager.dart';
import 'package:immoplus_pro/views/visits/logic/visit_request_state.dart';
import 'package:immoplus_pro/views/visits/widgets/estate_info.dart';
import 'package:shimmer/shimmer.dart';

///////

class VisitDetailPage extends StatefulWidget {
  const VisitDetailPage({super.key, required this.id});
  final String id;
  @override
  State<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<VisitCubit>().getVisit(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitCubit, VisitRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_VISIT) {
          return Scaffold(
            backgroundColor: AppColors.scafold,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      this
                          .context
                          .read<VisitCubit>()
                          .getVisit(id: state.demandeVisitResponse.data.id);
                    },
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: EstateInfo(
                        bienImmobilierModel:
                            state.demandeVisitResponse.data.bienImmobilier!),
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
                        title: const Text('Identifiant de la demande:'),
                        subtitle: SelectableText(
                            state.demandeVisitResponse.data.id.toString()),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(FontAwesomeIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.demandeVisitResponse.data.id
                                        .toString()))
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
                  const SliverGap(10),
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isEmpty)
                    const SliverGap(5),
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Vous devez sélectionner le jour et l’heure auxquels le client visitera le bien immobilier pour valider cette demande.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 166, 41, 41)),
                        ),
                      ),
                    ),
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isEmpty)
                    const SliverGap(5),
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(bottom: 10),
                        child: Shimmer.fromColors(
                          baseColor: AppColors.primary,
                          highlightColor: CupertinoColors.white,
                          period: const Duration(seconds: 5),
                          child: ListTile(
                            onTap: () {
                              VisitManager.getDateTime().then(
                                (value) async {
                                  if (value != null) {
                                    EasyLoading.instance.backgroundColor =
                                        AppColors.primary;
                                    EasyLoading.show(
                                        status: 'Veuillez patienter..');
                                    BienImmobilierRepository.programmerVisit(
                                            state.demandeVisitResponse.data.id,
                                            value)
                                        .then((value) {
                                      if (value != null) {
                                        EasyLoading.dismiss();
                                        context
                                            .read<VisitCubit>()
                                            .getVisit(id: widget.id);
                                      }
                                    });
                                  }
                                },
                              );
                            },
                            leading: Icon(
                              FontAwesomeIcons.calendarXmark,
                              color: AppColors.primary,
                            ),
                            tileColor: Colors.blue.shade100,
                            horizontalTitleGap: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                                "Sélectionner le jour et l'heure de la visite"),
                            trailing: Icon(
                              FontAwesomeIcons.circleChevronRight,
                              color: AppColors.primary,
                            ),
                            titleTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      sliver: SliverToBoxAdapter(
                        child: ListTile(
                          onTap: () {
                            VisitManager.getDateTime().then(
                              (value) async {
                                if (value != null) {
                                  EasyLoading.instance.backgroundColor =
                                      AppColors.primary;
                                  EasyLoading.show(
                                      status: 'Veuillez patienter..');
                                  BienImmobilierRepository.programmerVisit(
                                          state.demandeVisitResponse.data.id,
                                          value)
                                      .then((value) {
                                    if (value != null) {
                                      EasyLoading.dismiss();
                                      context
                                          .read<VisitCubit>()
                                          .getVisit(id: widget.id);
                                    }
                                  });
                                }
                              },
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              FontAwesomeIcons.calendarDay,
                              color: AppColors.primary,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          horizontalTitleGap: 4,
                          title: const Text("Jour et heur de visite"),
                          subtitle: AutoSizeText(Utils.formatDateTime(
                              dateTime: state.demandeVisitResponse.data
                                  .datesDemandeVisite.first.date!)),
                          subtitleTextStyle:
                              Theme.of(context).textTheme.titleLarge,
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          trailing: Icon(
                            FontAwesomeIcons.circleChevronRight,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: Divider()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
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
                            color: AppColors.primary,
                          ),
                          title: const Text("Contacter nous"),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.primary),
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
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
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
                          leading: const CircleAvatar(
                            //backgroundColor: Colors.white,
                            child: Icon(
                              FontAwesomeIcons.userTie,
                              //color: Colors.green,
                            ),
                          ),
                          title: const Text("Client"),
                          subtitle: Text(state
                              .demandeVisitResponse.data.clientPhoneNumber!
                              .split('-')
                              .last
                              .toString()),
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          trailing: Icon(
                            FontAwesomeIcons.phoneVolume,
                            color: AppColors.primary,
                          ),
                          subtitleTextStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.primary),
                          onTap: () async {
                            final phone = state
                                .demandeVisitResponse.data.clientPhoneNumber!
                                .split('-');
                            Utils.makePhoneCall(phone.last);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SliverGap(10),
                ],
              ),
            ),
          );
        } else if (state is Error_VISITSS) {
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
                        //context.goNamed(BookingPage.name);
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
