import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/conversation_type_count.dart';

/// Rangée d'onglets "pills" : Toutes / Réservations / Visites / Relais / Support.
class InboxTabs extends StatelessWidget {
  const InboxTabs({
    super.key,
    required this.activeType,
    required this.counts,
    required this.onSelect,
  });

  /// `null` = onglet "Toutes" actif.
  final ConversationType? activeType;
  final List<ConversationTypeCount> counts;
  final ValueChanged<ConversationType?> onSelect;

  int _unreadFor(ConversationType? type) {
    if (type == null) {
      return counts.fold<int>(0, (t, c) => t + c.unread);
    }
    return counts
        .firstWhere((c) => c.typeEnum == type,
            orElse: () => const ConversationTypeCount(type: ''))
        .unread;
  }

  @override
  Widget build(BuildContext context) {
    final items = <(ConversationType?, String, IconData)>[
      (null, 'Toutes', Iconsax.messages),
      (ConversationType.reservation, 'Réservations', Iconsax.calendar),
      (ConversationType.visite, 'Visites', Iconsax.eye),
      (ConversationType.relais, 'Relais', Iconsax.repeat),
      (ConversationType.support, 'Support', Iconsax.headphone),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (type, label, icon) = items[index];
          final isSelected = type == activeType;
          final unread = _unreadFor(type);
          return GestureDetector(
            onTap: () => onSelect(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                    ),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unread > 99 ? '99+' : '$unread',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

