import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/visits/visit_detail_page.dart';
import 'package:intl/intl.dart';

class VisitCard extends StatelessWidget {
  VisitCard({super.key, required this.demandeVisiteModel});
  final DemandeVisiteModel demandeVisiteModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CupertinoListTile(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: AppColors.scafold,
              showDragHandle: true,
              enableDrag: true,
              isScrollControlled: true,
              useRootNavigator: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              context: context,
              builder: (context) => FractionallySizedBox(
                  heightFactor: 0.6,
                  child: VisitDetailPage(
                    id: demandeVisiteModel.id,
                  )),
            );
          },
          backgroundColor: Colors.white,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

          leadingSize: 50,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          //horizontalTitleGap: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(FontAwesomeIcons.personWalkingLuggage,
                            size: 15, color: Colors.white),
                      ),
                      const Gap(10),
                      Text(
                        demandeVisiteModel.bienImmobilier!.nom,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  Chip(
                      backgroundColor:
                          (demandeVisiteModel.typeDemandeVisite == 'express')
                              ? Colors.deepOrange
                              : Colors.purple.shade300,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                      label: Text(
                          demandeVisiteModel.typeDemandeVisite.toString())),
                ],
              ),
              if (!demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                AutoSizeText(
                  "Vous devez choisir une date et une heure pour la visite",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.red),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                    Chip(
                      avatar: Icon(
                        color: AppColors.primary,
                        FontAwesomeIcons.triangleExclamation,
                        size: 15,
                      ),
                      backgroundColor: AppColors.scafold,
                      label: Text(Utils.formatDatenly(
                          dateTime: demandeVisiteModel
                              .datesDemandeVisite.first.date!)),
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                    ),
                  if (!demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                    Chip(
                      avatar: const Icon(
                        color: Colors.deepOrangeAccent,
                        FontAwesomeIcons.triangleExclamation,
                        size: 15,
                      ),
                      backgroundColor: Colors.deepOrangeAccent.withOpacity(0.2),
                      label: const Text('En attente'),
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.deepOrangeAccent,
                              ),
                    ),
                  if (demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                    AutoSizeText(
                      Utils.formatTimeOnly(
                          dateTime: demandeVisiteModel
                              .datesDemandeVisite.first.date!),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.primary),
                    ),
                ],
              )
            ],
          ),

          // leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
          // titleTextStyle: Theme.of(context).textTheme.bodyLarge,
          // subtitleTextStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
