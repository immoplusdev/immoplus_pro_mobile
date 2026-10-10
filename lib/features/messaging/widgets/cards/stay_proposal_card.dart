import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';
import 'package:intl/intl.dart';

class StayProposalCard extends StatelessWidget {
  const StayProposalCard({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final payload = message.payload ?? {};
    final checkIn = payload['checkIn']?.toString() ?? '—';
    final checkOut = payload['checkOut']?.toString() ?? '—';
    final guests = payload['guests']?.toString() ?? '1';
    final amount = _formatAmount(payload['amount'] ?? payload['totalAmount']);
    final isExpired = message.isExpired || payload['expired'] == true;

    final isSelf = message.isFromPro;

    return Align(
      alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpired ? Colors.grey.shade300 : AppColors.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
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
                Icon(
                  Iconsax.house_2,
                  color: isExpired ? Colors.grey : AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Proposition de séjour',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isExpired ? Colors.grey.shade600 : const Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? Colors.grey.shade200
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isExpired ? 'Expirée (48h)' : 'Valide 48h',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isExpired ? Colors.grey.shade700 : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dates',
                        style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$checkIn → $checkOut',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Voyageurs',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$guests pers.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (amount != null) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Montant calculé :',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isExpired ? Colors.grey : const Color(0xFF0F6E56),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// The API can return a scalar amount or a money object such as
  static String? _formatAmount(Object? rawAmount) {
    if (rawAmount == null) return null;

    Object? value = rawAmount;
    var currency = 'FCFA';
    if (rawAmount is Map) {
      value = rawAmount['value'] ?? rawAmount['amount'] ?? rawAmount['total'];
      final rawCurrency = rawAmount['currency']?.toString().trim();
      if (rawCurrency != null && rawCurrency.isNotEmpty && rawCurrency != 'XOF') {
        currency = rawCurrency;
      }
    }

    if (value == null) return null;
    final numericValue = value is num ? value : num.tryParse(value.toString());
    if (numericValue == null) return null;

    return '${NumberFormat('#,##0.##', 'fr_FR').format(numericValue)} $currency';
  }
}
