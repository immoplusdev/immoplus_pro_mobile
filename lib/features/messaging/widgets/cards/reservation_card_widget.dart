import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';

class ReservationCardWidget extends StatelessWidget {
  const ReservationCardWidget({
    super.key,
    required this.message,
    required this.onActionTap,
    required this.isReadOnly,
  });

  final MessageModel message;
  final Function(String actionId, Map<String, dynamic> target) onActionTap;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final payload = message.payload ?? {};
    final status = payload['status']?.toString() ?? 'pending';
    final checkIn = payload['checkIn']?.toString() ?? '—';
    final checkOut = payload['checkOut']?.toString() ?? '—';
    final netAmount =
        payload['netAmount']?.toString() ?? payload['netToReceive']?.toString();
    final dueAt = payload['dueAt']?.toString();
    final actions = message.actions ?? [];

    Color statusColor;
    String statusText;
    switch (status) {
      case 'confirmed':
      case 'accepted':
        statusColor = const Color(0xFF0F6E56);
        statusText = 'Confirmée';
        break;
      case 'rejected':
      case 'cancelled':
        statusColor = AppColors.redFF0000;
        statusText = 'Refusée / Annulée';
        break;
      case 'pending':
      default:
        statusColor = const Color(0xFF854F0B);
        statusText = 'En attente de validation';
        break;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.receipt_item, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Fiche Réservation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DetailColumn(
                    label: 'Dates de séjour',
                    value: '$checkIn → $checkOut',
                    icon: Iconsax.calendar_1,
                  ),
                ),
              ],
            ),
            if (netAmount != null) ...[
              const SizedBox(height: 8),
              _DetailColumn(
                label: 'Net à percevoir (hors commission)',
                value: '$netAmount FCFA',
                icon: Iconsax.money_3,
                valueColor: const Color(0xFF0F6E56),
              ),
            ],
            if (dueAt != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Iconsax.clock, size: 12, color: Color(0xFF854F0B)),
                  const SizedBox(width: 4),
                  Text(
                    'Échéance : $dueAt',
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xFF854F0B)),
                  ),
                ],
              ),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: actions.map((act) {
                  final actionId = act['id']?.toString() ?? '';
                  final label =
                      act['label']?.toString() ?? _defaultActionLabel(actionId);
                  final isPrimary = actionId == 'accept_reservation' ||
                      actionId == 'scan_checkin_qr' ||
                      actionId == 'open_withdrawal';
                  final isDestructive = actionId == 'reject_reservation';

                  final icon = _actionIcon(actionId);
                  return SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: isReadOnly
                          ? null
                          : () => onActionTap(
                                actionId,
                                Map<String, dynamic>.from(act['target'] ?? {}),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive
                            ? AppColors.redFF0000.withValues(alpha: 0.1)
                            : (isPrimary
                                ? AppColors.primary
                                : Colors.grey.shade100),
                        foregroundColor: isDestructive
                            ? AppColors.redFF0000
                            : (isPrimary
                                ? Colors.white
                                : const Color(0xFF334155)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: icon != null
                          ? Icon(icon, size: 15)
                          : const SizedBox.shrink(),
                      label: Text(
                        label,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData? _actionIcon(String id) {
    switch (id) {
      case 'accept_reservation':
        return Iconsax.tick_circle;
      case 'reject_reservation':
        return Iconsax.close_circle;
      case 'scan_checkin_qr':
        return Iconsax.scan;
      case 'open_withdrawal':
        return Iconsax.money_send;
      case 'rate_guest':
        return Iconsax.star1;
      case 'complete_arrival_info':
        return Iconsax.document_text;
      case 'view_residence':
        return Iconsax.building;
      case 'view_reservation':
        return Iconsax.receipt_item;
      case 'message_client':
        return Iconsax.message;
      default:
        return null;
    }
  }

  String _defaultActionLabel(String id) {
    switch (id) {
      case 'accept_reservation':
        return 'Accepter';
      case 'reject_reservation':
        return 'Refuser';
      case 'scan_checkin_qr':
        return 'Scanner QR Présence';
      case 'open_withdrawal':
        return 'Demander le retrait';
      case 'rate_guest':
        return 'Évaluer le client';
      case 'complete_arrival_info':
        return 'Fiche d\'arrivée';
      case 'message_client':
        return 'Envoyer un message au client';
      default:
        return 'Action';
    }
  }
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF64748B)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
