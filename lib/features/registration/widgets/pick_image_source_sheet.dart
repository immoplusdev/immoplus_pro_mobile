import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/compress_file_utils.dart';

/// Bottom sheet "Prendre une photo / Choisir depuis la galerie" partagé par
/// les cartes d'upload de documents (photo d'identité, pièces, etc).
Future<XFile?> showPickImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<XFile?>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajouter un fichier',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(20),
          _PickSourceOption(
            icon: Iconsax.camera,
            label: 'Prendre une photo',
            onTap: () async {
              final file = await ImagePicker().pickImage(
                source: ImageSource.camera,
                imageQuality: 40,
                maxWidth: 1600,
                maxHeight: 1600,
              );
              XFile? compressed;
              if (file != null) {
                compressed = await CompressFileUtils.compressFileIfNeeded(file);
              }
              if (context.mounted) Navigator.pop(context, compressed);
            },
          ),
          const Gap(12),
          _PickSourceOption(
            icon: Iconsax.gallery,
            label: 'Choisir depuis la galerie',
            onTap: () async {
              final file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: 40,
                maxWidth: 1600,
                maxHeight: 1600,
              );
              XFile? compressed;
              if (file != null) {
                compressed = await CompressFileUtils.compressFileIfNeeded(file);
              }
              if (context.mounted) Navigator.pop(context, compressed);
            },
          ),
        ],
      ),
    ),
  );
}

class _PickSourceOption extends StatelessWidget {
  const _PickSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const Gap(14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Iconsax.arrow_right_3, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
