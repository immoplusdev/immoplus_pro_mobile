import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/demandes/demande_proposal_cubit.dart';
import 'package:immoplus_pro/cubits/demandes/demande_proposal_state.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/features/estates/estates_page_v2.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class DemandeStep2ChooseProperty extends StatelessWidget {
  final AlertMarketplaceItem item;
  final VoidCallback onBack;

  const DemandeStep2ChooseProperty({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemandeProposalCubit, DemandeProposalState>(
      builder: (context, state) {
        final cubit = context.read<DemandeProposalCubit>();

        final List<AlertProMatchItem> matches = switch (state) {
          DemandeProposalMatchesLoaded(matches: final m) => m,
          DemandeProposalSubmitting(selectedMatch: final s) => [s],
          _ => const [],
        };

        final AlertProMatchItem? selectedMatch = switch (state) {
          DemandeProposalMatchesLoaded(selectedMatch: final s) => s,
          DemandeProposalSubmitting(selectedMatch: final s) => s,
          _ => null,
        };

        final bool isLoading = state is DemandeProposalLoadingMatches;
        final bool isSubmitting = state is DemandeProposalSubmitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header avec flèche retour + Titres
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.black87,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choisir un bien',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${matches.length} bien${matches.length > 1 ? 's' : ''} correspondent au besoin.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),

              // 2. Info Card "Le score indique la proximité avec la demande"
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Le score indique la proximité avec la demande.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Gap(16),

              // 3. Bouton "+ Ajouter un bien"
              InkWell(
                onTap: () {
                  context.pushNamed(EstatesPageV2.name);
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const Gap(6),
                      Text(
                        'Ajouter un bien',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // 4. Liste des biens avec score et sélecteur
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              else ...[
                ...matches.map((match) {
                  final isSelected = selectedMatch?.id == match.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildMatchCard(
                      match,
                      isSelected,
                      () => cubit.selectMatch(match),
                    ),
                  );
                }),
              ],
              const Gap(20),

              // 5. Texte d'état sélectionné
              if (selectedMatch != null)
                Center(
                  child: Text(
                    '${selectedMatch.title} sélectionné',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const Gap(12),

              // 6. Bouton d'action "Continuer"
              CustomButtom(
                text: 'Continuer',
                isLoading: isSubmitting,
                clickable: selectedMatch != null && !isSubmitting,
                borderRadius: BorderRadius.circular(26),
                onClick: () {
                  cubit.submitProposal();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatchCard(
    AlertProMatchItem match,
    bool isSelected,
    VoidCallback onSelect,
  ) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Miniature du bien
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF1F5F9),
                child: match.image != null && match.image!.isNotEmpty
                    ? Image.network(
                        match.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackImage(),
                      )
                    : _buildFallbackImage(),
              ),
            ),
            const Gap(12),

            // Détails du bien
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    match.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    match.formattedPrice.isNotEmpty
                        ? match.formattedPrice
                        : '-',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Gap(6),
                  // Badge score
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${match.matchScore}% compatible',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bouton Radio avec Check
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 2),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Icon(
          Iconsax.building_3,
          color: Colors.grey.shade400,
          size: 32,
        ),
      ),
    );
  }
}
