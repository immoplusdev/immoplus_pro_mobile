import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/registration/widgets/pick_image_source_sheet.dart';
import 'package:immoplus_pro/features/registration/widgets/upload_status_badge.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte pleine largeur à bordure pointillée pour l'upload d'un document
/// (icône, titre et sous-titre centrés à l'intérieur).
class DocumentUploadCard extends StatefulWidget {
  const DocumentUploadCard({
    super.key,
    required this.controller,
    required this.label,
    this.subtitle,
    this.icon = Iconsax.gallery_add,
    this.height = 170,
    this.placeholderImageId,
  });

  final FileUploaderController controller;
  final String label;
  final String? subtitle;
  final IconData icon;
  final double height;

  /// Id d'un fichier déjà uploadé à afficher tant qu'aucun nouveau fichier
  /// n'a été sélectionné localement — utile pour préremplir un document
  /// déjà existant lors d'une édition (non utilisé à l'inscription).
  final String? placeholderImageId;

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  bool _loading = false;

  Future<void> _pickImage() async {
    setState(() => _loading = true);
    try {
      final file = await showPickImageSourceSheet(context);
      setState(() {
        _loading = false;
        if (file != null) {
          widget.controller.filePath = file.path;
          widget.controller.file = File(file.path);
          widget.controller.startBackgroundUpload();
        }
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = widget.controller.filePath != null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _loading ? null : _pickImage,
          child: DottedBorder(
            color: AppColors.primary.withValues(alpha: 0.5),
            strokeWidth: 1.5,
            dashPattern: const [7, 5],
            borderType: BorderType.RRect,
            radius: const Radius.circular(24),
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: hasFile
                    ? DecorationImage(
                        image: FileImage(File(widget.controller.filePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: hasFile
                  ? null
                  : (widget.placeholderImageId != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl:
                                Utils.getImagePath(id: widget.placeholderImageId!),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade400,
                              period: const Duration(milliseconds: 500),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.icon,
                                  color: AppColors.primary, size: 40),
                              const Gap(10),
                              Text(
                                widget.label,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              if (widget.subtitle != null) ...[
                                const Gap(6),
                                Text(
                                  widget.subtitle!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )),
            ),
          ),
        ),
        if (hasFile)
          Positioned(
            top: 8,
            right: 8,
            child: UploadStatusBadge(controller: widget.controller),
          ),
      ],
    );
  }
}
