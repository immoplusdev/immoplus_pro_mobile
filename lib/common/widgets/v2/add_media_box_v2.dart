import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class AddMediaBoxV2 extends StatelessWidget {
  final bool isVideo;
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const AddMediaBoxV2({
    super.key,
    required this.isVideo,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: DottedBorder(
        color: AppColors.primary.withOpacity(0.5),
        strokeWidth: 1.5,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        child: Container(
          width: width ?? 100,
          height: height ?? 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isVideo
                    ? 'assets/svgs/creation_icon/video-add.svg'
                    : 'assets/svgs/creation_icon/gallery-import.svg',
                height: 28,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const Gap(8),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
