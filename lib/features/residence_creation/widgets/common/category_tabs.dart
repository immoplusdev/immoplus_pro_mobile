import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

/// Onglets de catégories défilant horizontalement. L'onglet actif est plein.
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
    required this.labels,
    required this.selectedKey,
    required this.onSelected,
  });

  /// Libellé de chaque onglet, indexé par la clé de sa catégorie.
  final Map<String, String> labels;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final entry = labels.entries.elementAt(index);
          final selected = entry.key == selectedKey;
          return GestureDetector(
            onTap: () => onSelected(entry.key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(CreationStyle.pillRadius),
                border: Border.all(
                  color: selected ? AppColors.primary : CreationStyle.border,
                ),
              ),
              child: Text(
                entry.value,
                style: AppTypography.bodySmallMedium.copyWith(
                  color: selected ? Colors.white : AppColors.gray950,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
