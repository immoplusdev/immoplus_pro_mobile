import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/common/validation_status.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/features/residence/utils/residences_utils.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_chip.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class BienImmoblierListCard extends StatelessWidget {
  BienImmoblierListCard(
      {super.key, required this.bienImmobilierModel, required this.onTap});
  final BienImmobilierModel bienImmobilierModel;
  final VoidCallback? onTap;
  final GlobalKey _shareButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 143,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Ombre douce
                spreadRadius: 1, // L'étendue de l'ombre
                blurRadius: 10, // Flou de l'ombre
                offset: const Offset(0, 0), // Décalage horizontal et vertical
              ),
            ]),
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Container(
                  color: Colors.grey.shade200,
                  height: double.infinity,
                  width: double.infinity,
                  child: Visibility(
                    visible: bienImmobilierModel.images.isNotEmpty,
                    child: CachedNetworkImage(
                      imageUrl: (bienImmobilierModel.images.isNotEmpty)
                          ? Utils.getImagePath(
                              id: bienImmobilierModel.images.first)
                          : '',

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade400,
                        period: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit
                          .cover, // or other BoxFit values as per your design
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            bienImmobilierModel.nom,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (bienImmobilierModel.validationStatus ==
                            ValidationStatus.valide)
                          GestureDetector(
                              onTap: () async {
                                // Code for the placeholder:
                                final String shareUrl =
                                    'https://app.immoplus.ci/residence_detail/${bienImmobilierModel.id}';

                                final String shareText =
                                    'Découvrez la résidence ${bienImmobilierModel.nom} sur ImmoPlus.\n'
                                    'Prix de réservation : ${bienImmobilierModel.prix} F/${bienImmobilierModel.typeLocation}.\n'
                                    'Lien : $shareUrl';

                                final origin =
                                    ShareService.getSharePositionFromKey(
                                        _shareButtonKey);
                                await ShareService.shareText(
                                  text: shareText,
                                  subject: 'Partager ce bien immobilier',
                                  sharePositionOrigin: origin,
                                );
                              },
                              child: FaIcon(
                                key: _shareButtonKey,
                                CupertinoIcons.share,
                                color: AppColors.primary,
                                size: 19,
                              )),
                      ],
                    ),

                    const Gap(5),

                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                          ),
                          Flexible(
                            child: AutoSizeText(
                              bienImmobilierModel.adresse,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Text('2 chambre 3 Sallon 1 cuisine'),
                    const Gap(5),
                    Text(
                      "${Utils.formatCurrency(bienImmobilierModel.prix)} / ${bienImmobilierModel.typeLocation}",
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),

                    Visibility(
                      visible: !bienImmobilierModel.bienImmobilierDisponible,
                      replacement: Material(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomChip(
                              label: ResidencesUtils.getValidationStatusName(
                                  bienImmobilierModel.statusValidation),
                              labelStyle: const TextStyle(color: Colors.white),
                              backgroundColor:
                                  ResidencesUtils.getValidationStatusColor(
                                      bienImmobilierModel.statusValidation),
                              icon: ResidencesUtils.getValidationStatusIcon(
                                  bienImmobilierModel.statusValidation),
                              iconColor: Colors.white,
                              iconSize: 15,
                              iconPadding: const EdgeInsets.only(right: 5),
                            ),
                            CustomChip(
                              backgroundColor: Colors.green.shade100,
                              icon: FontAwesomeIcons.eye,
                              iconColor: Colors.green,
                              label: 'Disponible',
                              iconSize: 15,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomChip(
                            label: ResidencesUtils.getValidationStatusName(
                                bienImmobilierModel.statusValidation),
                            labelStyle: const TextStyle(color: Colors.white),
                            backgroundColor:
                                ResidencesUtils.getValidationStatusColor(
                                    bienImmobilierModel.statusValidation),
                            icon: ResidencesUtils.getValidationStatusIcon(
                                bienImmobilierModel.statusValidation),
                            iconColor: Colors.white,
                            iconSize: 15,
                            iconPadding: const EdgeInsets.only(right: 5),
                          ),
                          CustomChip(
                            backgroundColor: Colors.red.shade200,
                            iconSize: 15,
                            icon: FontAwesomeIcons.eyeSlash,
                            label: 'Indisponible',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
