import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class DemandeStep3Success extends StatelessWidget {
  final AlertProMatchItem proposedItem;
  final VoidCallback onGoHome;

  const DemandeStep3Success({
    super.key,
    required this.proposedItem,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Grand badge de succès vert avec check
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 38,
                color: Color(0xFF16A34A),
              ),
            ),
          ),
          const Gap(20),

          // 2. Titre et sous-titre
          const Text(
            'Proposition envoyée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const Gap(6),
          Text(
            'Le client a reçu votre proposition.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(28),

          // 3. Card 1 : BIEN PROPOSÉ (Bordure bleue)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIEN PROPOSÉ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const Gap(6),
                Text(
                  proposedItem.title.isNotEmpty ? proposedItem.title : '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Gap(2),
                Text(
                  proposedItem.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Gap(6),
                Text(
                  proposedItem.formattedPrice.isNotEmpty
                      ? proposedItem.formattedPrice
                      : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),

          // 4. Card 2 : PROCHAINE ÉTAPE (Gris très clair)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
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
                  'PROCHAINE ÉTAPE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const Gap(4),
                const Text(
                  'Retrouvez la réponse dans iMatch.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Gap(32),

          // 5. Bouton "Aller à l'accueil"
          CustomButtom(
            text: "Aller à l'accueil",
            borderRadius: BorderRadius.circular(26),
            onClick: onGoHome,
          ),
        ],
      ),
    );
  }
}
