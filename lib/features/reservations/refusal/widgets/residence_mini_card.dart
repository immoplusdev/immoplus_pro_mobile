import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/utils/utils.dart';

abstract class _Constants {
  static const double cardBorderRadius = 14.0;
  static const double imageSize = 58.0;
  static const double imageBorderRadius = 10.0;
  static const double borderWidth = 1.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);

  static const Color cardBackgroundColor = Color(0xFFF8FAFC);
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color titleColor = Color(0xFF0F172A);
  static const Color subtitleColor = Color(0xFF64748B);
  static const Color placeholderBgColor = Color(0xFFF1F5F9);
  static const Color placeholderIconColor = Color(0xFF94A3B8);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: titleColor,
    height: 1.2,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: subtitleColor,
  );

  static const TextStyle amountStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: Color(0xFF2744DE),
  );
}

class ResidenceMiniCard extends StatelessWidget {
  final ReservationModel reservation;

  const ResidenceMiniCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final residence = reservation.residence;
    final rawImageId = residence.miniature ?? residence.images.firstOrNull;
    final resolvedImageUrl = (rawImageId != null && rawImageId.isNotEmpty)
        ? Utils.getImagePath(id: rawImageId)
        : null;

    final locationParts = <String>[];
    if (residence.commune.isNotEmpty) {
      locationParts.add(residence.commune);
    } else if (residence.ville.isNotEmpty) {
      locationParts.add(residence.ville);
    } else if (residence.adresse.isNotEmpty) {
      locationParts.add(residence.adresse);
    }

    if (residence.pieces.isNotEmpty) {
      locationParts.add(
          '${residence.pieces.length} pièce${residence.pieces.length > 1 ? 's' : ''}');
    }

    final locationText =
        locationParts.isNotEmpty ? locationParts.join(' • ') : 'Résidence';

    return Container(
      padding: _Constants.cardPadding,
      decoration: BoxDecoration(
        color: _Constants.cardBackgroundColor,
        borderRadius: BorderRadius.circular(_Constants.cardBorderRadius),
        border: Border.all(
          color: _Constants.cardBorderColor,
          width: _Constants.borderWidth,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_Constants.imageBorderRadius),
            child: SizedBox(
              width: _Constants.imageSize,
              height: _Constants.imageSize,
              child: resolvedImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: resolvedImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(),
                      errorWidget: (context, url, error) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  residence.nom.isNotEmpty ? residence.nom : 'Résidence',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _Constants.titleStyle,
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _Constants.subtitleStyle,
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                Text(
                  Utils.formatCurrency(reservation.montantTotalReservation),
                  style: _Constants.amountStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: _Constants.placeholderBgColor,
      child: const Center(
        child: Icon(
          Iconsax.building_3,
          size: 24,
          color: _Constants.placeholderIconColor,
        ),
      ),
    );
  }
}
