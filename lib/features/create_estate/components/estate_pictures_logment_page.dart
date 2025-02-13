import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/residence_detail/components/logment_viewer_image.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_images_pages.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class EstatePicturesLogmentPage extends StatefulWidget {
  const EstatePicturesLogmentPage({super.key});
  static String name = "pictures_logment_page";

  @override
  State<EstatePicturesLogmentPage> createState() =>
      _EstatePicturesLogmentPageState();
}

class _EstatePicturesLogmentPageState extends State<EstatePicturesLogmentPage> {
  @override
  void initState() {
    super.initState();
    //PregressStepperEstateCreating.setStepe(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        slivers: [
          Visibility(
            visible: EstateCreationModelBuilder().images.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DottedBorder(
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  color: CupertinoColors.systemGrey,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.photoFilm,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Gap(10),
                      Text(
                        "Capturez la beauté de votre bien ! Prenez des photos soigneusement travaillées pour attirer davantage de clients. N'oubliez pas, la première image sélectionnée sera celle affichée en miniature.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )),
            ),
            child: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
                mainAxisExtent: 200,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewerImageLogment(
                                initialPage: 0,
                                tag: EstateCreationModelBuilder().images[index],
                                imageUrls: EstateCreationModelBuilder().images),
                          ));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: Utils.getImagePath(
                                id: EstateCreationModelBuilder().images[
                                    index]), //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

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
                        Positioned(
                          right: 3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  EstateCreationModelBuilder()
                                      .images
                                      .removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete)),
                        ),
                      ],
                    ),
                  );
                },
                childCount: EstateCreationModelBuilder().images.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_photo_alternate_outlined),
        onPressed: () async {
          print(EstateCreationModelBuilder().images);
          showModalBottomSheet<List<String>>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            builder: (context) => const FractionallySizedBox(
              heightFactor: 0.9,
              child: UploadImagePage(),
            ),
          ).then(
            (value) {
              setState(() {
                if (value != null) {
                  EstateCreationModelBuilder().miniature = value.first;
                  EstateCreationModelBuilder().images.addAll(value);
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreationEstateNavigation.goToPage(
              pageName: EstateLogmentLocationPage.name);
        },
        onNext: EstateCreationModelBuilder().images.isNotEmpty
            ? () async {
                CreationEstateNavigation.goToPage(
                    pageName: EstateVideoLogmentPage.name);
              }
            : null,
      ),
    );
  }
}
