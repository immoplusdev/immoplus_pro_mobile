import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_model.dart';
import 'package:immoplus_pro/features/payments/utils/payments_utils.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/utils.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel item;

  const TransactionItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final titleText =
        item.source.toString() != 'null' ? getTransactionTitle(item) : '';
    final idText = (item.sourceId != null &&
            item.sourceId.toString() != 'null' &&
            item.sourceId.toString().trim().isNotEmpty)
        ? "id: ${item.sourceId}"
        : '';
    final amountColor = getColorStatus(status: item.type.toString());
    final statusColor = const Color(0xFF059669); // Green "Payée"

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left circular icon with fallback logic from original design
            CircleAvatar(
              radius: 24,
              backgroundColor: amountColor.withOpacity(0.12),
              foregroundImage: (item.operator.toString().isNotEmpty)
                  ? NetworkImage(
                      OrderPaymentController.getLogoURL(
                          item.operator.toString()),
                    )
                  : null,
              child: getIconStatus(status: item.type.toString()),
            ),

            const Gap(12),

            // Title & Subtitle column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titleText.isNotEmpty)
                    AutoSizeText(
                      titleText,
                      maxLines: 1,
                      style: GoogleFonts.sen(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  const Gap(4),
                  Text(
                    Utils.shortformatDateTime(dateTime: item.updatedAt!),
                    style: GoogleFonts.sen(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (idText.isNotEmpty) ...[
                    const Gap(2),
                    Text(
                      idText,
                      style: GoogleFonts.sen(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Gap(12),

            // Trailing column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${CurrencyFormatter.format(item.amount!.toInt().toString())} ${item.currency}",
                  style: GoogleFonts.sen(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const Gap(6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Payée",
                    style: GoogleFonts.sen(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
