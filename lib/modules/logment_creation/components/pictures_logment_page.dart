import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logement_location_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/video_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/views/place/widgets/image_logment_viewer.dart';

class PicturesLogmentPage extends StatefulWidget {
  const PicturesLogmentPage({super.key});
  static String name = "pictures_logment_page";

  @override
  State<PicturesLogmentPage> createState() => _PicturesLogmentPageState();
}

class _PicturesLogmentPageState extends State<PicturesLogmentPage> {
  List<XFile> _images = [];
  @override
  void initState() {
    super.initState();
    PregressStepperLogmentCreating.setStepe(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperLogmentCreating(),
            ),
          ),
          Visibility(
            visible: _images.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DottedBorder(
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  color: CupertinoColors.systemGrey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.photoFilm,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Gap(10),
                      Text(
                        "Capturez la beauté de votre logement ! Prenez des photos soigneusement travaillées pour attirer davantage de clients. N'oubliez pas, la première image sélectionnée sera celle affichée en miniature.",
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
                  return Badge(
                    backgroundColor: Colors.red,
                    offset: Offset(-10, 0),
                    largeSize: 30,
                    label: GestureDetector(
                      onTap: () {
                        setState(() {
                          _images.removeAt(index);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageLogmentViewer(
                                imagePath: _images[index].path,
                                tag: _images[index].name,
                              ),
                            ));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Image.file(
                          height: double.infinity,
                          width: double.infinity,
                          File(_images[index]
                              .path), // L'image chargée depuis le Future<File>
                          fit: BoxFit.cover, // Ajustement de l'image
                        ),
                      ),
                    ),
                  );
                },
                childCount: _images.length,
              ),
            ),
          ),
          SliverToBoxAdapter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add_photo_alternate_outlined),
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          await picker.pickMultiImage(imageQuality: 60).then(
                (value) => value.forEach((element) {
                  setState(() {
                    _images.add(element);
                  });
                }),
                // Pick multiple images.
              );
        },
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
        },
        onNext: _images.isNotEmpty
            ? () async {
                EasyLoading.show(status: "Envoie des images");

                for (var element in _images) {
                  FileDataModel response =
                      await AuthRepository.uplaodFile(file: File(element.path));
                  if (response.data != null) {
                    ResidenceCreationModelBuilder()
                        .images
                        .add(response.data!.id ?? "");
                    if (ResidenceCreationModelBuilder().miniature.isEmpty) {
                      ResidenceCreationModelBuilder().miniature =
                          response.data!.id!;
                    }
                  }
                }

                EasyLoading.dismiss();
                log(ResidenceCreationModelBuilder().images.toString(),
                    name: 'IMAGES');
                CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
              }
            : null,
      ),
    );
  }
}
