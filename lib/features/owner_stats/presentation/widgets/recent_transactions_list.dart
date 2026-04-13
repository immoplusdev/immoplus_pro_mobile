import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionDto> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StatsColors.brand.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions récentes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: StatsColors.textPrimary,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // TODO: Navigate to /owner/transactions
              //   },
              //   child: const Text(
              //     'Voir tout ›',
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //       color: StatsColors.brand,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(transactions.length, (index) {
            final tx = transactions[index];
            final isIn = tx.direction == 'in';
            final formattedDate = _formatDate(tx.date);

            return Column(
              children: [
                if (index > 0)
                  const Divider(height: 1, thickness: 0.5),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: index == 0 ? 0 : 10,
                  ).copyWith(bottom: index == 0 ? 10 : 10),
                  child: Row(
                    children: [
                      // Direction icon
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isIn
                              ? StatsColors.successBg
                              : StatsColors.warningBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isIn
                              ? CupertinoIcons.arrow_down
                              : CupertinoIcons.arrow_up,
                          size: 16,
                          color: isIn
                              ? StatsColors.success
                              : StatsColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Type + property
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.type,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: StatsColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tx.propertyName} \u00B7 $formattedDate',
                              style: const TextStyle(
                                fontSize: 11,
                                color: StatsColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Amount
                      Text(
                        '${isIn ? '+' : '-'}${numberFormat.format(tx.amount)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isIn
                              ? StatsColors.success
                              : StatsColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
