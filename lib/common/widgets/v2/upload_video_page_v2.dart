import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:video_player/video_player.dart';

class UploadVideoPageV2 extends StatefulWidget {
  const UploadVideoPageV2({super.key});

  @override
  State<UploadVideoPageV2> createState() => _UploadVideoPageV2State();
}

class _UploadVideoPageV2State extends State<UploadVideoPageV2> {
  String _videoPath = '';
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isUploading = false;

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final File? pickedVideo = await ImagePickerService.pickVideo(
      context: context,
    );

    if (pickedVideo != null) {
      setState(() => _videoPath = pickedVideo.path);
      _initializeVideo(pickedVideo);
    }
  }

  void _initializeVideo(File file) {
    _controller?.dispose();
    _chewieController?.dispose();

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            aspectRatio: _controller!.value.aspectRatio,
            autoPlay: true,
            looping: false,
          );
        });
      });
  }

  Future<void> _uploadVideo() async {
    if (_videoPath.isEmpty) return;

    setState(() => _isUploading = true);
    CustomPopup.showLoagingToast(text: "Envoi de la vidéo...");

    try {
      FileDataModel response =
          await AuthRepository.uplaodFile(file: File(_videoPath));
      if (response.data != null) {
        if (mounted) {
          context.pop<String>(response.data!.id);
        }
      }
    } catch (e) {
      if (mounted) {
        CustomPopup.showErrorToast(text: "Échec de l'envoi");
      }
    } finally {
      CustomPopup.hideLoadingToast();
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // V2 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Ajouter une vidéo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Gap(5),
                    Text(
                      "Sélectionnez une vidéo de votre bien",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: _videoPath.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.video,
                                size: 80, color: Colors.grey.shade400),
                            const Gap(20),
                            Text(
                              "Aucune vidéo sélectionnée",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: (_chewieController != null &&
                                  _chewieController!
                                      .videoPlayerController.value.isInitialized)
                              ? Chewie(controller: _chewieController!)
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ),
                ),
              ),
            ),

            const Gap(20),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickVideo,
                    icon: const Icon(Icons.video_library),
                    label: Text(_videoPath.isEmpty
                        ? "Choisir une vidéo"
                        : "Changer la vidéo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                  ),
                  const Gap(15),
                  if (_videoPath.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _isUploading ? null : _uploadVideo,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(FontAwesomeIcons.cloudArrowUp),
                      label: const Text("Confirmer et Envoyer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
