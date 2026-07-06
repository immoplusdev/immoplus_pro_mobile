// ignore_for_file: prefer_is_empty

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/utils/utils.dart';

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
    getIt<AnalyticsService>().logVisitRequestReceived(idVisite: widget.id);
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
            backgroundColor: Colors.white,
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
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                        ),
                        title: const Text('Identifiant de la demande'),
                        subtitle: SelectableText(
                            state.demandeVisitResponse.data.id.toString()),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(Iconsax.copy),
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
                              .copyWith(color: AppColors.primary, fontSize: 13),
                        ),
                      ),
                    ),
                    const SliverGap(5),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(bottom: 10),
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
                                      AppColors.primary;
                                  EasyLoading.show(
                                      status: 'Veuillez patienter..');
                                  BienImmobilierRepository.programmerVisit(
                                          state.demandeVisitResponse.data.id,
                                          value)
                                      .then((val) {
                                    if (val != null) {
                                      getIt<AnalyticsService>().logVisitScheduled(
                                        idVisite: state.demandeVisitResponse.data.id,
                                        dateVisite: val.datesDemandeVisite.firstOrNull?.date?.toString() ?? value.toString(),
                                      );
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
                            Iconsax.calendar_tick,
                            color: AppColors.primary,
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                          ),
                          title: AutoSizeText(
                              maxLines: 1,
                              "Choisissez le jour et l'heure de la visite",
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                          ),
                          trailing: Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.primary,
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
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                          ),
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Iconsax.calendar_1,
                              color: AppColors.primary,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          horizontalTitleGap: 10,
                          title: const Text("Jour et heure de visite"),
                          subtitle: AutoSizeText(Utils.formatDateTime(
                              dateTime: state.demandeVisitResponse.data
                                  .datesDemandeVisite.first.date!)),
                          subtitleTextStyle:
                              Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                          titleTextStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  const SliverGap(5),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: canShow
                          ? ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                              ),
                              onTap: () {
                                Utils.makePhoneCall(clientPhoneNumber);
                              },
                              horizontalTitleGap: 10,
                              leading: Icon(
                                Iconsax.call,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              title: const AutoSizeText(
                                'Contacter le client',
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              trailing: Icon(
                                Iconsax.arrow_right_3,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(message),
                    ),
                  ),
                  const SliverGap(5),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
                    sliver: SliverToBoxAdapter(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          ContactUtils.showContact(id: widget.id);
                        },
                        horizontalTitleGap: 10,
                        leading: Icon(
                          Iconsax.support,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        title: const AutoSizeText(
                          'Service client',
                          maxLines: 1,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Iconsax.arrow_right_3,
                          size: 18,
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
