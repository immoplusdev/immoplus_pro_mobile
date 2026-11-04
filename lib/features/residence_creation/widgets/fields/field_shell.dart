import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/field_heading.dart';

/// Présentation du libellé d'un champ.
enum FieldLabelStyle {
  /// Petit libellé au-dessus d'une saisie (nom, heure, ...).
  plain,

  /// Titre de section en gras, avec sous-titre (cartes, listes, médias).
  heading,
}

/// Habillage commun d'un champ : libellé, aide et message d'erreur.
class FieldShell extends StatelessWidget {
  const FieldShell({
    super.key,
    required this.child,
    this.label,
    this.helperText,
    this.errorText,
    this.labelStyle = FieldLabelStyle.heading,
    this.tag,
  });

  final Widget child;
  final String? label;
  final String? helperText;
  final String? errorText;
  final FieldLabelStyle labelStyle;

  /// Étiquette à côté du titre (ex. « Facultatif »).
  final String? tag;

  bool get _isHeading => labelStyle == FieldLabelStyle.heading && label != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CreationStyle.fieldSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isHeading) ...[
            FieldHeading(title: label!, subtitle: helperText, tag: tag),
            AppSpacing.gap12,
          ] else if (label != null) ...[
            Text(
              label!,
              style: AppTypography.bodyMediumMedium
                  .copyWith(color: AppColors.gray950),
            ),
            AppSpacing.gap8,
          ],
          child,
          if (errorText != null) ...[
            AppSpacing.gap4,
            Text(
              errorText!,
              style: AppTypography.caption.copyWith(color: AppColors.red500),
            ),
          ] else if (!_isHeading && helperText != null) ...[
            AppSpacing.gap4,
            Text(
              helperText!,
              style: AppTypography.caption.copyWith(color: AppColors.gray400),
            ),
          ],
        ],
      ),
    );
  }
}

InputDecoration creationInputDecoration({
  String? hint,
  Widget? suffix,
  Widget? prefix,
  bool hasError = false,
}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
        borderSide: BorderSide(color: color),
      );

  return InputDecoration(
    hintText: hint,
    hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
    counterText: '',
    suffixIcon: suffix == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Center(widthFactor: 1, child: suffix),
          ),
    prefixIcon: prefix,
    filled: true,
    fillColor: CreationStyle.inputFill,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
    border: border(CreationStyle.border),
    enabledBorder: border(hasError ? AppColors.red500 : CreationStyle.border),
    focusedBorder: border(hasError ? AppColors.red500 : AppColors.primary),
  );
}
