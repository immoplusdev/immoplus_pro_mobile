import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/booking/booking_detail_page.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingReservationCardV2 extends StatelessWidget {
  final ReservationModel reservationModel;

  const PendingReservationCardV2({
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

    final startDate = Utils.toDateTime(reservationModel.dateDebut);
    final endDate = Utils.toDateTime(reservationModel.dateFin);

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
                            const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "${formatDate.format(startDate)} → ${formatDate.format(endDate)}",
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
                ],
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Utils.formatCurrency(reservationModel.montantTotalReservation),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.customBlue,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Attente pro",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Divider(height: 1, color: Colors.grey.shade100),
              const Gap(12),

              // Actions
              BlocBuilder<PendingReservationsCubit, RequestState>(
                builder: (context, state) {
                  final isLoading = state is REQUEST_LOADING;
                  
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => context
                                  .read<PendingReservationsCubit>()
                                  .refuser(reservationModel.id),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Refuser"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 0.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => context
                                  .read<PendingReservationsCubit>()
                                  .accepter(reservationModel.id),
                          icon: isLoading 
                              ? const SizedBox(
                                  width: 18, 
                                  height: 18, 
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                )
                              : const Icon(Icons.check, size: 18),
                          label: const Text("Accepter"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1CA53F),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
