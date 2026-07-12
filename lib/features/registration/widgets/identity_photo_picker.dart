import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/registration/widgets/pick_image_source_sheet.dart';
import 'package:immoplus_pro/features/registration/widgets/upload_status_badge.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';

/// Sélecteur de photo d'identité (selfie) : carré à bordure pointillée,
/// label au-dessus, texte d'instruction dans la zone, aide en dessous.
class IdentityPhotoPicker extends StatefulWidget {
  const IdentityPhotoPicker({
    super.key,
    required this.controller,
    required this.label,
    required this.placeholderText,
    this.helperText,
    this.size = 160,
    this.icon = Iconsax.gallery_add,
  });

  final FileUploaderController controller;
  final String label;
  final String placeholderText;
  final String? helperText;
  final double size;
  final IconData icon;

  @override
  State<IdentityPhotoPicker> createState() => _IdentityPhotoPickerState();
}

class _IdentityPhotoPickerState extends State<IdentityPhotoPicker> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
        const Gap(16),
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _loading ? null : _pickImage,
              child: Container(
                width: widget.size,
                height: widget.size,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.grey.shade200),
                ),
                child: DottedBorder(
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                  dashPattern: const [6, 4],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(14),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: hasFile
                          ? DecorationImage(
                              image:
                                  FileImage(File(widget.controller.filePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: hasFile
                        ? null
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.icon,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                  const Gap(8),
                                  Text(
                                    widget.placeholderText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            if (hasFile)
              Positioned(
                top: -6,
                right: -6,
                child: UploadStatusBadge(controller: widget.controller),
              ),
          ],
        ),
        if (widget.helperText != null) ...[
          const Gap(12),
          Text(
            widget.helperText!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}
