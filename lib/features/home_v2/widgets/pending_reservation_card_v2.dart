import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
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

    final checkInTime = reservationModel.residence.heureEntree;
    final checkOutTime = reservationModel.residence.heureDepart;
    final duration = reservationModel.datesReservation.length;

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: Utils.getImagePath(id: imageUrl),
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade50,
                              child: Icon(Iconsax.image,
                                  color: Colors.grey.shade300, size: 24),
                            ),
                          )
                        : Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade50,
                            child: Icon(Iconsax.image,
                                color: Colors.grey.shade300, size: 24),
                          ),
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
                              // decoration: BoxDecoration(
                              //   color: AppColors.customBlue.withOpacity(0.08),
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
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
                                "En attente : ${Utils.formatCurrency(reservationModel.montantTotalReservation)}",
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
                        // const Gap(6),

                        // Times Row (CheckIn -> CheckOut)
                        // Row(
                        //   children: [
                        //     Icon(Iconsax.clock, size: 14, color: AppColors.primary),
                        //     const Gap(4),
                        //     Text(
                        //       checkInTime,
                        //       style: TextStyle(
                        //         fontSize: 11,
                        //         color: Colors.grey.shade600,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //     const Gap(4),
                        //     Icon(Iconsax.arrow_right_3, size: 14, color: Colors.grey.shade400),
                        //     const Gap(4),
                        //     Text(
                        //       checkOutTime,
                        //       style: TextStyle(
                        //         fontSize: 11,
                        //         color: Colors.grey.shade600,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(14),

              // Actions
              BlocBuilder<PendingReservationsCubit, RequestState>(
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
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .primary, // Using primary color instead of green raw
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
      ),
    );
  }

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
}
