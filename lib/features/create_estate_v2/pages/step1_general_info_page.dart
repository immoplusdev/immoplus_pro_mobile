import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate_v2/enums/estate_type.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/features/create_estate_v2/logic/estate_creation_cubit_v2.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/common/widgets/v2/location_selector_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';

class Step1EstateGeneralInfoPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step1EstateGeneralInfoPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step1EstateGeneralInfoPage> createState() =>
      _Step1EstateGeneralInfoPageState();
}

class _Step1EstateGeneralInfoPageState
    extends State<Step1EstateGeneralInfoPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<EstateCreationCubitV2>().state;
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
                      context.read<EstateCreationCubitV2>().updateNom(val),
                  decoration: _inputDecoration(),
                ),
                const Gap(20),

                // Localisation
                const Text("Localisation :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
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
                          .read<EstateCreationCubitV2>()
                          .updateVille(ville.id),
                      onCommuneSelected: (commune) => context
                          .read<EstateCreationCubitV2>()
                          .updateCommune(commune.id),
                      onPositionSelected: (address) => context
                          .read<EstateCreationCubitV2>()
                          .updateLocalisation(
                            address.description!,
                            PositionModel(
                              type: 'Point',
                              coordinates: [
                                address.longitude!,
                                address.latitude!
                              ],
                            ),
                          ),
                    );
                  },
                ),
                const Gap(20),

                // Décrivez nous votre logement (Type)
                const Text("Décrivez nous votre logement :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
                  buildWhen: (p, c) =>
                      p.typeBienImmobilier != c.typeBienImmobilier,
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: EstateType.values.map((type) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildTypeTile(
                              context,
                              type: type.value,
                              title: type.label,
                              iconKey: type.iconKey,
                              isSelected: state.typeBienImmobilier == type.value,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const Gap(25),

                // Nombre de pièces du logement
                const Text("Nombre de pièces du logement :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                _buildPieceCounter(context, "Salon"),
                _buildPieceCounter(context, "Chambre"),
                _buildPieceCounter(context, "Salle de bains"),
                _buildPieceCounter(context, "Cuisine"),
                _buildPieceCounter(context, "Salle à manger"),
              ],
            ),
          ),
        ),
        BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
          builder: (context, state) {
            final isValid = state.nom.isNotEmpty &&
                state.typeBienImmobilier.isNotEmpty &&
                state.adresse.isNotEmpty;
            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
              onSave: isValid
                  ? (state.id != null
                      ? () => context.read<EstateCreationCubitV2>().submit()
                      : widget.onNext)
                  : null,
              saveText: state.id != null ? "Enregistrer les modifications" : "Continuer",
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
          .read<EstateCreationCubitV2>()
          .updateTypeBien(type.toLowerCase()),
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

  Widget _buildPieceCounter(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
            buildWhen: (p, c) => p.pieces != c.pieces,
            builder: (context, state) {
              final val =
                  context.read<EstateCreationCubitV2>().getPieceQuantity(title);
              return Text(
                val.toString().padLeft(2, '0'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              );
            },
          ),
          const Gap(15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          InkWell(
            onTap: () => context
                .read<EstateCreationCubitV2>()
                .updatePieceQuantity(title, 1),
            child: Icon(Icons.add_circle, color: AppColors.primary, size: 28),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              final val = context
                  .read<EstateCreationCubitV2>()
                  .getPieceQuantity(title);
              if (val > 0) {
                context
                    .read<EstateCreationCubitV2>()
                    .updatePieceQuantity(title, -1);
              }
            },
            child:
                Icon(Icons.remove_circle, color: AppColors.primary, size: 28),
          ),
        ],
      ),
    );
  }
}
