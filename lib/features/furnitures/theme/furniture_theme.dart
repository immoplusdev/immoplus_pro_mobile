import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

/// Identité visuelle de la section "Meubles".
///
/// Centralise tous les styles réutilisables (boutons, champs, badges)
/// basés sur [AppColors.furnitureViolet] (#4227DE).
///
/// Usage :
/// ```dart
/// ElevatedButton(
///   style: FurnitureTheme.primaryButtonStyle,
///   onPressed: () {},
///   child: Text('Suivant'),
/// )
/// ```
class FurnitureTheme {
  FurnitureTheme._(); // empêche l'instanciation

  // ──────────────────────────────────────────────
  // COULEURS
  // ──────────────────────────────────────────────

  static const Color accent = AppColors.furnitureViolet;
  static const Color accentLight = AppColors.furnitureVioletLight;

  static const Color _statusActiveColor = Color(0xFF2ECC71);
  static const Color _statusActiveBg = Color(0x1A2ECC71);
  static const Color _statusInactiveColor = Color(0xFFE67E22);
  static const Color _statusInactiveBg = Color(0x1AE67E22);
  static const Color _statusDeletedColor = Color(0xFFE74C3C);
  static const Color _statusDeletedBg = Color(0x1AE74C3C);

  // ──────────────────────────────────────────────
  // TYPOGRAPHIE
  // ──────────────────────────────────────────────

  /// Titre de section — semi-bold 18-20px
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  /// Label de champ — regular 14px
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  /// Texte de bouton — bold 16px
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// Prix affiché — bold 18px violet
  static TextStyle priceText = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.furnitureViolet,
  );

  // ──────────────────────────────────────────────
  // BOUTONS
  // ──────────────────────────────────────────────

  /// Style du bouton principal (Suivant, Créer Meuble, etc.)
  ///
  /// - Fond violet #4227DE, texte blanc, border radius 8
  /// - Pas de shadow (elevation 0)
  /// - Hauteur minimale 50px
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accent,
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.grey.shade300,
    disabledForegroundColor: Colors.grey.shade500,
    elevation: 0,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: buttonText,
  );

  /// Style du bouton secondaire (Précédent, Annuler)
  ///
  /// - Fond transparent, bordure violet, texte violet
  /// - Pas de shadow
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: accent,
    side: const BorderSide(color: AppColors.furnitureViolet, width: 1.2),
    elevation: 0,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: buttonText.copyWith(color: accent),
  );

  /// Style du bouton destructif (Supprimer)
  static final ButtonStyle destructiveButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: buttonText,
  );

  // ──────────────────────────────────────────────
  // CHAMPS DE FORMULAIRE (InputDecoration)
  // ──────────────────────────────────────────────

  /// InputDecoration de base pour les TextFormField de la section Meubles.
  ///
  /// - Bordure outline gris clair, border radius 8
  /// - Focus border violet #4227DE
  /// - Fond blanc
  /// - Pas de filled background pour garder le style épuré
  static InputDecoration inputDecoration({
    required String hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.furnitureViolet,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.furnitureViolet, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
      ),
    );
  }

  /// InputDecorationTheme global pour un [Theme] wrapper si nécessaire.
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.furnitureViolet, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.furnitureViolet,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
        ),
      );

  // ──────────────────────────────────────────────
  // BADGES DE STATUT
  // ──────────────────────────────────────────────

  /// Retourne un Widget badge pour le statut du meuble.
  ///
  /// - `active`   → pastille verte
  /// - `inactive` → pastille orange
  /// - `deleted`  → pastille rouge
  static Widget statusBadge(String status) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(
              color: config.foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne la configuration de couleur/texte pour un statut donné.
  static _StatusConfig _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return _StatusConfig(
          label: 'Active',
          foregroundColor: _statusActiveColor,
          backgroundColor: _statusActiveBg,
        );
      case 'inactive':
        return _StatusConfig(
          label: 'Inactive',
          foregroundColor: _statusInactiveColor,
          backgroundColor: _statusInactiveBg,
        );
      case 'deleted':
        return _StatusConfig(
          label: 'Supprimé',
          foregroundColor: _statusDeletedColor,
          backgroundColor: _statusDeletedBg,
        );
      default:
        return _StatusConfig(
          label: status,
          foregroundColor: Colors.grey,
          backgroundColor: Colors.grey.shade100,
        );
    }
  }

  // ──────────────────────────────────────────────
  // CARDS / CONTAINERS
  // ──────────────────────────────────────────────

  /// Décoration standard pour les cards de section (pas de shadow, fond blanc).
  static BoxDecoration get sectionCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      );

  /// Padding standard à l'intérieur des cards de section.
  static const EdgeInsets sectionCardPadding = EdgeInsets.all(16);

  /// Margin entre les cards de section.
  static const EdgeInsets sectionCardMargin = EdgeInsets.only(bottom: 12);

  // ──────────────────────────────────────────────
  // STEPPER
  // ──────────────────────────────────────────────

  /// Couleur du cercle actif dans le stepper.
  static const Color stepperActiveColor = AppColors.furnitureViolet;

  /// Couleur du cercle inactif.
  static Color stepperInactiveColor = Colors.grey.shade300;

  /// Couleur de la ligne de connexion complétée.
  static const Color stepperLineActiveColor = AppColors.furnitureViolet;

  /// Couleur de la ligne de connexion inactive.
  static Color stepperLineInactiveColor = Colors.grey.shade300;

  // ──────────────────────────────────────────────
  // LOADER
  // ──────────────────────────────────────────────

  /// CircularProgressIndicator aux couleurs du module Meubles.
  static Widget loader({double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.furnitureViolet),
      ),
    );
  }

  /// Loader avec texte informatif en dessous.
  static Widget loaderWithText(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loader(),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Configuration interne pour les badges de statut.
class _StatusConfig {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _StatusConfig({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });
}
