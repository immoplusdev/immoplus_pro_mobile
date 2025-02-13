// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/residence_detail/components/logment_viewer_image.dart';
import 'package:shimmer/shimmer.dart';

class MosaicLogmentImages extends StatelessWidget {
  MosaicLogmentImages({super.key, required this.imageUrls, required this.tag});
  final Random random = Random();
  final List<String>? imageUrls;
  final String tag;
  int previousWidth = 1;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                CupertinoIcons.chevron_back,
                size: 30,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: imageUrls!.asMap().entries.map(
              (e) {
                int width = (previousWidth == 2)
                    ? 2
                    : random.nextBool()
                        ? 2
                        : 4;

                previousWidth = width;
                return StaggeredGridTile.count(
                  crossAxisCellCount: width,
                  mainAxisCellCount: random.nextInt(3) + 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewerImageLogment(
                                initialPage: e.key,
                                tag: e.value,
                                imageUrls: imageUrls),
                          ));
                    },
                    child: CachedNetworkImage(
                      imageUrl: Utils.getImagePath(
                          id: e
                              .value), //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

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
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
