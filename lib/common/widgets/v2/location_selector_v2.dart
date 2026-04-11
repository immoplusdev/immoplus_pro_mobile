import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/data/models/configs/commune_model.dart';
import 'package:immoplus_pro/data/models/configs/ville_model.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_page.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_page.dart';
import 'package:immoplus_pro/common/widgets/v2/selector_tile_v2.dart';

class LocationSelectorV2 extends StatefulWidget {
  final String? currentVille;
  final String? currentCommune;
  final String? currentAdresse;
  final Function(VilleModel) onVilleSelected;
  final Function(CommuneModel) onCommuneSelected;
  final Function(Address) onPositionSelected;

  const LocationSelectorV2({
    super.key,
    this.currentVille,
    this.currentCommune,
    this.currentAdresse,
    required this.onVilleSelected,
    required this.onCommuneSelected,
    required this.onPositionSelected,
  });

  @override
  State<LocationSelectorV2> createState() => _LocationSelectorV2State();
}

class _LocationSelectorV2State extends State<LocationSelectorV2> {
  VilleModel? _localSelectedVille;
  CommuneModel? _localSelectedCommune;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        SelectorTileV2(
          icon: FontAwesomeIcons.city,
          title: "Sélectionner une ville",
          value: _localSelectedVille?.name ??
              ((widget.currentVille?.isNotEmpty ?? false)
                  ? widget.currentVille
                  : null),
          hasValue: _localSelectedVille != null ||
              (widget.currentVille?.isNotEmpty ?? false),
          onTap: () => _showVilleSelector(context),
        ),
        const Gap(10),
        SelectorTileV2(
          icon: FontAwesomeIcons.mountainCity,
          title: "Sélectionner une commune",
          value: _localSelectedCommune?.name ??
              ((widget.currentCommune?.isNotEmpty ?? false)
                  ? widget.currentCommune
                  : null),
          hasValue: _localSelectedCommune != null ||
              (widget.currentCommune?.isNotEmpty ?? false),
          onTap: () => _showCommuneSelector(context),
        ),
        const Gap(10),
        SelectorTileV2(
          icon: FontAwesomeIcons.locationDot,
          title: "Position du bien",
          value: widget.currentAdresse,
          hasValue: widget.currentAdresse?.isNotEmpty ?? false,
          onTap: () => _showPositionSelector(context),
        ),
      ],
    );
  }

  void _showVilleSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      showDragHandle: true,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.835,
        child: VilleSelectorPage(),
      ),
    ).then((value) {
      if (value is VilleModel) {
        setState(() => _localSelectedVille = value);
        widget.onVilleSelected(value);
      }
    });
  }

  void _showCommuneSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      showDragHandle: true,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.835,
        child: CommuneSelectorPage(),
      ),
    ).then((value) {
      if (value is CommuneModel) {
        setState(() => _localSelectedCommune = value);
        widget.onCommuneSelected(value);
      }
    });
  }

  void _showPositionSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LocationPage(),
      ),
    ).then((value) {
      if (value is Address) {
        widget.onPositionSelected(value);
      }
    });
  }
}
