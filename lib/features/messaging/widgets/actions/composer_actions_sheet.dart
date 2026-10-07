import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

enum ComposerActionType {
  proposeStay,
  requestWithdrawal,
  openSupport,
}

/// Sheet d'actions modernes affichée lors du tap sur le bouton "+" du composer.
class ComposerActionsSheet extends StatelessWidget {
  const ComposerActionsSheet({
    super.key,
    required this.onActionSelected,
    required this.actions,
  });

  final ValueChanged<ComposerActionType> onActionSelected;
  final List<ComposerActionType> actions;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ComposerActionType> onActionSelected,
    required List<ComposerActionType> actions,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (sheetContext) => ComposerActionsSheet(
        onActionSelected: (action) {
          Navigator.of(sheetContext).pop();
          onActionSelected(action);
        },
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Actions du fil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final action in actions)
              switch (action) {
                ComposerActionType.proposeStay => _ActionTile(
                    icon: Iconsax.calendar_1,
                    iconColor: const Color(0xFF2563EB),
                    backgroundColor: const Color(0xFFEFF6FF),
                    title: 'Proposer un séjour',
                    subtitle:
                        'Choisir les dates; le montant sera calculé automatiquement',
                    onTap: () => onActionSelected(action),
                  ),
                ComposerActionType.requestWithdrawal => _ActionTile(
                    icon: Iconsax.card_send,
                    iconColor: const Color(0xFF059669),
                    backgroundColor: const Color(0xFFECFDF5),
                    title: 'Demander un retrait',
                    subtitle:
                        'Ouvrir le parcours de retrait de cette réservation',
                    onTap: () => onActionSelected(action),
                  ),
                ComposerActionType.openSupport => _ActionTile(
                    icon: Iconsax.headphone,
                    iconColor: const Color(0xFF176B66),
                    backgroundColor: const Color(0xFFEAF5F2),
                    title: 'Support ImmoPlus',
                    subtitle: 'Ouvrir ou reprendre votre fil avec le support',
                    onTap: () => onActionSelected(action),
                  ),
              },
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
