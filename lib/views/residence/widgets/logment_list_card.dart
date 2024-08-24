import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ResidenceListCard extends StatelessWidget {
  const ResidenceListCard({super.key, required this.residence});
  final ResidenceModel residence;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.go('/logment_page/${residence.id}');

        // final Uri url = Uri.parse(
        //     "${RequestPath.baseUrl}/admin/content/logements/${residence.id}");
        // if (!await launchUrl(url)) {
        //   throw Exception('Could not launch $url');
        // }
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Container(
                  color: Colors.grey.shade200,
                  height: double.infinity,
                  width: double.infinity,
                  child: Visibility(
                    visible: residence.images.isNotEmpty,
                    child: CachedNetworkImage(
                      imageUrl: (residence.images.isNotEmpty)
                          ? Utils.getImagePath(id: residence.images.first)
                          : '',

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade400,
                        period: Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                    children: [
                      Text(
                        residence.nom ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Gap(5),

                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                            ),
                            Flexible(
                              child: Text(
                                residence.adresse ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Row(
                        children: [
                          Icon(
                            Icons.villa,
                            size: 14,
                          ),
                          Text(
                            residence.typeResidence,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // Icon(
                          //   Icons.star_rate_rounded,
                          //   size: 14,
                          // ),
                          // Text(
                          //   '4',
                          //   style: Theme.of(context).textTheme.bodySmall,
                          // ),
                        ],
                      ),
                      //Text('2 chambre 3 Sallon 1 cuisine'),
                      Gap(5),
                      Text(
                        Utils.formatCurrency(residence.prixReservation),
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      Gap(5),
                      if (residence.residenceDisponible)
                        Chip(
                          backgroundColor: Colors.green.shade200,
                          avatar: Icon(
                            FontAwesomeIcons.doorOpen,
                            size: 18,
                          ),
                          label: Text('Ouvert'),
                        ),
                      if (!(residence.residenceDisponible))
                        Chip(
                          backgroundColor: Colors.red.shade200,
                          avatar: Icon(
                            FontAwesomeIcons.doorClosed,
                            size: 18,
                          ),
                          label: Text('Fermer'),
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
