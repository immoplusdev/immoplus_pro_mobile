import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/common/widgets/v2/remove_video_button_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/upload_video_page_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/video_preview_v2.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/outlined_action_button.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `media_upload` des photos (`minFiles` à `maxFiles`). La première
/// photo envoyée sert de couverture.
class PhotosField extends StatelessWidget {
  const PhotosField({
    super.key,
    required this.field,
    required this.photos,
    required this.errorText,
    required this.onPicked,
    required this.onUpdated,
    required this.onRemoved,
  });

  static const double _thumbnailSize = 88;

  final CreationField field;
  final List<ImageUploadItem> photos;
  final String? errorText;
  final void Function(List<File> files) onPicked;
  final ValueChanged<ImageUploadItem> onUpdated;
  final ValueChanged<String> onRemoved;

  bool get _canAddMore =>
      field.maxFiles == null || photos.length < field.maxFiles!;

  Future<void> _pick(BuildContext context) async {
    final files = await ImagePickerService.pickMultipleImages(context: context);
    if (files.isNotEmpty) onPicked(files);
  }

  String get _counter {
    final max = field.maxFiles;
    final count = max == null ? '${photos.length}' : '${photos.length}/$max';
    return field.minFiles == null
        ? count
        : '$count · minimum ${field.minFiles}';
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      errorText: errorText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_canAddMore)
            _PhotoDropZone(
              label: field.label ?? 'Ajouter des photos',
              helperText: field.helperText,
              hasError: errorText != null,
              onTap: () => _pick(context),
            ),
          if (photos.isNotEmpty) ...[
            AppSpacing.gap12,
            SizedBox(
              height: _thumbnailSize,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, __) => AppSpacing.gap8,
                itemBuilder: (context, index) {
                  final item = photos[index];
                  return SizedBox(
                    width: _thumbnailSize,
                    height: _thumbnailSize,
                    child: UploadImageItemCard(
                      key: ValueKey(item.id),
                      imageItem: item,
                      onItemUpdated: onUpdated,
                      onDelete: () => onRemoved(item.id),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.gap8,
            Text(_counter,
                style:
                    AppTypography.caption.copyWith(color: AppColors.gray400)),
          ],
        ],
      ),
    );
  }
}

class _PhotoDropZone extends StatelessWidget {
  const _PhotoDropZone({
    required this.label,
    required this.helperText,
    required this.hasError,
    required this.onTap,
  });

  final String label;
  final String? helperText;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = hasError ? AppColors.red500 : AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CreationStyle.tileRadius),
      child: DottedBorder(
        color: color,
        strokeWidth: 1.2,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(CreationStyle.tileRadius),
        child: Container(
          width: double.infinity,
          height: 128,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CreationStyle.selectedFill,
            borderRadius: BorderRadius.circular(CreationStyle.tileRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/creation_icon/gallery-import.svg',
                height: 32,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              AppSpacing.gap8,
              Text(label,
                  style:
                      AppTypography.bodySmallSemiBold.copyWith(color: color)),
              if (helperText != null)
                Text(helperText!,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.gray400)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Champ `media_upload` de la vidéo (facultative, un seul fichier). La valeur
/// est l'identifiant du fichier envoyé.
class VideoField extends StatelessWidget {
  const VideoField({
    super.key,
    required this.field,
    required this.videoId,
    required this.errorText,
    required this.uploadFile,
    required this.onChanged,
  });

  final CreationField field;
  final String? videoId;
  final String? errorText;

  /// Envoi du fichier vidéo ; retourne l'identifiant du fichier.
  final Future<String> Function(File file) uploadFile;
  final ValueChanged<String?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final id = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: UploadVideoPageV2(uploader: uploadFile),
      ),
    );
    if (id != null) onChanged(id);
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      tag: field.required ? null : 'Facultatif',
      child: videoId != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoPreviewV2(videoId: videoId!),
                RemoveVideoButtonV2(onTap: () => onChanged(null)),
              ],
            )
          : OutlinedActionButton(
              label: 'Ajouter une vidéo',
              leadingIcon: Icons.add,
              onPressed: () => _pick(context),
            ),
    );
  }
}
