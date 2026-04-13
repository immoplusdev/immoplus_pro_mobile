import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/booking/booking_detail_page.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

class BookingCardV2 extends StatelessWidget {
  final ReservationModel reservationModel;

  const BookingCardV2({
    super.key,
    required this.reservationModel,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatDate = DateFormat('d MMMM yyyy');
    
    final propertyName = reservationModel.residence.nom;
    final address = reservationModel.residence.adresse;
    final imageUrl = reservationModel.residence.miniature ?? 
                   reservationModel.residence.images.firstOrNull;

    // Dates logic
    final startDate = Utils.toDateTime(reservationModel.dateDebut);
    final endDate = Utils.toDateTime(reservationModel.dateFin);
    final checkInTime = reservationModel.residence.heureEntree;
    final checkOutTime = reservationModel.residence.heureDepart;

    // Status logic
    final isPaid = reservationModel.statusFacture.toLowerCase() == 'paye';
    
    // Duration
    final duration = reservationModel.datesReservation.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showDetail(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.customBlue,
              width: .25,
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
                    borderRadius: BorderRadius.circular(15),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: Utils.getImagePath(id: imageUrl),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                  ),
                  const Gap(15),

                  // 2. Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Réservation $propertyName",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const Gap(2),
                        Text(
                          "📍 ${address.isNotEmpty ? address : '_'}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            const Icon(Icons.login_rounded, size: 14, color: Colors.grey),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "${formatDate.format(startDate)} à $checkInTime",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            const Icon(Icons.logout_rounded, size: 14, color: Colors.grey),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "${formatDate.format(endDate)} avant $checkOutTime",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3. Right Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.customBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$duration jour${duration > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.customBlue,
                          ),
                        ),
                      ),
                      if (isPaid) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1CA53F).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Payée",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1CA53F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const Gap(12),
              Divider(height: 1, color: Colors.grey.shade100),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Créée le ${formatDate.format(Utils.toDateTime(reservationModel.createdAt))}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const Gap(2),
                      Row(
                        children: [
                          Icon(Icons.touch_app_outlined,
                              size: 12, color: Colors.grey.shade400),
                          const Gap(4),
                          Text(
                            "Touchez pour voir plus ...",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    Utils.formatCurrency(reservationModel.montantTotalReservation),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.customBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.scafold,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: BookingDetailPage(id: reservationModel.id),
      ),
    );
  }
}
