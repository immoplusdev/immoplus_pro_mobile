import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_video_page.dart';
import 'package:video_player/video_player.dart';


class StepVideosPage extends StatefulWidget {
  const StepVideosPage({super.key});

  static String name = 'step_videos_page';

  @override
  State<StepVideosPage> createState() => _StepVideosPageState();
}

class _StepVideosPageState extends State<StepVideosPage> {
  final _manager = FurnitureCreationManager();

  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if ((_manager.video ?? '').isNotEmpty) {
      final videoUrl =
          'https://api-v2.immoplus.ci/files/videos/raw/public/${_manager.video}';
      _initializeVideoPlayer(videoUrl);
    } else {
      _isLoading = false;
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    log('Lecture de la vidéo depuis : $videoUrl');
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      )..initialize().then((_) {
          _initializeChewieController();
          setState(() {
            _isLoading = false;
          });
        });
    } catch (e) {
      log('Erreur : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeChewieController() {
    if (_controller != null && _controller!.value.isInitialized) {
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          (_manager.video ?? '').isNotEmpty
              ? SliverToBoxAdapter(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (_controller != null &&
                              _controller!.value.isInitialized)
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _chewieController?.pause()
                                      : _chewieController?.play();
                                });
                              },
                              child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: Chewie(controller: _chewieController!),
                              ),
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.video,
                                      size: 100,
                                    ),
                                    Gap(10),
                                    Text(
                                      "Erreur lors du chargement de la vidéo.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                )
              : const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.video,
                            size: 100,
                          ),
                          Gap(10),
                          Text(
                            "Aucune vidéo n'a encore été ajoutée. "
                            "Sélectionnez une vidéo de votre meuble.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.furnitureViolet,
        child: const Icon(Icons.video_call, color: Colors.white),
        onPressed: () async {
          showModalBottomSheet<String>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            builder: (context) => const FractionallySizedBox(
              heightFactor: 0.9,
              child: UploadVideoPage(),
            ),
          ).then(
            (value) {
              if (value != null && value.isNotEmpty) {
                setState(() {
                  _manager.video = value;
                  _isLoading = true;
                  final videoUrl =
                      'https://api-v2.immoplus.ci/files/videos/raw/public/${_manager.video}';
                  _controller?.dispose();
                  _chewieController?.dispose();
                  _initializeVideoPlayer(videoUrl);
                });
              }
            },
          );
        },
      ),
    );
  }
}
