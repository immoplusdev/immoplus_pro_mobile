import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';

/// Affichage des métadonnées d'un meuble (catégorie, type, état, couleurs, etc.).
///
/// Les couleurs sont affichées en pastilles superposées ; les autres champs en texte.
class FurnitureMetadataChips extends StatelessWidget {
  const FurnitureMetadataChips({super.key, required this.furniture});

  final FurnitureModel furniture;

  static Color? _parseApiColor(String rawColor) {
    var hex = rawColor.trim().toUpperCase().replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) return null;
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return null;
    return Color(value);
  }

  static List<Color> _resolveAvailableColors(FurnitureModel furniture) {
    final raw = furniture.metadata?['colors'];
    if (raw == null) return const <Color>[];
    if (raw is! List) return const <Color>[];
    return raw
        .map((e) => _parseApiColor(e.toString()))
        .whereType<Color>()
        .toList();
  }

  static String _formatMetadataValue(String key, dynamic value) {
    if (key == 'Type' || key == 'type') {
      final type = value.toString();
      return type
          .split('-')
          .where((s) => s.isNotEmpty)
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' ');
    }
    if (key == 'Catégorie' || key == 'category') {
      switch (value.toString()) {
        case 'mobilier-interieur':
          return 'Mobilier intérieur';
        case 'mobilier-exterieur':
          return 'Mobilier extérieur';
        default:
          return value.toString();
      }
    }
    if (value is List) return value.join(', ');
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = Map<String, dynamic>.from(furniture.metadata ?? {});
    metadata.remove('etat');
    metadata.remove('type');
    metadata.remove('category');

    final items = <MapEntry<String, dynamic>>[
      if (furniture.category?.isNotEmpty ?? false)
        MapEntry('Catégorie', furniture.category),
      if (furniture.type?.isNotEmpty ?? false) MapEntry('Type', furniture.type),
      if (furniture.etat?.isNotEmpty ?? false) MapEntry('État', furniture.etat),
      ...metadata.entries,
    ].where((e) => e.value != null && e.value.toString().isNotEmpty).toList();

    if (items.isEmpty) return const SizedBox.shrink();
    final maxChipWidth = MediaQuery.sizeOf(context).width - 64;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((entry) {
        final isColorsKey = entry.key == 'colors' || entry.key == 'Couleurs';
        final availableColors =
            isColorsKey ? _resolveAvailableColors(furniture) : <Color>[];

        if (isColorsKey && availableColors.isNotEmpty) {
          return Container(
            constraints: BoxConstraints(maxWidth: maxChipWidth),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.furnitureVioletLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Couleurs : ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: availableColors.asMap().entries.map((e) {
                    final index = e.key;
                    final color = e.value;
                    return Transform.translate(
                      offset: Offset(index * -8, 0),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        if (isColorsKey && availableColors.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          constraints: BoxConstraints(maxWidth: maxChipWidth),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.furnitureVioletLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${entry.key} : ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                TextSpan(
                  text: _formatMetadataValue(entry.key, entry.value),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
