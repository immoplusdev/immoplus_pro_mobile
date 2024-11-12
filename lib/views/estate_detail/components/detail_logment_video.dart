import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/views/video_player/video_player_page.dart';

class DetailEstateVideo extends StatelessWidget {
  const DetailEstateVideo({
    super.key,
    required this.bienImmobilier,
  });
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          (bienImmobilier.video != null) && bienImmobilier.video!.isNotEmpty,
      replacement: const SliverToBoxAdapter(),
      child: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: VideoPlayerPage(videoID: bienImmobilier.video!),
        ),
      ),
    );
  }
}
