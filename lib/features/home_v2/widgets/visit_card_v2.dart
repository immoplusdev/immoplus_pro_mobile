import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    // Ported Logic: Handle visit date/time
    final hasDate = demandeVisiteModel.datesDemandeVisite.isNotEmpty;
    final firstDate =
        hasDate ? demandeVisiteModel.datesDemandeVisite.first.date : null;

    final propertyName =
        demandeVisiteModel.bienImmobilier?.nom ?? "Bien immobilier";
    final imageUrl = demandeVisiteModel.bienImmobilier?.miniature ??
        demandeVisiteModel.bienImmobilier?.images.firstOrNull;

    // Status Logic
    final isExpress =
        demandeVisiteModel.typeDemandeVisite?.toLowerCase() == 'express';
    final isPaid = demandeVisiteModel.statusFacture?.toLowerCase() == 'paye';

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
                  // 1. Property Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: Utils.getImagePath(id: imageUrl),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
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
                          "Visite $propertyName",
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
                          "📍 ${demandeVisiteModel.bienImmobilier?.adresse ?? "_"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Gap(8),
                        if (!hasDate)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Colors.red),
                              const Gap(5),
                              Expanded(
                                child: Text(
                                  "Sélectionner le jour et l'heure",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Colors.grey),
                              const Gap(5),
                              Text(
                                Utils.formatDatenly(dateTime: firstDate!),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(10),
                              const Icon(Icons.access_time,
                                  size: 14, color: Colors.grey),
                              const Gap(4),
                              Text(
                                Utils.formatTimeOnly(dateTime: firstDate!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.customBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // 3. Right side: Type & Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isExpress ? "Express" : "Normal",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1CA53F),
                        ),
                      ),
                      if (isPaid) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                        "Créée le ${Utils.formatDatenly(dateTime: demandeVisiteModel.createdAt ?? DateTime.now())}",
                        style: TextStyle(
                          fontSize: 12,
                          // color: Colors.grey.shade400,
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
                              // color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Utils.formatCurrency(
                            demandeVisiteModel.montantTotalDemandeVisite),
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
        child: VisitDetailPage(id: demandeVisiteModel.id),
      ),
    );
  }
}
