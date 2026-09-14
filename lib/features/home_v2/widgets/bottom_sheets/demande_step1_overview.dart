import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class DemandeStep1Overview extends StatelessWidget {
  final AlertMarketplaceItem item;
  final VoidCallback onSeeCompatibleProperties;

  const DemandeStep1Overview({
    super.key,
    required this.item,
    required this.onSeeCompatibleProperties,
  });

  @override
  Widget build(BuildContext context) {
    final criteria = item.criteria;
    final extras = criteria?.extras ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Badge "NOUVELLE DEMANDE" + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'NOUVELLE DEMANDE',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'Publiée il y a 2 h',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Gap(20),

          // 2. Le besoin du client
          const Text(
            'Le besoin du client',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Gap(8),
          Text(
            item.descriptionClient ?? '-',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const Gap(20),

          // 3. Bloc informations encadré (Localisation & Budget)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOCALISATION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const Gap(4),
                Text(
                  criteria?.location ?? '-',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
                Text(
                  'BUDGET MENSUEL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const Gap(4),
                Text(
                  criteria != null ? criteria.formattedBudget : '-',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          // 4. Critères recherchés
          if (extras.isNotEmpty) ...[
            const Text(
              'Critères recherchés',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  extras.map((critere) => _buildCritereChip(critere)).toList(),
            ),
            const Gap(24),
          ],

          // 5. Card information bleue "X biens compatibles"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.matchCount} biens compatibles',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(4),
                Text(
                  'Sélectionnez celui qui répond le mieux au besoin.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),

          // 6. Bouton CTA
          CustomButtom(
            text: 'Voir mes biens compatibles',
            borderRadius: BorderRadius.circular(26),
            onClick: onSeeCompatibleProperties,
          ),
        ],
      ),
    );
  }

  Widget _buildCritereChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}
