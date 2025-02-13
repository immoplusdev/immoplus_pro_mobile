import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoID;

  const VideoPlayerPage({super.key, required this.videoID});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAndPlayVideo();
  }

  Future<void> _initializeAndPlayVideo() async {
    final String videoUrl =
        "https://api-v2.immoplus.ci/files/videos/raw/public/${widget.videoID}";
    log(videoUrl);

    try {
      // Utiliser un VideoPlayerController.network pour lire la vidéo en streaming
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      )..initialize().then((_) {
          setState(() {
            _isLoading = false;

            // Initialiser ChewieController
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: false,
              looping: false,
            );
          });
        });
    } catch (e) {
      log('Erreur lors de la lecture de la vidéo : $e');
    }
  }

  @override
  void dispose() {
    // Nettoyer les contrôleurs
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildShimmerEffect() // Affiche l'effet Shimmer pendant le chargement
        : SizedBox(height: 300, child: Chewie(controller: _chewieController!));
  }

  // Simuler un effet Shimmer avec des containers en gradients
  Widget _buildShimmerEffect() {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.3, 0.7],
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
