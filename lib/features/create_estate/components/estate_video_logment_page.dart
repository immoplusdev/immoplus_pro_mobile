import 'dart:developer';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estatedescription_editor_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_video_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class EstateVideoLogmentPage extends StatefulWidget {
  const EstateVideoLogmentPage({super.key});
  static String name = "video_logment";

  @override
  State<EstateVideoLogmentPage> createState() => _EstateVideoLogmentPageState();
}

class _EstateVideoLogmentPageState extends State<EstateVideoLogmentPage> {
  VideoPlayerController? _controller; // Rendre nullable
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _localVideoPath;

  @override
  void initState() {
    super.initState();
    //PregressStepperEstateCreating.setStepe(6);
    // Télécharger et jouer la vidéo s'il y a une vidéo associée
    if (EstateCreationModelBuilder().video != null) {
      _downloadAndPlayVideo(
          "https://api-v2.immoplus.ci/files/raw/public/${EstateCreationModelBuilder().video}.mp4");
    } else {
      // Si aucune vidéo, ne pas afficher le loader
      _isLoading = false;
    }
  }

  Future<void> _downloadAndPlayVideo(String videoUrl) async {
    log("Téléchargement de la vidéo depuis : $videoUrl");
    try {
      final http.Response response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode == 200) {
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = tempDir.path;
        final File videoFile = File('$tempPath/temp_video.mp4');

        // Écrire la vidéo téléchargée dans un fichier local
        await videoFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _localVideoPath = videoFile.path;
        });

        // Initialiser VideoPlayerController avec le fichier local
        _controller = VideoPlayerController.file(videoFile)
          ..initialize().then((_) {
            _initializeChewieController();
            setState(() {
              _isLoading = false;
            });
          });
      } else {
        throw Exception('Erreur lors du téléchargement de la vidéo');
      }
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
    // Supprimer la vidéo locale si elle a été téléchargée
    if (_localVideoPath != null) {
      final File videoFile = File(_localVideoPath!);
      if (videoFile.existsSync()) {
        videoFile.deleteSync();
        print('Vidéo supprimée : $_localVideoPath');
      }
    }
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          (EstateCreationModelBuilder().video != null)
              ? SliverToBoxAdapter(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (_controller != null &&
                              _controller!.value.isInitialized)
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller!.value.isPlaying
                                          ? _chewieController?.pause()
                                          : _chewieController?.play();
                                    });
                                  },
                                  child: AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child:
                                        Chewie(controller: _chewieController!),
                                  ),
                                ),
                                Gap(8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      EstateCreationModelBuilder().video = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "Supprimer la video",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
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
                if (value != null && value.isNotEmpty) {
                  EstateCreationModelBuilder().video = value;
                  // Redémarrer le téléchargement de la nouvelle vidéo
                  _isLoading = true;
                  _downloadAndPlayVideo(
                      "https://api-v2.immoplus.ci/files/raw/public/${EstateCreationModelBuilder().video}.mp4");
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: EstateCreationModelBuilder().editing
          ? SizedBox()
          : StepBottomButton(
              onPrevious: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstatePicturesLogmentPage.name);
              },
              onNext: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateDescriptionEditorPage.name);
              },
            ),
    );
  }
}
