import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/views/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/views/place/widgets/image_logment_viewer.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final List<XFile> _images = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          Visibility(
            visible: _images.isNotEmpty,
            replacement: const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  FontAwesomeIcons.photoFilm,
                  size: 100,
                  color: Colors.grey,
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
                    offset: const Offset(-10, 0),
                    largeSize: 30,
                    label: GestureDetector(
                      onTap: () {
                        setState(() {
                          _images.removeAt(index);
                        });
                      },
                      child: const Icon(
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
          const SliverToBoxAdapter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_photo_alternate_outlined),
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
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
        child: ElevatedButton.icon(
            onPressed: () async {
              CustomPopup.showLoagingToast(text: "Envoie des images");
              List<String> imagesSended = [];
              for (var element in _images) {
                FileDataModel response =
                    await AuthRepository.uplaodFile(file: File(element.path));

                if (response.data != null) {
                  imagesSended.add(response.data!.id ?? "");
                  if (EstateCreationModelBuilder().miniature.isEmpty) {
                    EstateCreationModelBuilder().miniature = response.data!.id!;
                  }
                }
              }
              EasyLoading.dismiss();
              context.pop<List<String>>(imagesSended);
            },
            icon: const Icon(FontAwesomeIcons.cloudArrowUp),
            label: const Text('Envoyer les images')),
      ),
    );
  }
}
