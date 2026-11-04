import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';

/// Ouvre le sélecteur existant (position actuelle ou carte) et retourne
/// l'adresse choisie, ou `null` si l'utilisateur ferme sans choisir.
Future<PlaceSelection?> pickLocationOnMap(BuildContext context) async {
  final picked = await showModalBottomSheet<Object>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    // Le glissement déplacerait la carte au lieu de fermer la feuille.
    enableDrag: false,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) => const FractionallySizedBox(
      heightFactor: 0.9,
      child: LocationPage(),
    ),
  );

  if (picked is! Address ||
      picked.latitude == null ||
      picked.longitude == null) {
    return null;
  }
  final latitude = picked.latitude!;
  final longitude = picked.longitude!;
  final description = picked.description?.trim() ?? '';

  return PlaceSelection(
    // Sans libellé, on garde au moins les coordonnées comme adresse.
    address: description.isEmpty
        ? '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}'
        : description,
    position: GeoPoint(latitude: latitude, longitude: longitude),
  );
}
