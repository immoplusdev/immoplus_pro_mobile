import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence_v2/enums/residence_type.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/features/create_residence_v2/logic/residence_creation_cubit_v2.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/common/widgets/v2/location_selector_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/piece_counter_v2.dart';

class Step1GeneralInfoPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step1GeneralInfoPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step1GeneralInfoPage> createState() => _Step1GeneralInfoPageState();
}

class _Step1GeneralInfoPageState extends State<Step1GeneralInfoPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<ResidenceCreationCubitV2>().state;
    _nameController = TextEditingController(text: currentState.nom);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du bien
                const Text("Nom du bien:",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                TextField(
                  controller: _nameController,
                  onChanged: (val) =>
                      context.read<ResidenceCreationCubitV2>().updateNom(val),
                  decoration: _inputDecoration(),
                ),
                const Gap(20),

                // Localisation
                const Text("Localisation :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) =>
                      p.ville != c.ville ||
                      p.commune != c.commune ||
                      p.adresse != c.adresse,
                  builder: (context, state) {
                    return LocationSelectorV2(
                      showVille: false,
                      showCommune: false,
                      currentVille: state.ville,
                      currentCommune: state.commune,
                      currentAdresse: state.adresse,
                      onVilleSelected: (ville) => context
                          .read<ResidenceCreationCubitV2>()
                          .updateVille(ville.id),
                      onCommuneSelected: (commune) => context
                          .read<ResidenceCreationCubitV2>()
                          .updateCommune(commune.id),
                      onPositionSelected: (address) {
                        log(
                          'Localisation sélectionnée → adresse: ${address.description}, '
                          'lat: ${address.latitude}, lng: ${address.longitude}',
                          name: 'RESIDENCE_LOCATION_V2',
                        );
                        context.read<ResidenceCreationCubitV2>().updateLocalisation(
                              address.description!,
                              PositionModel(
                                type: 'Point',
                                coordinates: [
                                  address.longitude!,
                                  address.latitude!
                                ],
                              ),
                            );
                      },
                    );
                  },
                ),
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) =>
                      p.position != c.position || p.adresse != c.adresse,
                  builder: (context, state) {
                    final hasCoords = state.position.coordinates.length == 2;
                    return Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      color: Colors.yellow,
                      child: Text(
                        hasCoords
                            ? 'DEBUG lat: ${state.position.coordinates[1]}  '
                                'lng: ${state.position.coordinates[0]}\n'
                                'adresse: ${state.adresse}'
                            : 'DEBUG aucune position (coordinates: ${state.position.coordinates})',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                const Gap(20),

                // Décrivez nous votre logement (Type)
                const Text("Décrivez nous votre logement :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) => p.typeResidence != c.typeResidence,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ResidenceType.values.map((type) {
                        return _buildTypeTile(
                          context,
                          type: type.value,
                          title: type.label,
                          iconKey: type.iconKey,
                          isSelected: state.typeResidence == type.value,
                        );
                      }).toList(),
                    );
                  },
                ),
                const Gap(25),

                // Nombre de pièces du logement
                const Text("Nombre de pièces du logement :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) => p.pieces != c.pieces,
                  builder: (context, state) {
                    final cubit = context.read<ResidenceCreationCubitV2>();
                    return Column(
                      children: [
                        PieceCounterV2(
                          title: "Salon",
                          value: cubit.getPieceQuantity("Salon"),
                          onUpdate: (delta) =>
                              cubit.updatePieceQuantity("Salon", delta),
                        ),
                        PieceCounterV2(
                          title: "Chambre",
                          value: cubit.getPieceQuantity("Chambre"),
                          onUpdate: (delta) =>
                              cubit.updatePieceQuantity("Chambre", delta),
                        ),
                        PieceCounterV2(
                          title: "Salle de bains",
                          value: cubit.getPieceQuantity("Salle de bains"),
                          onUpdate: (delta) => cubit.updatePieceQuantity(
                              "Salle de bains", delta),
                        ),
                        PieceCounterV2(
                          title: "Cuisine",
                          value: cubit.getPieceQuantity("Cuisine"),
                          onUpdate: (delta) =>
                              cubit.updatePieceQuantity("Cuisine", delta),
                        ),
                        PieceCounterV2(
                          title: "Salle à manger",
                          value: cubit.getPieceQuantity("Salle à manger"),
                          onUpdate: (delta) => cubit.updatePieceQuantity(
                              "Salle à manger", delta),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          builder: (context, state) {
            final isValid = state.nom.isNotEmpty &&
                state.typeResidence.isNotEmpty &&
                state.adresse.isNotEmpty;
            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
              onSave: isValid
                  ? (state.id != null
                      ? () => context.read<ResidenceCreationCubitV2>().submit()
                      : widget.onNext)
                  : null,
              saveText: state.id != null
                  ? "Enregistrer les modifications"
                  : "Continuer",
              showNext: state.id != null,
            );
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Widget _buildTypeTile(BuildContext context,
      {required String type,
      required String title,
      required String iconKey,
      required bool isSelected}) {
    return InkWell(
      onTap: () => context
          .read<ResidenceCreationCubitV2>()
          .updateTypeResidence(type.toLowerCase()),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 105,
        height: 105,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4FA) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              SVGMap.map[iconKey] ?? '',
              height: 35,
              color: isSelected ? AppColors.primary : Colors.grey.shade700,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey.shade800,
              ),
            )
          ],
        ),
      ),
    );
  }
}
