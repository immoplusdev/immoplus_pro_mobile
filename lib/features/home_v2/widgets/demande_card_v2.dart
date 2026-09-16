import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/enums/alert_enums.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/features/home_v2/widgets/bottom_sheets/demande_detail_bottom_sheet.dart';

class DemandeCardV2 extends StatelessWidget {
  final AlertMarketplaceItem item;
  final VoidCallback? onRefresh;

  const DemandeCardV2({
    super.key,
    required this.item,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final criteria = item.criteria;
    final hasAcceptedProposal = item.proposals.any(
      (p) => p.status == AlertProposalStatus.accepted,
    );

    // Détermination de la localisation et du type de transaction
    final String location = (criteria?.location != null &&
            criteria!.location!.isNotEmpty &&
            criteria.location != '<UNKNOWN>')
        ? criteria.location!
        : '-';
    final String transactionType = (criteria?.transactionType != null &&
            criteria!.transactionType!.isNotEmpty)
        ? (criteria.transactionType![0].toUpperCase() +
            criteria.transactionType!.substring(1).toLowerCase())
        : '-';
    final subtitle = '$location · $transactionType';

    // Budget formaté
    final budgetFormatted = criteria != null ? criteria.formattedBudget : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () async {
          await DemandeDetailBottomSheet.show(context, item);
          onRefresh?.call();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne 1 : Titre (avec point bleu si nouveau) + Badge de statut
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dot bleu indicateur de nouveauté
                  if (item.isNew && !hasAcceptedProposal) ...[
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  // Titre
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const Gap(8),
                  // Badge à droite (X biens compatibles ou ACCEPTÉE)
                  _buildStatusBadge(hasAcceptedProposal),
                ],
              ),
              const Gap(6),

              // Ligne 2 : Sous-titre ou message client
              if (hasAcceptedProposal && item.descriptionClient != null) ...[
                Text(
                  item.descriptionClient!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ] else ...[
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                // Ligne 3 : Budget
                Text(
                  budgetFormatted,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool hasAcceptedProposal) {
    if (hasAcceptedProposal) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'ACCEPTÉE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF059669),
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    final count = item.matchCount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count bien${count > 1 ? 's' : ''} compatible${count > 1 ? 's' : ''}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
