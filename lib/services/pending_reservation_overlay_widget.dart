import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingReservationOverlayWidget extends StatefulWidget {
  final ReservationModel reservation;
  final VoidCallback onDismiss;
  final VoidCallback onNavigate;

  const PendingReservationOverlayWidget({
    super.key,
    required this.reservation,
    required this.onDismiss,
    required this.onNavigate,
  });

  @override
  State<PendingReservationOverlayWidget> createState() =>
      _PendingReservationOverlayWidgetState();
}

class _PendingReservationOverlayWidgetState
    extends State<PendingReservationOverlayWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _computeRemaining());
    });
  }

  void _computeRemaining() {
    final deadline = DateTime.tryParse(
      widget.reservation.delaisProprietaireReponse ?? '',
    );
    if (deadline == null) return;
    final diff = deadline.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _progressColor() {
    if (_remaining.inSeconds < 30) return Colors.red;
    if (_remaining.inSeconds < 60) return Colors.orange;
    return Colors.green;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      final hours = d.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat('d MMM', 'fr_FR');
    final dateDebut = DateTime.tryParse(widget.reservation.dateDebut);
    final dateFin = DateTime.tryParse(widget.reservation.dateFin);
    final progress = (_remaining.inSeconds / 120).clamp(0.0, 1.0);

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: widget.reservation.residence.miniature != null
                          ? CachedNetworkImage(
                              imageUrl: Utils.getImagePath(
                                  id: widget
                                      .reservation.residence.miniature!),
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
                        Text(
                          widget.reservation.residence.nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (dateDebut != null && dateFin != null)
                          Text(
                            '${formatDate.format(dateDebut)} → ${formatDate.format(dateFin)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        Text(
                          Utils.formatCurrency(
                              widget.reservation.montantTotalReservation),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: widget.onDismiss,
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Icon(Icons.timer_outlined,
                      size: 16, color: _progressColor()),
                  const Gap(6),
                  Text(
                    'Temps restant : ${_formatDuration(_remaining)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _progressColor(),
                        ),
                  ),
                ],
              ),
              const Gap(6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_progressColor()),
                  minHeight: 6,
                ),
              ),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Voir les details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
