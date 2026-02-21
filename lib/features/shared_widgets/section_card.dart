import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Carte de section réutilisable pour les pages de détail (titre + icône + contenu).
///
/// Usage :
/// ```dart
/// SectionCard(
///   title: 'Description',
///   icon: Icons.description,
///   child: Text('...'),
/// )
/// ```
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.iconColor,
    this.decoration,
    this.padding,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Color? iconColor;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  static BoxDecoration defaultDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  static const EdgeInsets defaultPadding = EdgeInsets.all(16);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: decoration ?? defaultDecoration,
        padding: padding ?? defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor ?? Colors.grey.shade700),
                const Gap(8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Gap(12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Séparateur horizontal avec indent, pour séparer les sections.
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.indent = 16,
    this.endIndent = 16,
    this.color,
    this.thickness = 0.5,
    this.verticalPadding = 8,
  });

  final double indent;
  final double endIndent;
  final Color? color;
  final double thickness;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Divider(
        height: 1,
        thickness: thickness,
        color: color ?? Colors.grey.shade200,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
