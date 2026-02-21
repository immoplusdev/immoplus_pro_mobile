import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

/// Barre d'actions réutilisable pour les pages détail (meuble, résidence, bien immobilier).
///
/// Affiche 3 zones : Supprimer, Désactiver/Activer (avec loading possible), Modifier.
/// Utilisable avec [DetailActionBottomBarConfig] pour personnaliser les libellés et le style.
///
/// Exemple meuble :
/// ```dart
/// DetailActionBottomBar(
///   isInactive: furniture.status == FurnitureStatus.inactive,
///   isUpdatingStatus: _isUpdatingStatus,
///   onEdit: () => _onEdit(furniture),
///   onDelete: () => _onDelete(furniture),
///   onToggleAvailability: () => _onToggleAvailability(furniture),
///   config: DetailActionBottomBarConfig(editLabel: 'Modifier'),
/// )
/// ```
///
/// Exemple résidence :
/// ```dart
/// DetailActionBottomBar(
///   isInactive: !residence.residenceDisponible,
///   isUpdatingStatus: false,
///   onEdit: () => _onEditResidence(),
///   onDelete: () => _onDeleteResidence(),
///   onToggleAvailability: () => _onToggleResidenceAvailability(),
///   config: DetailActionBottomBarConfig(editLabel: 'Modifier la résidence'),
/// )
/// ```
class DetailActionBottomBar extends StatelessWidget {
  const DetailActionBottomBar({
    super.key,
    required this.isInactive,
    required this.isUpdatingStatus,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
    this.config = const DetailActionBottomBarConfig(),
  });

  /// Si true, l'élément est indisponible → le bouton central affiche "Activer".
  final bool isInactive;

  /// Si true, affiche un loading à la place du bouton Désactiver/Activer.
  final bool isUpdatingStatus;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  final DetailActionBottomBarConfig config;

  static const Color _green = Color(0xFF22C55E);
  static const Color _orange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 44;
    const double spacing = 12;
    const double horizontalPadding = 20;
    const double topPadding = 16;
    const double bottomPadding = 24;

    final primaryStyle = config.primaryButtonStyle ??
        ElevatedButton.styleFrom(
          backgroundColor: config.accentColor ?? AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: 0,
          minimumSize: const Size(0, buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  minimumSize: const Size(0, buttonHeight),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onDelete,
                child: const Icon(FontAwesomeIcons.trash, size: 16),
              ),
            ),
            const Gap(spacing),
            Expanded(
              flex: 1,
              child: isUpdatingStatus
                  ? Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: buttonHeight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isInactive ? _green : _orange,
                          side: BorderSide(
                            color: isInactive ? _green : _orange,
                          ),
                          minimumSize: const Size(0, buttonHeight),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onToggleAvailability,
                        child: Text(
                          isInactive
                              ? (config.activateLabel ?? 'Activer')
                              : (config.deactivateLabel ?? 'Désactiver'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
            const Gap(spacing),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton.icon(
                  style: primaryStyle,
                  onPressed: onEdit,
                  icon: Icon(
                    config.editIcon ?? FontAwesomeIcons.penToSquare,
                    size: 12,
                  ),
                  label: Text(
                    config.editLabel ?? 'Modifier',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Configuration optionnelle pour [DetailActionBottomBar].
class DetailActionBottomBarConfig {
  const DetailActionBottomBarConfig({
    this.editLabel,
    this.activateLabel,
    this.deactivateLabel,
    this.editIcon,
    this.accentColor,
    this.primaryButtonStyle,
  });

  /// Libellé du bouton Modifier (défaut : "Modifier").
  final String? editLabel;

  /// Libellé du bouton quand l'élément est inactif (défaut : "Activer").
  final String? activateLabel;

  /// Libellé du bouton quand l'élément est actif (défaut : "Désactiver").
  final String? deactivateLabel;

  /// Icône du bouton Modifier (défaut : penToSquare).
  final IconData? editIcon;

  /// Couleur d'accent du bouton Modifier (si [primaryButtonStyle] est null).
  final Color? accentColor;

  /// Style du bouton Modifier (optionnel).
  final ButtonStyle? primaryButtonStyle;
}
