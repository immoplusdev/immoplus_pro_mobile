import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';

/// Titre de section d'un champ : titre en gras, étiquette facultative
/// (« Facultatif ») et sous-titre grisé.
class FieldHeading extends StatelessWidget {
  const FieldHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.tag,
  });

  final String title;
  final String? subtitle;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: [
              if (tag != null)
                TextSpan(
                  text: '  ·  $tag',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.gray400,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          style: AppTypography.h4.copyWith(color: AppColors.gray950),
        ),
        if (subtitle != null) ...[
          AppSpacing.gap4,
          Text(
            subtitle!,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
          ),
        ],
      ],
    );
  }
}
