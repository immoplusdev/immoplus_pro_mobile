import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class LogmentBottomBar extends StatelessWidget {
  const LogmentBottomBar({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
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
                    text: Utils.formatCurrency(logmentModel.prixReservation),
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: ' par jours',
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
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.filePen,
                          color: AppColors.primary,
                        ),
                        tileColor: Colors.white,
                        title: const Text('Modifier la résidence'),
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.primary),
                        trailing: Icon(
                          FontAwesomeIcons.circleArrowRight,
                          color: AppColors.primary,
                        ),
                        onTap: () {
                          ResidenceCreationModelBuilder()
                              .fromModel(logmentModel);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            context: context,
                            builder: (context) {
                              return const FractionallySizedBox(
                                heightFactor: 0.93,
                                child: CreateLodgmentPage(),
                              );
                            },
                          ).then(
                            // value return by CreateLodgmentPage
                            (value) {
                              if (value == true) {
                                context.pop();
                                ResidenceCreationModelBuilder().reset();
                                context
                                    .read<LogmentCubit>()
                                    .getResidence(id: logmentModel.id);
                              }
                            },
                          );
                        },
                      ),
                      const Gap(3),
                      Visibility(
                        visible: logmentModel.residenceDisponible,
                        replacement: ListTile(
                          onTap: () {
                            context
                                .read<LogmentCubit>()
                                .updateResidence(id: logmentModel.id, datas: {
                              "residenceDisponible": true,
                            });
                            context.pop();
                          },
                          leading: const Icon(
                            FontAwesomeIcons.doorOpen,
                            color: Colors.green,
                          ),
                          tileColor: Colors.white,
                          title: const Text('Rendre la résidence disponible'),
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
                                  context.read<LogmentCubit>().updateResidence(
                                      id: logmentModel.id,
                                      datas: {
                                        "residenceDisponible": false,
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
                          title: const Text('Rendre la résidence indisponible'),
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
                    ResidenceCreationModelBuilder().reset();
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
