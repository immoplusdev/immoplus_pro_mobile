import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/booking/booking_detail_page.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';

/// Card d'action "à répondre" : réservation en attente de réponse
/// propriétaire OU invitation reverse-search (client cherchant une
/// résidence correspondant à ses critères). Même gabarit visuel pour les
/// deux — seuls les boutons d'action et le cubit qu'ils appellent diffèrent,
/// vu que ce sont deux flux backend distincts (réservation vs reverse
/// search). Fournir exactement un des deux paramètres.
class PendingReservationCardV2 extends StatelessWidget {
  final ReservationModel? reservationModel;
  final OwnerInvitationItem? invitation;

  const PendingReservationCardV2({
    super.key,
    this.reservationModel,
    this.invitation,
  }) : assert(
          (reservationModel != null) != (invitation != null),
          'Fournir soit reservationModel soit invitation, jamais les deux ni aucun.',
        );

  @override
  Widget build(BuildContext context) {
    final DateFormat formatDate = DateFormat('d MMMM yyyy');
    final isInvitation = invitation != null;

    final String propertyName;
    final String address;
    final String? resolvedImageUrl;
    final DateTime startDate;
    final DateTime endDate;
    final int duration;
    final num montant;

    if (isInvitation) {
      final item = invitation!;
      propertyName =
          item.nom.isNotEmpty ? item.nom : "Nouvelle demande de location";
      address = item.adresse;
      resolvedImageUrl = item.resolvedImageUrl;
      startDate = item.dateDebut;
      endDate = item.dateFin;
      final calcDuration = endDate.difference(startDate).inDays;
      duration = calcDuration > 0 ? calcDuration : 1;
      montant = item.montant;
    } else {
      final r = reservationModel!;
      propertyName = r.residence.nom;
      address = r.residence.adresse;
      final rawImageId = r.residence.miniature ?? r.residence.images.firstOrNull;
      resolvedImageUrl = (rawImageId != null && rawImageId.isNotEmpty)
          ? Utils.getImagePath(id: rawImageId)
          : null;
      startDate = Utils.toDateTime(r.dateDebut);
      endDate = Utils.toDateTime(r.dateFin);
      duration = r.datesReservation.length;
      montant = r.montantTotalReservation;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: isInvitation ? null : () => _showDetail(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.customBlue.withOpacity(0.1),
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
                  // 1. Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: resolvedImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: resolvedImageUrl,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _imagePlaceholder(),
                            errorWidget: (context, url, error) =>
                                _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                  const Gap(14),

                  // 2. Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Badges Inline
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                propertyName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            const Gap(8),
                            // Duration Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                "$duration jr${duration > 1 ? 's' : ''}",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.customBlue,
                                ),
                              ),
                            ),
                            const Gap(4),
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7E6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "En attente : ${Utils.formatCurrency(montant)}",
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

                        // Address Row
                        Row(
                          children: [
                            Icon(Iconsax.location,
                                size: 14, color: AppColors.primary),
                            const Gap(4),
                            Expanded(
                              child: Text(
                                address.isNotEmpty ? address : 'Pas d\'adresse',
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

                        // Dates Row (Start -> End)
                        Row(
                          children: [
                            Icon(Iconsax.calendar_1,
                                size: 14, color: AppColors.primary),
                            const Gap(4),
                            Text(
                              formatDate.format(startDate),
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
                              formatDate.format(endDate),
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.customBlue,
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

              // Actions
              isInvitation
                  ? _buildInvitationActions(context, invitation!)
                  : _buildReservationActions(context, reservationModel!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 55,
      height: 55,
      color: Colors.grey.shade50,
      child: Icon(Iconsax.image, color: Colors.grey.shade300, size: 24),
    );
  }

  Widget _buildReservationActions(
      BuildContext context, ReservationModel reservationModel) {
    return BlocBuilder<PendingReservationsCubit, RequestState>(
      builder: (context, state) {
        final isLoading = state is REQUEST_LOADING;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<PendingReservationsCubit>()
                      .refuser(reservationModel.id),
              icon: const Icon(Iconsax.close_circle, size: 16),
              label: const Text("Refuser",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const Gap(8),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<PendingReservationsCubit>()
                      .accepter(reservationModel.id),
              icon: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Iconsax.tick_circle, size: 16),
              label: const Text("Accepter",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Widget _buildInvitationActions(
      BuildContext context, OwnerInvitationItem invitation) {
    return BlocBuilder<OwnerInvitationsCubit, OwnerInvitationsState>(
      builder: (context, state) {
        final isLoading = state is OwnerInvitationsLoaded &&
            state.actingItemId == invitation.id;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<OwnerInvitationsCubit>()
                      .decline(invitation),
              icon: const Icon(Iconsax.close_circle, size: 16),
              label: const Text("Décliner",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const Gap(8),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      final success = await context
                          .read<OwnerInvitationsCubit>()
                          .confirm(invitation);
                      if (success) {
                        EasyLoadingHandler.showSuccessToast(
                            text: "Disponibilité confirmée !");
                      }
                    },
              icon: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Iconsax.tick_circle, size: 16),
              label: const Text("Confirmer",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  void _showDetail(BuildContext context) {
    final r = reservationModel!;
    getIt<AnalyticsService>().logBookingCardTapped(
      idReservation: r.id,
      status: r.statusReservation,
    );
    showModalBottomSheet(
      backgroundColor: Colors.white,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.60,
        child: BookingDetailPage(id: r.id),
      ),
    );
  }
}
