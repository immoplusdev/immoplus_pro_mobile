import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class EstateBottomBar extends StatelessWidget {
  const EstateBottomBar({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      height: 80,
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: Utils.formatCurrency(bienImmobilier.prix),
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: bienImmobilier.typeLocation,
                    style: TextStyle(color: Colors.grey.shade700))
              ]))),
          Flexible(
            child: CustomButtom(
              onClick: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  showDragHandle: true,
                  backgroundColor: AppColors.scafold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'En cours de développement',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.redAccent),
                      ),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.filePen,
                          color: AppColors.primary,
                        ),
                        tileColor: Colors.white,
                        title: const Text('Modifier le bien'),
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.primary),
                        trailing: Icon(
                          FontAwesomeIcons.circleArrowRight,
                          color: AppColors.primary,
                        ),
                        onTap: () {
                          EstateCreationModelBuilder()
                              .fromModel(bienImmobilier);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            context: context,
                            builder: (context) {
                              return const FractionallySizedBox(
                                heightFactor: 0.9,
                                child: CreateEstatePage(),
                              );
                            },
                          ).then(
                            (value) {
                              EstateCreationModelBuilder().reset();
                            },
                          );
                        },
                      ),
                      const Gap(3),
                      Visibility(
                        visible: bienImmobilier.bienImmobilierDisponible,
                        replacement: ListTile(
                          onTap: () {
                            context
                                .read<EstateCubit>()
                                .updateEstate(id: bienImmobilier.id, data: {
                              "bienImmobilierDisponible": true,
                            });
                            context.pop();
                          },
                          leading: const Icon(
                            FontAwesomeIcons.doorOpen,
                            color: Colors.green,
                          ),
                          tileColor: Colors.white,
                          title: const Text('Rendre le bien disponible'),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.green),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Colors.green,
                          ),
                        ),
                        child: ListTile(
                          onTap: () async {
                            await AppDialog.confirm(
                                context: context,
                                content:
                                    "Les résidences indisponibles ne seront pas accessibles aux clients pour effectuer des réservations.",
                                rollback: () {
                                  context.read<EstateCubit>().updateEstate(
                                      id: bienImmobilier.id,
                                      data: {
                                        "bienImmobilierDisponible": false,
                                      });
                                  context.pop();
                                });
                            context.pop();
                          },
                          leading: const Icon(
                            FontAwesomeIcons.doorClosed,
                            color: Colors.red,
                          ),
                          tileColor: Colors.white,
                          title: const Text('Rendre le bien indisponible'),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.red),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const Gap(3),
                      ListTile(
                        leading: const Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                        ),
                        tileColor: Colors.transparent,
                        title: const Text('Supprimer la résidence'),
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.red),
                        trailing: const Icon(
                          FontAwesomeIcons.circleArrowRight,
                          color: Colors.red,
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ).then(
                  (value) {
                    EstateCreationModelBuilder().reset();
                  },
                );
              },
              text: 'MODIFIER',
            ),
          ),
        ],
      ),
    );
  }
}
