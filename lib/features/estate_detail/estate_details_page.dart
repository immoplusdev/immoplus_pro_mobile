import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/estate_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/detail_action_bottom_bar.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_divider.dart';
import 'package:immoplus_pro/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus_pro/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/features/residence_detail/components/see_more_button.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:video_player/video_player.dart';

import 'components/detail_estate_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_infos.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';

class EstateDetailsPage extends StatefulWidget {
  const EstateDetailsPage({
    super.key,
    required this.idProduct,
  });

  final String idProduct;
  static String name = 'estate_details_page';

  static String routePath() => '/estate_details_page/:id';

  static String route({String? id}) {
    return '/estate_details_page/$id';
  }

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    _getEstateById();
    super.initState();
  }

  _getEstateById() {
    context.read<EstateCubit>().getEstate(id: widget.idProduct);
  }

  void _onEdit(BienImmobilierModel bien) {
    EstateCreationModelBuilder().fromModel(bien);
    context.pushNamed(CreateEstatePage.name).then((result) {
      if (result == true && mounted) {
        EstateCreationModelBuilder().reset();
        context.read<EstateCubit>().getEstate(id: bien.id);
      }
    });
  }

  Future<void> _onDelete(BienImmobilierModel bien) async {
    final result = await AppDialog.confirmDialog(
      context: context,
      content:
          'Êtes-vous sûr de vouloir supprimer ce bien immobilier ? Cette action est irréversible.',
    );
    if (result == true && mounted) {
      context.read<EstateCubit>().deleteEstate(id: bien.id);
    }
  }

  Future<void> _onToggleAvailability(BienImmobilierModel bien) async {
    if (bien.bienImmobilierDisponible) {
      await AppDialog.confirm(
        context: context,
        content:
            'Les biens indisponibles ne seront pas accessibles aux clients pour effectuer des réservations.',
        rollback: () {
          context.read<EstateCubit>().updateEstate(
                id: bien.id,
                data: {'bienImmobilierDisponible': false},
              );
          context.pop();
        },
      );
    } else {
      context.read<EstateCubit>().updateEstate(
        id: bien.id,
        data: {'bienImmobilierDisponible': true},
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    () async {}();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EstateCubit, RequestState>(
      listener: (context, state) {
        if (state is REQUEST_SUCCESS) {
          ToastUtils.showSuccess(
              title: "Opération réussie", description: state.message);
          EstateCreationModelBuilder().reset();
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_BIEN_IMMOBILIER_DATA) {
          inspect(state.data);
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailEstateAppBar(bienImmobilier: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    _getEstateById();
                  },
                ),
                //productName
                DetailEstateName(bienImmobilier: state.data),
                DetailEstateRooms(bienImmobilier: state.data),
                //product adress
                DetailEstateInfos(bienImmobilier: state.data),
                //réservation offers
                // const DetailDivider(),
                // const DetailLogmentTitle2(title: 'Ce que propose ce logement'),
                // //offer list
                // DetailEstateAmentities(bienImmobilier: state.data),
                // const SliverGap(10),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: OutlinedButton(
                //       style: OutlinedButton.styleFrom(
                //           side: BorderSide(color: AppColors.primary)),
                //       onPressed: () {
                //         showModalBottomSheet(
                //           backgroundColor: AppColors.scafold,
                //           showDragHandle: true,
                //           enableDrag: true,
                //           isScrollControlled: true,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(20)),
                //           context: context,
                //           builder: (context) => Container(
                //               child: Padding(
                //             padding: const EdgeInsets.only(bottom: 20),
                //             child: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: state.data.amentities
                //                   .map(
                //                     (e) => Padding(
                //                       padding: const EdgeInsets.only(bottom: 5),
                //                       child: ListTile(
                //                         leading: CircleAvatar(
                //                           child: SvgPicture.asset(
                //                             SVGMap.map[e.icon] ?? '',
                //                             height: 20,
                //                             width: 20,
                //                           ),
                //                         ),
                //                         tileColor: Colors.white,
                //                         title: Text(e.text),
                //                       ),
                //                     ),
                //                   )
                //                   .toList(),
                //             ),
                //           )),
                //         );
                //       },
                //       child: Text(
                //           "Voir tout les ${state.data.amentities.length} commodités"),
                //     ),
                //   ),
                // ),
                // const DetailDivider(),
                //vidéo section
                // DetailEstateVideo(bienImmobilier: state.data),
                // //description next
                // SliverToBoxAdapter(
                //   child: Container(
                //     padding: const EdgeInsets.only(top: 5),
                //     color: Colors.white,
                //     height: 100,
                //     child: Markdown(
                //       physics: const NeverScrollableScrollPhysics(),
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       data: state.data.description ??
                //           '', //state.finishData.data!.description!,
                //       //styleSheet: MarkdownStyleSheet(),
                //     ),
                //   ),
                // ),
                // SeeMoreButton(
                //   text: state.data.description,
                // ),

                // const DetailDivider(),
                // const DetailLogmentTitle2(title: 'Où se situe le logement'),
                // DetailEstateMap(bienImmobilier: state.data),
                // const DetailDivider(),
                // const SliverGap(10),
                // const DetailLogmentTitle2(title: 'Règles de la maison'),

                const SliverToBoxAdapter(child: Gap(15)),
              ],
            ),
            bottomNavigationBar: DetailActionBottomBar(
              isInactive: !state.data.bienImmobilierDisponible,
              isUpdatingStatus: false,
              onEdit: () => _onEdit(state.data),
              onDelete: () => _onDelete(state.data),
              onToggleAvailability: () => _onToggleAvailability(state.data),
              config: const DetailActionBottomBarConfig(
                editLabel: 'Modifier le bien',
              ),
            ),
          );
        }

        return InitialDetailLogmentScreen(
          idProduct: widget.idProduct,
        );
      },
    );
  }
}
