import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const bool _videoStepDisabled = true;

  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  int _loadToken = 0;
  String _lastLoadedVideoValue = '';

  @override
  void initState() {
    super.initState();
    if (_videoStepDisabled) {
      _isLoading = false;
      return;
    }
    _loadVideoFromManager();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncVideoFromManagerIfNeeded();
  }

  void _disposePlayers() {
    try {
      _chewieController?.dispose();
    } catch (e) {
      log('Erreur dispose chewie: $e');
    }
    try {
      _controller?.dispose();
    } catch (e) {
      log('Erreur dispose video controller: $e');
    }
    _chewieController = null;
    _controller = null;
  }

  Future<void> _loadVideoFromManager() async {
    final videoValue = (_manager.video ?? '').trim();
    final currentToken = ++_loadToken;

    _lastLoadedVideoValue = videoValue;

    if (!mounted) return;

    final videoId = videoValue;
    if (videoId.isEmpty) {
      _disposePlayers();
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    final videoUrl = _buildVideoUrl(videoId);
    await _initializeVideoPlayer(videoUrl, currentToken);
  }

  void _syncVideoFromManagerIfNeeded() {
    final currentValue = (_manager.video ?? '').trim();
    if (currentValue == _lastLoadedVideoValue) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadVideoFromManager();
    });
  }

  String _buildVideoUrl(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return 'https://api-v2.immoplus.ci/files/videos/raw/public/$value';
  }

  Future<void> _initializeVideoPlayer(String videoUrl, int currentToken) async {
    log('Lecture de la video depuis : $videoUrl');

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    _disposePlayers();

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ),
    );

    try {
      await controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La video prend trop de temps a charger');
        },
      );

      if (controller.value.hasError) {
        throw Exception(
          controller.value.errorDescription ?? 'Erreur inconnue du lecteur video',
        );
      }

      if (controller.value.duration == Duration.zero) {
        throw Exception('Video invalide ou corrompue');
      }

      final chewieController = ChewieController(
        videoPlayerController: controller,
        aspectRatio: controller.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      );

      if (!mounted || currentToken != _loadToken) {
        chewieController.dispose();
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _chewieController = chewieController;
        _isLoading = false;
        _errorMessage = null;
      });
    } on PlatformException catch (e) {
      controller.dispose();
      log('PlatformException video: ${e.code} ${e.message}');
      if (!mounted || currentToken != _loadToken) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur video (${e.code}): ${e.message ?? 'Operation interrompue'}';
      });
    } catch (e) {
      controller.dispose();
      log('Erreur lors du chargement video: $e');
      if (!mounted || currentToken != _loadToken) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _loadToken++;
    _disposePlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoStepDisabled) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FontAwesomeIcons.videoSlash, size: 72),
                Gap(12),
                Text(
                  "L'etape video est temporairement desactivee.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    _syncVideoFromManagerIfNeeded();

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
                      ? const Center(child: CircularProgressIndicator())
                      : (_controller != null &&
                              _chewieController != null &&
                              _controller!.value.isInitialized)
                          ? GestureDetector(
                              onTap: () {
                                try {
                                  setState(() {
                                    _controller!.value.isPlaying
                                        ? _chewieController?.pause()
                                        : _chewieController?.play();
                                  });
                                } catch (e) {
                                  log('Erreur toggle play/pause: $e');
                                }
                              },
                              child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: Chewie(controller: _chewieController!),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.video,
                                      size: 100,
                                    ),
                                    const Gap(10),
                                    const Text(
                                      'Erreur lors du chargement de la video.',
                                      textAlign: TextAlign.center,
                                    ),
                                    if (_errorMessage != null) ...[
                                      const Gap(8),
                                      Text(
                                        _errorMessage!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    const Gap(12),
                                    ElevatedButton.icon(
                                      onPressed: _loadVideoFromManager,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Reessayer'),
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
                            "Aucune video n'a encore ete ajoutee. "
                            'Selectionnez une video de votre meuble.',
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
          final value = await showModalBottomSheet<String>(
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
          );

          if (value != null && value.isNotEmpty) {
            _manager.video = value;
            await _loadVideoFromManager();
          }
        },
      ),
    );
  }
}
