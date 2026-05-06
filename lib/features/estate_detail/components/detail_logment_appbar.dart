import 'package:immoplus_pro/features/shared_widgets/custom_flutter_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/validation_status.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:shimmer/shimmer.dart';

class DetailEstateAppBar extends StatelessWidget {
  DetailEstateAppBar({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
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
            print(Constantes.tempPage);
            //context.goNamed(ResidencesPage.name);
            context.pop();
          },
          style: IconButton.styleFrom(
            iconSize: 20,
            fixedSize: const Size(18, 18),
            padding: EdgeInsets.zero,
          ),
          icon: Container(
              width: 30,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Icon(
                CupertinoIcons.chevron_back,
                color: AppColors.primary,
              ))),
        ),
      ),
      actions: [
        if (bienImmobilier.validationStatus == ValidationStatus.valide)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              onPressed: () async {
                final shareText = 'Découvrez ce bien immobilier sur ImmoPlus\n'
                    'Description : ${bienImmobilier.description}.\n'
                    'Prix : ${bienImmobilier.prix} F\n'
                    'Adresse : ${bienImmobilier.adresse}.\n';

                final origin =
                    ShareService.getSharePositionFromKey(_shareButtonKey);
                await ShareService.shareText(
                    text: shareText, sharePositionOrigin: origin);
              },
              style: IconButton.styleFrom(
                iconSize: 25,
                fixedSize: const Size(18, 18),
                padding: EdgeInsets.zero,
              ),
              icon: Container(
                key: _shareButtonKey,
                width: 30,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Center(
                  child: Icon(
                    CupertinoIcons.share,
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
        //               CupertinoIcons.heart,
        //             ),
        //     ),
        //   ),
        // ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CustomFlutterCarousel(
          images: bienImmobilier.images ?? [],
          height: 500,
          aspectRatio: 16 / 9,
          showGradient: true,
          onImageTap: (index) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MosaicLogmentImages(
                  tag: bienImmobilier.images![index],
                  imageUrls: bienImmobilier.images!,
                ),
              ),
            );
          },
        ),
      ),


    );
  }
}
