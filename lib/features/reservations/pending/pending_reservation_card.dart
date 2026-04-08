import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingReservationCard extends StatelessWidget {
  const PendingReservationCard({
    super.key,
    required this.reservationModel,
    this.showActions = true,
  });

  final ReservationModel reservationModel;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat('d MMM yyyy', 'fr_FR');
    final dateDebut = DateTime.tryParse(reservationModel.dateDebut);
    final dateFin = DateTime.tryParse(reservationModel.dateFin);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: reservationModel.residence.miniature != null
                        ? CachedNetworkImage(
                            imageUrl: Utils.getImagePath(
                                id: reservationModel.residence.miniature!),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.home, size: 30),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.home, size: 30),
                          ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        reservationModel.residence.nom,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Gap(4),
                      if (dateDebut != null && dateFin != null)
                        Text(
                          '${formatDate.format(dateDebut)} → ${formatDate.format(dateFin)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              Utils.formatCurrency(reservationModel.montantTotalReservation),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.primary),
            ),
            if (showActions) ...[
              const Gap(10),
              BlocBuilder<PendingReservationsCubit, RequestState>(
                builder: (context, state) {
                  final isLoading = state is REQUEST_LOADING;
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<PendingReservationsCubit>()
                                      .accepter(reservationModel.id);
                                },
                          icon: const Icon(Icons.check_circle_outline,
                              color: Colors.white),
                          label: const Text('ACCEPTER',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<PendingReservationsCubit>()
                                      .refuser(reservationModel.id);
                                },
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.white),
                          label: const Text('REFUSER',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
