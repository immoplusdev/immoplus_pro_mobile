import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/features/visits/visit_detail_page.dart';
import 'package:immoplus_pro/utils/utils.dart';

class VisitCardV2 extends StatelessWidget {
  final DemandeVisiteModel demandeVisiteModel;

  const VisitCardV2({
    super.key,
    required this.demandeVisiteModel,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = demandeVisiteModel.datesDemandeVisite.isNotEmpty;
    final firstDate =
        hasDate ? demandeVisiteModel.datesDemandeVisite.first.date : null;

    final propertyName =
        demandeVisiteModel.bienImmobilier?.nom ?? "Bien immobilier";
    final imageUrl = demandeVisiteModel.bienImmobilier?.miniature ??
        demandeVisiteModel.bienImmobilier?.images.firstOrNull;

    final isExpress =
        demandeVisiteModel.typeDemandeVisite?.toLowerCase() == 'express';
    final isPaid = demandeVisiteModel.statusFacture?.toLowerCase() == 'paye';

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: Utils.getImagePath(id: imageUrl),
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade50,
                          child: const Icon(Iconsax.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 55,
                        height: 55,
                        color: Colors.grey.shade50,
                        child: const Icon(Iconsax.image, color: Colors.grey),
                      ),
              ),
              const Gap(12),

              // 2. Info Column (takes remaining space)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Row: Title + Badges
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            propertyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ),
                        const Gap(8),
                        // Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isExpress
                                ? const Color(0xFFFF9800).withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isExpress ? "Express" : "Normal",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: isExpress
                                  ? Colors.orange.shade800
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        // Paid / Unpaid Badge
                        if (isPaid) ...[
                          const Gap(4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1CA53F).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Payée",
                              style: TextStyle(
                                fontSize: 8,
                                color: Color(0xFF1CA53F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else if (isExpress) ...[
                          const Gap(4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Iconsax.empty_wallet,
                                    size: 10, color: Colors.red.shade700),
                                const Gap(4),
                                Flexible(
                                  child: Text(
                                    "À payer : ${Utils.formatCurrency(demandeVisiteModel.montantTotalDemandeVisite)}",
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    const Gap(6),

                    // Creation Date Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Iconsax.calendar_add,
                            size: 12, color: Colors.grey.shade500),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            "Créée le ${Utils.formatDatenly(dateTime: demandeVisiteModel.createdAt ?? DateTime.now())}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),

                    // Scheduled Date Row
                    if (!hasDate)
                      Row(
                        children: [
                          Icon(Iconsax.calendar_tick,
                              size: 14, color: AppColors.primary),
                          const Gap(4),
                          Expanded(
                            child: Text(
                              "Programmer la visite",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Iconsax.calendar_1,
                              size: 14, color: AppColors.primary),
                          const Gap(4),
                          Text(
                            Utils.formatDatenly(dateTime: firstDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.customBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Icon(Iconsax.clock,
                              size: 14, color: AppColors.primary),
                          const Gap(4),
                          Text(
                            Utils.formatTimeOnly(dateTime: firstDate!),
                            style: TextStyle(
                              fontSize: 12,
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
        child: VisitDetailPage(id: demandeVisiteModel.id),
      ),
    );
  }
}
