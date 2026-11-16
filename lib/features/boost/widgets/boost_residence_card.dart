import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/boost/utils/boost_residence_formatter.dart';
import 'package:shimmer/shimmer.dart';

/// Miniature arrondie d'une résidence avec état de chargement et repli visuel.
class BoostResidenceThumbnail extends StatelessWidget {
  const BoostResidenceThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 76,
    this.borderRadius = 12,
  });

  final String? imageUrl;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.gray100,
                  highlightColor: Colors.white,
                  child: Container(color: AppColors.gray100),
                ),
                errorWidget: (context, url, error) => _buildFallback(),
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.slate100,
      child: const Center(
        child: Icon(
          Iconsax.building_3,
          size: 26,
          color: AppColors.gray400,
        ),
      ),
    );
  }
}

/// Carte horizontale d'une résidence validée dans la liste Boost,
/// avec bouton d'action « Partager » à droite.
class BoostResidenceCard extends StatelessWidget {
  const BoostResidenceCard({
    super.key,
    required this.residence,
    required this.onShare,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final ResidenceModel residence;
  final VoidCallback onShare;
  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final imageUrl = BoostResidenceFormatter.resolveImageUrl(residence);
    final subtitle = BoostResidenceFormatter.formatSubtitle(residence);
    final price =
        BoostResidenceFormatter.formatNightlyPrice(residence.prixReservation);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.r16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BoostResidenceThumbnail(
            imageUrl: imageUrl,
            size: 76,
            borderRadius: AppRadii.r12,
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
                  style: AppTypography.bodyMediumSemiBold.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray950,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const Gap(4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
                const Gap(6),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmallSemiBold.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          ElevatedButton(
            onPressed: (isLoading || isDisabled) ? null : onShare,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: isLoading
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(86, 38),
              shape: const StadiumBorder(),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Partager',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
