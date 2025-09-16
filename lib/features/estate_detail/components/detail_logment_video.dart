import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/features/video_player/video_player_page.dart';

class DetailEstateVideo extends StatelessWidget {
  const DetailEstateVideo({
    super.key,
    required this.bienImmobilier,
  });
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return (bienImmobilier.video != null)
        ? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: VideoPlayerPage(videoID: bienImmobilier.video!),
            ),
          )
        : SliverToBoxAdapter();
  }
}
