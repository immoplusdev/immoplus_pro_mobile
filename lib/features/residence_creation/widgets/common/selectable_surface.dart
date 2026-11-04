import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

/// Surface cliquable qui prend le style « sélectionné » de la maquette
/// (bordure et fond bleus). Sert de base aux cartes, chips et tuiles.
class SelectableSurface extends StatelessWidget {
  const SelectableSurface({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.radius = CreationStyle.tileRadius,
    this.padding = AppSpacing.edgeAll12,
    this.alignment,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? CreationStyle.selectedFill : Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: selected
                  ? CreationStyle.selectedBorder
                  : CreationStyle.border,
            ),
          ),
          child: alignment == null
              ? child
              : Align(alignment: alignment!, child: child),
        ),
      ),
    );
  }
}
