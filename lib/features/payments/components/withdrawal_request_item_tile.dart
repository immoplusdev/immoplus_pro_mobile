import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/utils/payments_utils.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';
import 'package:immoplus_pro/utils/utils.dart';

class WithdrawalRequestItemTile extends StatelessWidget {
  final WithdrawalRequestModel item;

  const WithdrawalRequestItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getColorStatus(status: item.status.toString());
    final statusLabel = getPaymentStatusName(status: item.status.toString());

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
            // Left circular icon with dynamic logo & dynamic getIconStatus from original design
            CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withOpacity(0.12),
              foregroundImage: (item.operator.toString().isNotEmpty)
                  ? NetworkImage(
                      OrderPaymentController.getLogoURL(
                          item.operator.toString()),
                    )
                  : null,
              child: getIconStatus(status: item.status.toString()),
            ),

            const Gap(12),

            // Title & Subtitle column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Retrait par ${item.operator}",
                    maxLines: 1,
                    style: GoogleFonts.sen(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    Utils.formatDate(dateTime: item.updatedAt!),
                    style: GoogleFonts.sen(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const Gap(2),
                  AutoSizeText(
                    PhoneNumberHandler.formatPhoneNumber(
                        item.phoneNumber.toString()),
                    style: GoogleFonts.sen(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(12),

            // Trailing column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- ${CurrencyFormatter.format(item.amount!.toInt().toString())} F",
                  style: GoogleFonts.sen(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Gap(6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.sen(
                      // color: statusLabel,
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
