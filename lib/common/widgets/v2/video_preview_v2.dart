import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/request_path.dart';

class VideoPreviewV2 extends StatefulWidget {
  final String videoId;
  const VideoPreviewV2({super.key, required this.videoId});

  @override
  State<VideoPreviewV2> createState() => _VideoPreviewV2State();
}

class _VideoPreviewV2State extends State<VideoPreviewV2> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant VideoPreviewV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _controller?.dispose();
      _chewieController?.dispose();
      _isLoading = true;
      _hasError = false;
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    final videoUrl =
        "${RequestPath.baseUrl}/files/videos/raw/public/${widget.videoId}";
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            aspectRatio: _controller!.value.aspectRatio,
            autoPlay: false,
            looping: false,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_hasError || _chewieController == null) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text("Erreur lors du chargement de la vidéo",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
