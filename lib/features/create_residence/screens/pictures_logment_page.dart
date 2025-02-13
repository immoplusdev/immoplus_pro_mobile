import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/create_residence/pregress_stepper_logment_creating.dart';
import 'package:immoplus_pro/features/create_residence/utils/create_logment_router.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/create_estate/utils/create_estate_router.dart';
import 'package:immoplus_pro/features/residence_detail/components/logment_viewer_image.dart';
import 'package:immoplus_pro/features/shared_widgets/upload_images_pages.dart';
import 'package:shimmer/shimmer.dart';

class PicturesLogmentPage extends StatefulWidget {
  const PicturesLogmentPage({super.key});
  static String name = "pictures_logment_page";

  @override
  State<PicturesLogmentPage> createState() => _PicturesLogmentPageState();
}

class _PicturesLogmentPageState extends State<PicturesLogmentPage> {
  @override
  void initState() {
    super.initState();
    //PregressStepperResidenceCreating.setStepe(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          // SliverSafeArea(
          //   sliver: SliverPersistentHeader(
          //     delegate: PregressStepperResidenceCreating(),
          //   ),
          // ),
          Visibility(
            visible: ResidenceCreationModelBuilder().images.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey.shade400,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.photoFilm,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Gap(20),
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
                                tag: ResidenceCreationModelBuilder()
                                    .images[index],
                                imageUrls:
                                    ResidenceCreationModelBuilder().images),
                          ));
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: Utils.getImagePath(
                                  id: ResidenceCreationModelBuilder().images[
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
                                  ResidenceCreationModelBuilder()
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
                childCount: ResidenceCreationModelBuilder().images.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_photo_alternate_outlined),
        onPressed: () async {
          print(ResidenceCreationModelBuilder().images);
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
                  if (value.isNotEmpty) {
                    ResidenceCreationModelBuilder().miniature = value.first;
                    ResidenceCreationModelBuilder().images.addAll(value);
                  }
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          // CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
          CreationResidenceNavigation.goToPage(
              pageName: LogmentLocationPage.name);
        },
        onNext: ResidenceCreationModelBuilder().images.isNotEmpty
            ? () async {
                CreationResidenceNavigation.goToPage(
                    pageName: VideoLogmentPage.name);
                //CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
              }
            : null,
      ),
    );
  }
}
