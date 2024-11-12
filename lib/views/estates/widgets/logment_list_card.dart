import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class BienImmoblierListCard extends StatelessWidget {
  const BienImmoblierListCard({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.push('/estate_page/${bienImmobilierModel.id}');
      },
      child: Container(
        height: 143,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
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
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        bienImmobilierModel.nom ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Chip(
                                backgroundColor: Colors.green.shade200,
                                avatar: const Icon(
                                  FontAwesomeIcons.eye,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                label: const Text('Disponible'),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Chip(
                              backgroundColor: Colors.red.shade200,
                              avatar: const Icon(
                                FontAwesomeIcons.eyeSlash,
                                size: 18,
                              ),
                              label: const Text('Indisponible'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
