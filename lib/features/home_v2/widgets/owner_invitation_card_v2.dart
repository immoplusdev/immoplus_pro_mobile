import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

/// Card d'invitation "reverse search" : un client cherche une résidence
/// correspondant à ses critères et l'une des nôtres est éligible. Même
/// gabarit visuel que [PendingReservationCardV2] pour rester cohérent avec
/// les cards de réservation — pas de nom/photo de résidence disponible côté
/// API pour ce flux, donc on affiche les critères de recherche du client à
/// la place.
class OwnerInvitationCardV2 extends StatelessWidget {
  final OwnerInvitationItem item;

  const OwnerInvitationCardV2({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatDate = DateFormat('d MMMM yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Icône (pas de photo résidence pour ce flux)
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Iconsax.search_normal_1,
                      color: AppColors.primary, size: 24),
                ),
                const Gap(14),

                // 2. Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              "Nouvelle demande de location",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7E6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              Utils.formatCurrency(item.montant),
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),

                      if (item.zonesLabel.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Iconsax.location,
                                size: 14, color: AppColors.primary),
                            const Gap(4),
                            Expanded(
                              child: Text(
                                item.zonesLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                      ],

                      Row(
                        children: [
                          Icon(Iconsax.calendar_1,
                              size: 14, color: AppColors.primary),
                          const Gap(4),
                          Text(
                            formatDate.format(item.dateDebut),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.customBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(4),
                          Icon(Iconsax.arrow_right_3,
                              size: 14, color: Colors.grey.shade400),
                          const Gap(4),
                          Text(
                            formatDate.format(item.dateFin),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.customBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),

                      Row(
                        children: [
                          Icon(Iconsax.user,
                              size: 14, color: Colors.grey.shade500),
                          const Gap(4),
                          Text(
                            "${item.nombrePersonnes} pers.",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          Icon(Iconsax.wallet_money,
                              size: 14, color: Colors.grey.shade500),
                          const Gap(4),
                          Text(
                            "${Utils.formatCurrency(item.budgetMin)} - ${Utils.formatCurrency(item.budgetMax)}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(14),

            BlocBuilder<OwnerInvitationsCubit, OwnerInvitationsState>(
              builder: (context, state) {
                final isLoading = state is OwnerInvitationsLoaded &&
                    state.actingItemId == item.id;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _decline(context),
                      icon: const Icon(Iconsax.close_circle, size: 16),
                      label: const Text("Décliner",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const Gap(8),
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _confirm(context),
                      icon: isLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Iconsax.tick_circle, size: 16),
                      label: const Text("Confirmer",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final cubit = context.read<OwnerInvitationsCubit>();
    final success = await cubit.confirm(item);
    if (success) {
      EasyLoadingHandler.showSuccessToast(text: "Disponibilité confirmée !");
    } else {
      EasyLoadingHandler.showErrorToast(
          text: "Échec de la confirmation, réessayez.");
    }
  }

  Future<void> _decline(BuildContext context) async {
    final cubit = context.read<OwnerInvitationsCubit>();
    final success = await cubit.decline(item);
    if (!success) {
      EasyLoadingHandler.showErrorToast(text: "Échec, réessayez.");
    }
  }
}
