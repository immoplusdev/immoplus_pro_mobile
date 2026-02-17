import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_video_page.dart';
import 'package:immoplus_pro/request_path.dart';
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

  String _videoUrlFromId(String id) {
    final clean = id.trim();
    if (clean.isEmpty) return '';
    if (clean.startsWith('http://') || clean.startsWith('https://'))
      return clean;
    final base = RequestPath.baseUrl.endsWith('/')
        ? RequestPath.baseUrl
        : '${RequestPath.baseUrl}/';
    return '${base}files/videos/raw/public/$clean';
  }

  @override
  void initState() {
    super.initState();
    final videoId = (_manager.video ?? '').trim();
    if (videoId.isEmpty) {
      _isLoading = false;
    } else {
      _initializeVideoPlayer(videoId);
    }
  }

  void _initializeVideoPlayer(String videoUrlOrId) {
    final videoUrl = _videoUrlFromId(videoUrlOrId);
    if (videoUrl.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      _chewieController?.dispose();
      _chewieController = null;
      _controller?.dispose();
      _controller = null;
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (!mounted) return;
          _initializeChewieController();
          if (!mounted) return;
          setState(() => _isLoading = false);
        }).catchError((Object e) {
          if (!mounted) return;
          _controller?.dispose();
          _controller = null;
          _chewieController = null;
          setState(() => _isLoading = false);
        });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _initializeChewieController() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final ar = _controller!.value.aspectRatio;
    final aspectRatio = (ar > 0 && ar.isFinite) ? ar : 16 / 9;
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      aspectRatio: aspectRatio,
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

  @override
  void dispose() {
    _chewieController?.dispose();
    _chewieController = null;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  bool get _showPlayer {
    return _controller != null &&
        (_controller!.value.isInitialized) &&
        _chewieController != null;
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = (_manager.video ?? '').trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          hasVideo
              ? SliverToBoxAdapter(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _showPlayer
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final w = constraints.maxWidth;
                                final ar = () {
                                  final r = _controller!.value.aspectRatio;
                                  return (r > 0 && r.isFinite) ? r : 16 / 9;
                                }();
                                final h = (w > 0 && ar > 0) ? w / ar : 220.0;
                                final height = h.clamp(220.0, 400.0);
                                return Container(
                                  width: double.infinity,
                                  height: height,
                                  color: Colors.black,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller!.value.isPlaying
                                            ? _chewieController?.pause()
                                            : _chewieController?.play();
                                      });
                                    },
                                    child: AspectRatio(
                                      aspectRatio: ar,
                                      child: Chewie(
                                          controller: _chewieController!),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.video,
                                      size: 80,
                                    ),
                                    const Gap(12),
                                    const Text(
                                      'Erreur lors du chargement de la video.',
                                      textAlign: TextAlign.center,
                                    ),
                                    const Gap(16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final id =
                                            (_manager.video ?? '').trim();
                                        if (id.isNotEmpty) {
                                          setState(() => _isLoading = true);
                                          _initializeVideoPlayer(id);
                                        }
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Réessayer'),
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
                            "Aucune video n'a encore été ajoutée. Sélectionnez une video de votre meuble.",
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
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.video_call, color: Colors.white),
        onPressed: () {
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
          ).then((value) {
            if (!mounted) return;
            if (value == null || value.isEmpty) return;
            final trimmed = value.trim();
            _manager.video = trimmed;
            setState(() => _isLoading = true);
            _initializeVideoPlayer(trimmed);
          });
        },
      ),
    );
  }
}
