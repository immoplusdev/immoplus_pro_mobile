import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/views/video_player/video_player_page.dart';

class DetailLogmentVideo extends StatelessWidget {
  const DetailLogmentVideo({
    super.key,
    required this.logmentModel,
  });
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (logmentModel.video != null) && logmentModel.video!.isNotEmpty,
      replacement: SliverToBoxAdapter(),
      child: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          // height: 300,
          //color: Colors.red,
          child: VideoPlayerPage(videoURL: logmentModel.video!),
        ),
      ),
    );
  }
}
