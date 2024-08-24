import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({
    super.key,
    required this.videoURL,
  });
  final String videoURL;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isLoadinng = true;
  VideoPlayerController? controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse("${RequestPath.baseUrl}/api/file/${widget.videoURL}"),
      // Uri.parse(
      //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )..initialize().then((_) {
        setState(() {
          _isLoadinng == false;
          controller!.pause();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller!,
        builder: (context, value, _) {
          print(value.position.inSeconds);
          return Column(
            children: [
              controller!.value.isInitialized
                  ? GestureDetector(
                      onTap: () async {
                        controller!.value.isPlaying
                            ? await controller!.pause()
                            : await controller!.play();
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child: VideoPlayer(controller!),
                            ),
                          ),
                          Positioned.fill(
                            // bottom: 0,
                            // right: 150,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Visibility(
                                visible: !controller!.value.isPlaying,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: CupertinoColors.systemFill,
                                  child: Icon(
                                    controller!.value.isPlaying
                                        ? CupertinoIcons.pause
                                        : CupertinoIcons.play_arrow_solid,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: (Colors.grey[300])!,
                      highlightColor: Colors.white,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
              SmoothVideoProgress(
                controller: controller!,
                builder: (context, position, duration, child) => Slider(
                  mouseCursor: MouseCursor.defer,
                  // onChangeStart: (_) => controller.pause(),
                  // onChangeEnd: (_) => controller.play(),
                  onChanged: (value) =>
                      controller!.seekTo(Duration(milliseconds: value.toInt())),
                  value: position.inMilliseconds.toDouble(),
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    () async {
      await controller!.pause();
      await controller!.dispose();
    }();

    super.dispose();
  }
}
