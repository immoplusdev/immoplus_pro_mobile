import 'package:immoplus_pro/features/shared_widgets/custom_flutter_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/validation_status.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:shimmer/shimmer.dart';

class DetailLogmentAppBar extends StatelessWidget {
  DetailLogmentAppBar({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      //toolbarHeight: 300,
      expandedHeight: 280.0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          onPressed: () {
            // context.goNamed(ResidencesPage.name);
            context.pop();
          },
          style: IconButton.styleFrom(
            iconSize: 20,
            fixedSize: const Size(18, 18),
            padding: EdgeInsets.zero,
          ),
          icon: Container(
              width: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Icon(
                CupertinoIcons.chevron_back,
                color: AppColors.primary,
              ))),
        ),
      ),
      actions: [
        if (logmentModel.validationStatus == ValidationStatus.valide)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              key: _shareButtonKey,
              onPressed: () async {
                // Code for the placeholder:
                final String shareUrl =
                    'https://app.immoplus.ci/residence_detail/${logmentModel.id}';

                final String shareText =
                    'Découvrez la résidence ${logmentModel.nom} sur ImmoPlus.\n'
                    'Prix de réservation : ${logmentModel.prixReservation} F.\n'
                    'Lien : $shareUrl';

                final origin =
                    ShareService.getSharePositionFromKey(_shareButtonKey);
                await ShareService.shareText(
                  text: shareText,
                  sharePositionOrigin: origin,
                  subject: 'Partager ma résidence ImmoPlus',
                );
              },
              style: IconButton.styleFrom(
                iconSize: 25,
                fixedSize: const Size(18, 18),
                padding: EdgeInsets.zero,
              ),
              icon: Container(
                width: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.shareNodes,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 10),
        //   child: CircleAvatar(
        //     backgroundColor: CupertinoColors.white,
        //     radius: 18,
        //     child: IconButton(
        //       padding: EdgeInsets.zero,
        //       iconSize: 20,
        //       onPressed: () {},
        //       style: IconButton.styleFrom(
        //         iconSize: 25,
        //         fixedSize: Size(18, 18),
        //         padding: EdgeInsets.zero,
        //       ),
        //       icon: (productDetailModel.featured == true)
        //           ? Icon(
        //               CupertinoIcons.heart_fill,
        //               color: CupertinoColors.systemRed,
        //             )
        //           : Icon(
        //               CupertinoIcons.heart, pro
        //             ),
        //     ),
        //   ),
        // ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CustomFlutterCarousel(
          images: logmentModel.images,
          height: 500,
          aspectRatio: 16 / 9,
          showGradient: true,
          onImageTap: (index) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MosaicLogmentImages(
                  tag: logmentModel.images[index],
                  imageUrls: logmentModel.images,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
