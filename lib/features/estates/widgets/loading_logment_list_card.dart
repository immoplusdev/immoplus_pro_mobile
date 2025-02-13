import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class LoadingLogmentListCard extends StatelessWidget {
  const LoadingLogmentListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: SizedBox(
                  height: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://i.pinimg.com/736x/be/d5/8e/bed58e0fea0bec4c3924858a2a13cd5d.jpg",
                    // Utils.getImagePath( ),
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit
                        .cover, // or other BoxFit values as per your design
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
                        '••••••••••',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
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
                                '••••••••••',
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
                            '••••',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Icon(
                            Icons.star_rate_rounded,
                            size: 14,
                          ),
                          Text(
                            '4',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      //Text('2 chambre 3 Sallon 1 cuisine'),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                            backgroundColor: Colors.green.shade200,
                            avatar: Icon(
                              FontAwesomeIcons.doorOpen,
                              size: 18,
                            ),
                            label: Text('Ouvert'),
                          ),
                          Gap(10),
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
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
