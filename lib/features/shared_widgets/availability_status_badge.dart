import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

/// Badge réutilisable pour afficher un statut "Actif" (vert) ou "Indisponible" (orange).
///
/// Utilisable sur les pages détail meuble, bien, etc.
class AvailabilityStatusBadge extends StatelessWidget {
  const AvailabilityStatusBadge({
    super.key,
    required this.isInactive,
    this.activeLabel = 'Actif',
    this.inactiveLabel = 'Indisponible',
  });

  /// Si true, affiche le badge orange "Indisponible" ; sinon vert "Actif".
  final bool isInactive;

  final String activeLabel;
  final String inactiveLabel;

  static const Color _green = Color(0xFF22C55E);
  static const Color _orange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    if (isInactive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _orange.withValues(alpha: 0.12),
          border: Border.all(color: _orange, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.pause, size: 12, color: _orange),
            const Gap(6),
            Text(
              inactiveLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _orange,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _green.withValues(alpha: 0.12),
        border: Border.all(color: _green, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.check, size: 12, color: _green),
          const Gap(6),
          Text(
            activeLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }
}
