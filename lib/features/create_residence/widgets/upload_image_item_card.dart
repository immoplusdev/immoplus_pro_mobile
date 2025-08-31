import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/core/services/image_upload_service.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_widgets/error_overlay_icon.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_widgets/progress_overlay_icon.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class UploadImageItemCard extends StatefulWidget {
  final ImageUploadItem imageItem;
  final Function(ImageUploadItem updatedItem)? onItemUpdated;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const UploadImageItemCard({
    super.key,
    required this.imageItem,
    this.onItemUpdated,
    this.onDelete,
    this.onTap,
  });

  @override
  State<UploadImageItemCard> createState() => _UploadImageItemCardState();
}

class _UploadImageItemCardState extends State<UploadImageItemCard> {
  late ImageUploadItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.imageItem;

    if (_currentItem.canUploadToServer) {
      _startUpload();
    }
  }

  Future<void> _startUpload() async {
    final result = await ImageUploadService.uploadImage(_currentItem.file!);

    if (mounted) {
      setState(() {
        if (result.isSuccess) {
          _currentItem = _currentItem.copyWith(
            status: UploadStatus.success,
            uploadedId: result.imageId,
          );
        } else {
          _currentItem = _currentItem.copyWith(
            status: UploadStatus.failed,
            errorMessage: result.errorMessage,
          );
        }
      });

      // Notifier la page parent du changement
      widget.onItemUpdated?.call(_currentItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _currentItem.isLocal
                  ? Image.file(_currentItem.file!, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl:
                          Utils.getImagePath(id: _currentItem.uploadedId!),

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
                      fit: BoxFit
                          .cover, // or other BoxFit values as per your design
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _getOverlayColor(),
            ),
            child: _buildOverlayForStatus(
              key: ValueKey(_currentItem.status),
            ),
          ),
          if (widget.onDelete != null &&
              _currentItem.status != UploadStatus.uploading)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayForStatus({Key? key}) {
    switch (_currentItem.status) {
      case UploadStatus.uploading:
        return ProgressOverlayIcon(
          key: key,
          value: null,
          label: 'chargement...',
        );

      case UploadStatus.success:
        return SizedBox();

      case UploadStatus.failed:
        return ErrorOverlayIcon(
          key: key,
          message: _currentItem.errorMessage,
        );
    }
  }

  Color _getOverlayColor() {
    switch (_currentItem.status) {
      case UploadStatus.uploading:
        return Colors.black54;
      case UploadStatus.success:
        return Colors.transparent;
      case UploadStatus.failed:
        return Colors.red.withOpacity(0.3);
    }
  }
}
