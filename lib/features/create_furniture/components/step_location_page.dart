import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_listtile.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_listtile.dart';

/// Step 2 du stepper de création de meuble : Localisation.

class StepLocationPage extends StatefulWidget {
  const StepLocationPage({super.key});

  static String name = 'step_location_page';

  @override
  State<StepLocationPage> createState() => _StepLocationPageState();
}

class _StepLocationPageState extends State<StepLocationPage> {
  final _manager = FurnitureCreationManager();

  /// Vérifie si l'adresse est renseignée (champ obligatoire).
  bool get _isAdresseValid =>
      _manager.adresse != null && _manager.adresse!.trim().isNotEmpty;

  /// Ouvre la page de sélection de position GPS en bottom sheet.
  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LocationPage(),
      ),
    ).then((value) {
      inspect(value);
      if (value is Address) {
        setState(() {
          _manager.adresse = value.description ?? '';
          _manager.lat = value.latitude;
          _manager.lng = value.longitude;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          const SliverGap(16),

          // ── Titre de la section ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Où se trouve votre meuble ?',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          const SliverGap(4),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: VilleSelectorListtile(
                onSelect: (ville) {
                  if (ville != null) {
                    setState(() {
                      _manager.ville = ville.id;
                    });
                  }
                },
              ),
            ),
          ),

          const SliverGap(10),

          // ── Sélecteur de commune ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: CommuneSelectorListtile(
                onSelect: (commune) {
                  if (commune != null) {
                    setState(() {
                      _manager.commune = commune.id;
                    });
                  }
                },
              ),
            ),
          ),

          const SliverGap(16),

          // ── Sélection de la position GPS ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tileColor: _isAdresseValid
                    ? AppColors.scafold
                    : CupertinoColors.tertiarySystemFill,
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: FaIcon(FontAwesomeIcons.locationDot,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  _isAdresseValid
                      ? _manager.adresse!
                      : 'Position GPS de votre meuble',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(CupertinoIcons.chevron_right_circle_fill),
                onTap: _openLocationPicker,
              ),
            ),
          ),

          const SliverGap(8),

          // ── Texte d'aide ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: 
            
            SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: Markdown(
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
                selectable: true,
                data:
                    "Sélectionnez **Ma position actuelle** si vous êtes à l\'emplacement du meuble.",
              ),
            ),
          )


          ),

          // Espace en bas pour le scroll
          const SliverGap(100),
        ],
      ),

    );
  }
}
