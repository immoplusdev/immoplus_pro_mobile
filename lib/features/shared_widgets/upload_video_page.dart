import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});
  static String name = "video_logment";

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  String videoPath = '';
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  final ImagePicker _picker = ImagePicker();

  void _initializeChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      aspectRatio: _controller!.value.aspectRatio,
      autoPlay: true,
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

  void _changeVideo(String newPath) {
    _controller?.pause();
    _controller?.dispose();
    _chewieController?.dispose();

    _controller = VideoPlayerController.file(File(newPath))
      ..initialize().then((_) {
        _initializeChewieController();
        setState(() {});
      });

    _controller?.play();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final File? pickedVideo = await ImagePickerService.pickVideo(
      context: context,
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      videoPath = pickedVideo.path;
      _changeVideo(videoPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          Visibility(
            visible: videoPath.isNotEmpty,
            replacement: const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.video,
                        size: 100,
                      ),
                      Gap(10),
                      Text(
                        "Sélectionner la vidéo à envoyer",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: SliverToBoxAdapter(
              child: (_controller != null && _controller!.value.isInitialized)
                  ? GestureDetector(
                      onTap: () async {
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
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _pickVideo,
        child: const Icon(Icons.video_call),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 20),
        child: ElevatedButton.icon(
          onPressed: () async {
            EasyLoadingHandler.showLoadingToast(text: "Traitement vidéo...");
            try {
              if (videoPath.isNotEmpty) {
                // File? fileToSend =
                //     await CoreUtils.convertirEtCompresserVideo(videoPath);

                EasyLoadingHandler.showLoadingToast(text: "Envoi de la vidéo...");

                FileDataModel response =
                    await AuthRepository.uplaodFile(file: File(videoPath));
                if (response.data != null) {
                  context.pop<String>(response.data!.id);
                  EasyLoadingHandler.hideLoadingToast();
                }
              } else {
                EasyLoadingHandler.showErrorToast(text: "Envoi échoué");
              }
            } catch (e) {
              EasyLoading.dismiss();
              // EasyLoadingHandler.showErrorToast(
              //     text: "Envoi échoué", dismissOnTap: true);
            }
          },
          label: const Text("Envoyer la vidéo"),
          icon: const FaIcon(FontAwesomeIcons.cloudArrowUp),
        ),
      ),
    );
  }
}
