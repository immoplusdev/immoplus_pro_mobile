// ignore_for_file: prefer_is_empty

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/features/visits/logic/booking_cubit.dart';
import 'package:immoplus_pro/features/visits/logic/visit_manager.dart';
import 'package:immoplus_pro/features/visits/logic/visit_request_state.dart';
import 'package:immoplus_pro/features/visits/widgets/estate_info.dart';
import 'package:immoplus_pro/utils/contact_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
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

  /// verifier si la demande de visite contient des dates
  // bool hasDateVisite(DemandeVisitResponse demandeVisitResponse) {
  //   return demandeVisitResponse.data.datesDemandeVisite.isNotEmpty;
  // }

  /// verifier si la demande de visite est payé
  bool hasPaid(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.statusFacture.toString() ==
        PaymentStatus.paye.name;
  }

  // bool hasNotPaid(DemandeVisitResponse demandeVisitResponse) {
  //   return demandeVisitResponse.data.statusFacture.toString() ==
  //       PaymentStatus.non_paye.name;
  // }

  /// verifier si la demande de visite contient une facture
  bool hasExpress(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.typeDemandeVisite.toString() == "express";
  }

  /// Getter pour determiner si on doit afficher le bouton de paiement
  // bool shouldShowPaymentButton(DemandeVisitResponse demandeVisitResponse) {
  //   // Cas 1: Express - afficher si pas payé ET qu'il y a des dates de visite
  //   if (hasExpress(demandeVisitResponse)) {
  //     return hasNotPaid(demandeVisitResponse) &&
  //         hasDateVisite(demandeVisitResponse);
  //   }
  //   return false;
  // }

  /// Getter pour determiner si on doit afficher le numéro du client
  (bool, String) shouldShowClientPhone(
      DemandeVisitResponse demandeVisitResponse) {
    // Cas 1: Express - afficher si on a payé
    if (hasExpress(demandeVisitResponse)) {
      return (
        hasPaid(demandeVisitResponse),
        "Vous avez pas accès au numéro du client tant que celui ci n'a pas payé la visite"
      );
    }
    // Cas 2: Normal (pas express) - afficher
    return (
      demandeVisitResponse.data.datesDemandeVisite.isNotEmpty,
      "Vous avez pas accès au numéro du client tant que vous n'avez pas programmé la visite"
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitCubit, VisitRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_VISIT) {
          /// la date d'acceptation de la visite doit etre uniquement le jour d'apres
          final lastDateAcceptVisit = hasExpress(state.demandeVisitResponse)
              ? DateTime.now().add(Duration(days: 1))
              : null;

          final startDate = DateTime.now().add(Duration(days: 1));
          final initialDate = DateTime.now().add(Duration(days: 1));

          final clientPhoneNumber =
              state.demandeVisitResponse.data.client?.phoneNumber ?? "";
          final (canShow, message) =
              shouldShowClientPhone(state.demandeVisitResponse);
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
                              // Vibrate.feedback(FeedbackType.impact);
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
                  if (state.demandeVisitResponse.data.datesDemandeVisite
                      .isEmpty) ...[
                    const SliverGap(5),
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
                    const SliverGap(5),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(bottom: 10),
                        child: Shimmer.fromColors(
                          baseColor: Colors.redAccent,
                          highlightColor: CupertinoColors.white,
                          period: const Duration(seconds: 5),
                          child: ListTile(
                            onTap: () {
                              VisitManager.getDateTime(
                                      lastDate: lastDateAcceptVisit,
                                      firstDate: startDate,
                                      initialDate: initialDate)
                                  .then(
                                (value) async {
                                  if (value != null) {
                                    EasyLoading.instance.backgroundColor =
                                        Colors.red;
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
                            leading: const Icon(
                              FontAwesomeIcons.calendarXmark,
                              color: Colors.redAccent,
                            ),
                            tileColor: Colors.red.shade100,
                            horizontalTitleGap: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const AutoSizeText(
                                maxLines: 1,
                                "Sélectionner le jour et l'heure de la visite"),
                            trailing: const Icon(
                              FontAwesomeIcons.circleChevronRight,
                              color: Colors.redAccent,
                            ),
                            titleTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (state
                      .demandeVisitResponse.data.datesDemandeVisite.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      sliver: SliverToBoxAdapter(
                        child: ListTile(
                          // onTap: () {
                          //   VisitManager.getDateTime(
                          //           lastDate: lastDateAcceptVisit,
                          //           firstDate: startDate,
                          //           initialDate: initialDate)
                          //       .then(
                          //     (value) async {
                          //       if (value != null) {
                          //         EasyLoading.instance.backgroundColor =
                          //             AppColors.primary;
                          //         EasyLoading.show(
                          //             status: 'Veuillez patienter..');
                          //         BienImmobilierRepository.programmerVisit(
                          //                 state.demandeVisitResponse.data.id,
                          //                 value)
                          //             .then((value) {
                          //           if (value != null) {
                          //             EasyLoading.dismiss();
                          //             context
                          //                 .read<VisitCubit>()
                          //                 .getVisit(id: widget.id);
                          //           }
                          //         });
                          //       }
                          //     },
                          //   );
                          // },
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
                          title: const Text("Jour et heure de visite"),
                          subtitle: AutoSizeText(Utils.formatDateTime(
                              dateTime: state.demandeVisitResponse.data
                                  .datesDemandeVisite.first.date!)),
                          subtitleTextStyle:
                              Theme.of(context).textTheme.titleLarge,
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          // trailing: Icon(
                          //   FontAwesomeIcons.circleChevronRight,
                          //   color: AppColors.primary,
                          // ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      height: 0,
                      thickness: 0.8,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: canShow
                          ? ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onTap: () {
                                Utils.makePhoneCall(clientPhoneNumber);
                              },
                              horizontalTitleGap: 0,
                              leading: Icon(
                                FontAwesomeIcons.buildingUser,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              title: const AutoSizeText(
                                'Contacter le client',
                                maxLines: 1,
                              ),
                              trailing: Icon(
                                FontAwesomeIcons.circleChevronRight,
                                size: 15,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(message),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    sliver: SliverToBoxAdapter(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          ContactUtils.showContact(id: widget.id);
                        },
                        horizontalTitleGap: 0,
                        leading: Icon(
                          FontAwesomeIcons.key,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        title: const AutoSizeText(
                          'Service client',
                          maxLines: 1,
                        ),
                        trailing: Icon(
                          FontAwesomeIcons.circleChevronRight,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
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
