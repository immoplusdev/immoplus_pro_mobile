import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/modules/logment_creation/components/pictures_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/rules_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

class VideoLogmentPage extends StatefulWidget {
  const VideoLogmentPage({super.key});
  static String name = "video_logment";

  @override
  State<VideoLogmentPage> createState() => _VideoLogmentPageState();
}

class _VideoLogmentPageState extends State<VideoLogmentPage> {
  String videoPath = '';
  void _changeVideo(String newPath) {
    // Arrêter la vidéo actuelle et libérer les ressources
    _controller.pause();
    _controller.dispose();

    // Créer un nouveau contrôleur pour le nouveau chemin de vidéo
    _controller = VideoPlayerController.file(File(newPath))
      ..initialize().then((_) {
        // Lorsque la vidéo est prête, rafraîchir l'interface pour afficher la première image
        setState(() {});
      });

    // Optionnel: Démarrer la vidéo automatiquement
    _controller.play();
  }

  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PregressStepperLogmentCreating.setStepe(6);
    _controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperLogmentCreating(),
            ),
          ),
          // SliverGap(50),
          Visibility(
            visible: videoPath.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.video,
                      size: 100,
                    ),
                    Gap(10),
                    Text(
                      "Partagez votre espace avec nous ! Sélectionnez une vidéo bien retouchée de votre logement, couvrant toutes les pièces et accompagnée d'une belle musique de fond. Montrez-nous ce qui rend votre chez-vous unique et captivant.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
            ),
            child: SliverToBoxAdapter(
              child: _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () async {
                        setState(() async {
                          _controller.value.isPlaying
                              ? await _controller.pause()
                              : await _controller.play();
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          Positioned.fill(
                            // bottom: 0,
                            // right: 150,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Visibility(
                                visible: !_controller.value.isPlaying,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: CupertinoColors.systemFill,
                                  child: Icon(
                                    _controller.value.isPlaying
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
            ),
          ),
          Visibility(
            visible: videoPath.isNotEmpty,
            replacement: SliverToBoxAdapter(),
            child: SliverToBoxAdapter(
              child: SmoothVideoProgress(
                controller: _controller,
                builder: (context, position, duration, child) => Slider(
                  mouseCursor: MouseCursor.defer,
                  // onChangeStart: (_) => controller.pause(),
                  // onChangeEnd: (_) => controller.play(),
                  onChanged: (value) =>
                      _controller.seekTo(Duration(milliseconds: value.toInt())),
                  value: position.inMilliseconds.toDouble(),
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.video_call),
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          await picker.pickVideo(source: ImageSource.gallery).then((value) {
            videoPath = value!.path;
            _changeVideo(value.path);
          }
              // Pick multiple images.
              );
        },
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
        },
        onNext: videoPath.isEmpty
            ? null
            : () async {
                EasyLoading.show(status: "Envoie de la vidéo");

                FileDataModel response =
                    await AuthRepository.uplaodFile(file: File(videoPath));
                if (response.data != null) {
                  ResidenceCreationModelBuilder().video =
                      response.data!.id ?? "";
                }

                EasyLoading.dismiss();
                log(ResidenceCreationModelBuilder().video.toString(),
                    name: 'VIDEO');
                CreateLogmentRouter.router.goNamed(RulesPage.name);
              },
      ),
    );
  }
}
