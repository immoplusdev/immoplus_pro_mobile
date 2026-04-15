import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/selector_tile_v2.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/constants/furniture_taxonomy.dart';
import 'package:immoplus_pro/features/create_furniture_v2/logic/furniture_creation_cubit_v2.dart';
import 'package:immoplus_pro/features/create_furniture_v2/widgets/furniture_selector_sheet.dart';
import 'package:iconsax/iconsax.dart';

class Step2FurnitureDetailsPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2FurnitureDetailsPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step2FurnitureDetailsPage> createState() =>
      _Step2FurnitureDetailsPageState();
}

class _Step2FurnitureDetailsPageState extends State<Step2FurnitureDetailsPage> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<FurnitureCreationCubitV2>().state;
    _priceController =
        TextEditingController(text: currentState.furniture?.prix.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  String _displayCategory(String category) =>
      FurnitureTaxonomy.categoryLabels[category] ?? category;

  String _displayType(String type) => type
      .split('-')
      .map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '')
      .join(' ');

  Future<void> _openColorPicker() async {
    Color pickerColor = AppColors.primary;

    final bool picked = await ColorPicker(
      color: pickerColor,
      onColorChanged: (Color color) => pickerColor = color,
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text('Choisir une couleur',
          style: Theme.of(context).textTheme.titleMedium),
      subheading: Text('Sélectionnez une nuance',
          style: Theme.of(context).textTheme.bodySmall),
      showColorCode: false,
      showColorName: false,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 260, minWidth: 200, maxWidth: 250),
    );

    if (picked) {
      final currentColors = List<String>.from(context
              .read<FurnitureCreationCubitV2>()
              .state
              .furniture
              ?.metadata?['colors'] ??
          []);
      final hex =
          '#${pickerColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      if (!currentColors.contains(hex)) {
        currentColors.add(hex);
        context.read<FurnitureCreationCubitV2>().updateColors(currentColors);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Prix",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const Gap(25),

                // Catégorie
                const Text("Catégorie :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    final category = state.furniture?.category;
                    return SelectorTileV2(
                      icon: Iconsax.category,
                      hasValue: category != null,
                      value:
                          category != null ? _displayCategory(category) : null,
                      title: "Choisir une catégorie",
                      onTap: () {
                        FurnitureSelectorSheet.show(
                          context: context,
                          title: "Catégorie",
                          options: FurnitureTaxonomy.categories,
                          selectedValue: category,
                          labelBuilder: _displayCategory,
                          onSelected: (val) => context
                              .read<FurnitureCreationCubitV2>()
                              .updateCategory(val),
                        );
                      },
                    );
                  },
                ),
                const Gap(20),

                // Type
                const Text("Type :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    final category = state.furniture?.category;
                    final type = state.furniture?.type;
                    final types = category != null
                        ? (FurnitureTaxonomy.typesByCategory[category] ?? [])
                        : FurnitureTaxonomy.allTypes;

                    return SelectorTileV2(
                      icon: Iconsax.setting_2,
                      hasValue: type != null,
                      value: type != null ? _displayType(type) : null,
                      title: "Choisir un type",
                      onTap: () {
                        FurnitureSelectorSheet.show(
                          context: context,
                          title: "Type",
                          options: types,
                          selectedValue: type,
                          labelBuilder: _displayType,
                          onSelected: (val) => context
                              .read<FurnitureCreationCubitV2>()
                              .updateType(val),
                        );
                      },
                    );
                  },
                ),
                const Gap(20),

                // Couleur
                const Text("Couleur :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Text(
                    "Appuyer sur + pour ajouter , appuyer sur une couleur pour la retirer",
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                const Gap(12),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    final colors = List<String>.from(
                        state.furniture?.metadata?['colors'] ?? []);
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ...colors.map((hex) => _buildColorTile(hex)),
                        _buildAddColorButton(),
                      ],
                    );
                  },
                ),
                const Gap(20),

                // État
                const Text("Etat :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(12),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    final etat = state.furniture?.etat;
                    return Row(
                      children: [
                        _buildEtatButton("Neuf", "neuf", etat == "neuf"),
                        _buildEtatButton("Reconditionner", "reconditionne",
                            etat == "reconditionne"),
                        _buildEtatButton(
                            "Occasion", "occasion", etat == "occasion"),
                      ],
                    );
                  },
                ),
                const Gap(25),

                // Prix du bien
                const Text("Prix du bien :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = int.tryParse(val) ?? 0;
                    context.read<FurnitureCreationCubitV2>().updatePrix(p);
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("fcfa", style: TextStyle(color: Colors.grey))
                          ]),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
        BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
          builder: (context, state) {
            final isValid =
                context.read<FurnitureCreationCubitV2>().validateStep2();
            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
              onSave: isValid
                  ? () => context.read<FurnitureCreationCubitV2>().submit()
                  : null,
              saveText: context.read<FurnitureCreationCubitV2>().isEditing
                  ? "Enregistrer les modifications"
                  : "Finaliser et créer",
              showNext: context.read<FurnitureCreationCubitV2>().isEditing,
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorTile(String hex) {
    final color = _hexToColor(hex);
    return InkWell(
      onTap: () {
        final colors = List<String>.from(context
                .read<FurnitureCreationCubitV2>()
                .state
                .furniture
                ?.metadata?['colors'] ??
            []);
        colors.remove(hex);
        context.read<FurnitureCreationCubitV2>().updateColors(colors);
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)
          ],
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildAddColorButton() {
    return InkWell(
      onTap: _openColorPicker,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.customBlue, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: AppColors.customBlue, size: 20),
      ),
    );
  }

  Widget _buildEtatButton(String label, String value, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => context.read<FurnitureCreationCubitV2>().updateEtat(value),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: value == "neuf"
                ? const BorderRadius.horizontal(left: Radius.circular(12))
                : (value == "occasion"
                    ? const BorderRadius.horizontal(right: Radius.circular(12))
                    : BorderRadius.zero),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String rawHex) {
    final hex = rawHex.trim().replaceAll('#', '');
    if (hex.length != 6) return Colors.black;
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.black;
    }
  }
}
