import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/booking/booking_detail_page.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

/// Card moderne pour l'onglet "En attente de paiement" :
/// Présente les réservations acceptées pour lesquelles le règlement
/// client est en attente, dans le même gabarit visuel que [PendingReservationCardV2].
class PendingPaymentCardV2 extends StatelessWidget {
  final ReservationModel reservationModel;

  const PendingPaymentCardV2({
    super.key,
    required this.reservationModel,
  });

  void _showDetail(BuildContext context) {
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
        child: BookingDetailPage(id: reservationModel.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatDate = DateFormat('d MMMM yyyy', 'fr_FR');
    final r = reservationModel;

    final propertyName = r.residence.nom.isNotEmpty
        ? r.residence.nom
        : 'Résidence';
    final address = r.residence.adresse;
    final rawImageId =
        r.residence.miniature ?? r.residence.images.firstOrNull;
    final resolvedImageUrl = (rawImageId != null && rawImageId.isNotEmpty)
        ? Utils.getImagePath(id: rawImageId)
        : null;

    final startDate = Utils.toDateTime(r.dateDebut);
    final endDate = Utils.toDateTime(r.dateFin);
    final calcDuration = endDate.difference(startDate).inDays;
    final duration = r.datesReservation.isNotEmpty
        ? r.datesReservation.length
        : (calcDuration > 0 ? calcDuration : 1);

    final clientName = [
      r.client.firstName,
      r.client.lastName,
    ].where((part) => part.isNotEmpty).join(' ');

    final deadline = r.delaisPaiementClient != null &&
            r.delaisPaiementClient!.isNotEmpty
        ? DateTime.tryParse(r.delaisPaiementClient!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showDetail(context),
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
              // ── Header (Image + infos) ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
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

                  // Colonne d'infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre + Badges
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
                            // Badge Durée
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
                            // Badge Statut Paiement
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7E6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                "En attente paiement",
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

                        // Adresse
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

                        // Dates de séjour
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

              // ── Délai de paiement si renseigné ──
              if (deadline != null) ...[
                const Gap(12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.timer_1,
                          size: 14, color: Colors.amber.shade900),
                      const Gap(6),
                      Expanded(
                        child: Text(
                          "Paiement client attendu avant le ${DateFormat('d MMM à HH:mm', 'fr_FR').format(deadline)}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Gap(12),
              Divider(
                color: Colors.grey.shade100,
                height: 1,
                thickness: 1,
              ),
              const Gap(12),

              // ── Footer : Montant & Client / CTA ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Montant
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Montant à percevoir",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        Utils.formatCurrency(r.montantTotalReservation),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),

                  // Client & Bouton Détails
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (clientName.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Iconsax.user,
                                  size: 13, color: AppColors.customBlue),
                              const Gap(5),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 110),
                                child: Text(
                                  clientName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Détails",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Gap(2),
                            Icon(Iconsax.arrow_right_3,
                                size: 12, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
}

