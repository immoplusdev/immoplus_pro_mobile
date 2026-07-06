import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';

/// Petit badge affiché sur une carte d'upload, reflétant l'état de l'upload
/// en arrière-plan d'un [FileUploaderController] : en cours, terminé ou en échec.
class UploadStatusBadge extends StatelessWidget {
  const UploadStatusBadge({super.key, required this.controller});

  final FileUploaderController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FileUploadStatus>(
      valueListenable: controller.status,
      builder: (context, status, _) {
        switch (status) {
          case FileUploadStatus.uploading:
            return _badge(
              color: Colors.white,
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            );
          case FileUploadStatus.uploaded:
            return _badge(
              color: Colors.green,
              child: const Icon(Iconsax.tick_circle, size: 14, color: Colors.white),
            );
          case FileUploadStatus.error:
            return _badge(
              color: Colors.red,
              child: const Icon(Iconsax.refresh, size: 13, color: Colors.white),
            );
          case FileUploadStatus.idle:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _badge({required Color color, required Widget child}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
