import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/thousands_formatter.dart';
import 'package:immoplus_pro/utils/utils.dart';

/// Utilitaires de formatage d'une [ResidenceModel] pour le parcours Boost / partage.
abstract final class BoostResidenceFormatter {
  static String formatPropertyType(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1).toLowerCase()}';
  }

  static int bedroomsCount(ResidenceModel residence) {
    var total = 0;
    for (final piece in residence.pieces) {
      if (piece.nom.toLowerCase().contains('chambre')) {
        total += piece.nombre;
      }
    }
    return total;
  }

  static String formatLocation(ResidenceModel residence) {
    final commune = residence.commune.trim();
    final ville = residence.ville.trim();
    final adresse = residence.adresse.trim();

    if (commune.isNotEmpty &&
        ville.isNotEmpty &&
        commune.toLowerCase() != ville.toLowerCase()) {
      return '$commune, $ville';
    }
    if (commune.isNotEmpty) return commune;
    if (ville.isNotEmpty) return ville;
    return adresse;
  }

  static String formatSubtitle(ResidenceModel residence) {
    final type = formatPropertyType(residence.typeResidence);
    final bedrooms = bedroomsCount(residence);
    final location = formatLocation(residence);

    final parts = <String>[
      if (type.isNotEmpty) type,
      if (bedrooms > 0) '$bedrooms chambre(s)',
      if (location.isNotEmpty) location,
    ];
    return parts.join(' · ');
  }

  static String formatNightlyPrice(int price) {
    return '${ThousandsFormatter.format(price, separator: ' ')} FCFA/nuit';
  }

  static String buildDefaultInvitationMessage(
    ResidenceModel residence,
    String shareUrl,
  ) {
    final name =
        residence.nom.trim().isNotEmpty ? residence.nom.trim() : 'cette résidence';
    final typeLower = residence.typeResidence.trim().toLowerCase();
    final bedrooms = bedroomsCount(residence);
    final commune = residence.commune.trim();
    final ville = residence.ville.trim();
    final adresse = residence.adresse.trim();

    final String typePhrase;
    if (typeLower.isEmpty) {
      typePhrase = 'un logement';
    } else if (_isFeminineType(typeLower)) {
      typePhrase = 'une $typeLower';
    } else {
      typePhrase = 'un $typeLower';
    }

    final buffer = StringBuffer('Bonjour ! Découvrez $name, $typePhrase');

    if (bedrooms > 0) {
      buffer.write(' $bedrooms chambre${bedrooms > 1 ? 's' : ''}');
    }

    if (commune.isNotEmpty &&
        ville.isNotEmpty &&
        commune.toLowerCase() != ville.toLowerCase()) {
      buffer.write(' à $commune ($ville)');
    } else if (commune.isNotEmpty) {
      buffer.write(' à $commune');
    } else if (ville.isNotEmpty) {
      buffer.write(' à $ville');
    } else if (adresse.isNotEmpty) {
      buffer.write(' à $adresse');
    }

    final formattedPrice =
        ThousandsFormatter.format(residence.prixReservation, separator: ' ');
    buffer.write(
      ' à $formattedPrice FCFA la nuit. '
      'Réservez en quelques clics sur Immo Plus : $shareUrl',
    );

    return buffer.toString();
  }

  static String? resolveImageUrl(ResidenceModel residence) {
    String? rawId;
    if (residence.images.isNotEmpty &&
        residence.images.first.trim().isNotEmpty) {
      rawId = residence.images.first.trim();
    } else if (residence.miniature != null &&
        residence.miniature!.trim().isNotEmpty) {
      rawId = residence.miniature!.trim();
    }

    if (rawId == null || rawId.isEmpty) return null;
    if (rawId.startsWith('http://') || rawId.startsWith('https://')) {
      return rawId;
    }
    return Utils.getImagePath(id: rawId);
  }

  static bool _isFeminineType(String typeLower) {
    return typeLower.startsWith('villa') ||
        typeLower.startsWith('maison') ||
        typeLower.startsWith('résidence') ||
        typeLower.startsWith('residence') ||
        typeLower.startsWith('chambre') ||
        typeLower.startsWith('suite');
  }
}
