import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/rules_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_video_page.dart';
import 'package:video_player/video_player.dart';

class VideoLogmentPage extends StatefulWidget {
  const VideoLogmentPage({super.key});
  static String name = "video_logment";

  @override
  State<VideoLogmentPage> createState() => _VideoLogmentPageState();
}

class _VideoLogmentPageState extends State<VideoLogmentPage> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (ResidenceCreationModelBuilder().video.isNotEmpty) {
      // String videoUrl =
      //     "https://api-v2.immoplus.ci/files/videos/raw/${ResidenceCreationModelBuilder().video}.mp4";
      String videoUrl =
          "https://api-v2.immoplus.ci/files/videos/raw/public/${ResidenceCreationModelBuilder().video}";
      _initializeVideoPlayer(videoUrl);
    } else {
      _isLoading = false;
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    log("Lecture de la vidéo depuis : $videoUrl");
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // SliverToBoxAdapter(
          //   child: Text(
          //     'En cours de développement cliquez sur suivant',
          //     style: Theme.of(context)
          //         .textTheme
          //         .labelLarge!
          //         .copyWith(color: Colors.redAccent),
          //   ),
          // ),
          ResidenceCreationModelBuilder().video.isNotEmpty
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
                                      "Aucune vidéo n'a encore été téléchargée. Sélectionnez une vidéo bien retouchée de votre logement.",
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
                            "Aucune vidéo n'a encore été téléchargée. Sélectionnez une vidéo bien retouchée de votre logement.",
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
        child: const Icon(Icons.video_call),
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
              setState(() {
                ResidenceCreationModelBuilder().video = value ?? '';
                if (value != null && value.isNotEmpty) {
                  _isLoading = true;
                  String videoUrl =
                      "https://api-v2.immoplus.ci/files/videos/raw/public/${ResidenceCreationModelBuilder().video}";
                  // String videoUrl =
                  //     "https://api.immoplus.ci/files/videos/raw/public/aae3e6ca-abb8-497d-a2e3-e04c2b7d76cf.mp4";
                  _controller?.dispose();
                  _chewieController?.dispose();
                  _initializeVideoPlayer(videoUrl);
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SizedBox()
          : StepBottomButton(
              onPrevious: () {
                CreationResidenceNavigation.goToPage(
                    pageName: PicturesLogmentPage.name);
              },
              onNext: () {
                CreationResidenceNavigation.goToPage(pageName: RulesPage.name);
              },
            ),
    );
  }
}
