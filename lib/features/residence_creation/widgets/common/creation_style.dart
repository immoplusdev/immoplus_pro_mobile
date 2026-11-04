import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';

/// Valeurs visuelles propres au formulaire de création (maquette Figma).
abstract class CreationStyle {
  static const double fieldRadius = AppRadii.r12;
  static const double tileRadius = AppRadii.r16;
  static const double pillRadius = AppRadii.rFull;

  /// Espace vertical entre deux champs.
  static const double fieldSpacing = AppSpacing.xl;

  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.md);

  static Color get inputFill => AppColors.gray100.withValues(alpha: 0.5);
  static Color get border => AppColors.gray200;
  static Color get selectedFill => AppColors.blue40;
  static Color get selectedBorder => AppColors.primary;
  static Color get mutedText => AppColors.gray400;
}
