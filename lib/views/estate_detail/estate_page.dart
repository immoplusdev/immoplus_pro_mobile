import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/views/estate_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/views/estate_detail/components/estate_bottom_bar.dart';
import 'package:immoplus_pro/views/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/views/residence_detail/components/detail_divider.dart';
import 'package:immoplus_pro/views/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus_pro/views/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/views/residence_detail/components/see_more_button.dart';
import 'package:immoplus_pro/views/shared_widgets/loading_page.dart';
import 'package:video_player/video_player.dart';

import 'components/detail_estate_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_infos.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';

class EstatePage extends StatefulWidget {
  const EstatePage({
    super.key,
    required this.idProduct,
  });

  final String idProduct;
  static String name = 'estate_page';
  @override
  State<EstatePage> createState() => _EstatePageState();
}

class _EstatePageState extends State<EstatePage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    context.read<EstateCubit>().getEstate(id: widget.idProduct);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    () async {}();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstateCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_BIEN_IMMOBILIER_DATA) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailEstateAppBar(bienImmobilier: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context.read<EstateCubit>().getEstate(id: widget.idProduct);
                  },
                ),
                //productName
                DetailEstateName(bienImmobilier: state.data),
                DetailEstateRooms(bienImmobilier: state.data),
                //product adress
                DetailEstateInfos(bienImmobilier: state.data),
                //réservation offers
                const DetailDivider(),
                const DetailLogmentTitle2(title: 'Ce que propose ce logement'),
                //offer list
                DetailEstateAmentities(bienImmobilier: state.data),
                const SliverGap(10),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary)),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.scafold,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => Container(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: state.data.amentities
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: SvgPicture.asset(
                                            SVGMap.map[e.icon] ?? '',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        tileColor: Colors.white,
                                        title: Text(e.text),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )),
                        );
                      },
                      child: Text(
                          "Voir tout les ${state.data.amentities.length} commodités"),
                    ),
                  ),
                ),
                const DetailDivider(),
                //vidéo section
                DetailEstateVideo(bienImmobilier: state.data),
                //description next
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    color: Colors.white,
                    height: 100,
                    child: Markdown(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      data: state.data.description ??
                          '', //state.finishData.data!.description!,
                      //styleSheet: MarkdownStyleSheet(),
                    ),
                  ),
                ),
                SeeMoreButton(
                  text: state.data.description,
                ),

                const DetailDivider(),
                const DetailLogmentTitle2(title: 'Où se situe le logement'),
                DetailEstateMap(bienImmobilier: state.data),
                const DetailDivider(),
                const SliverGap(10),
                const DetailLogmentTitle2(title: 'Règles de la maison'),

                const SliverToBoxAdapter(child: Gap(15)),
              ],
            ),
            bottomNavigationBar: EstateBottomBar(
              bienImmobilier: state.data,
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
