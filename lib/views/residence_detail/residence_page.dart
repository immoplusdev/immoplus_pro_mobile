import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/views/residence_detail/components/detail_divider.dart';
import 'package:immoplus_pro/views/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus_pro/views/residence_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/views/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/views/residence_detail/components/logment_bottom_bar.dart';
import 'package:immoplus_pro/views/residence_detail/components/see_more_button.dart';
import 'package:immoplus_pro/views/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/views/shared_widgets/loading_page.dart';
import 'package:video_player/video_player.dart';

import 'components/detail_logment_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_available_day.dart';
import 'components/detail_logment_infos.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';
import 'components/detail_rules.dart';

class ResidencePage extends StatefulWidget {
  const ResidencePage({
    Key? key,
    required this.idProduct,
  }) : super(key: key);

  final String idProduct;
  static String name = 'logment_page';
  @override
  State<ResidencePage> createState() => _ResidencePageState();
}

class _ResidencePageState extends State<ResidencePage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    context.read<LogmentCubit>().getResidence(id: widget.idProduct);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    () async {}();
    print('dispose');
    //DataProvider().stopRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogmentCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return LoadingPage();
        }

        if (state is REQUEST_RESIDENCE_DATA) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailLogmentAppBar(logmentModel: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context
                        .read<LogmentCubit>()
                        .getResidence(id: widget.idProduct);
                  },
                ),
                //productName
                DetailLogmentName(residenceModel: state.data),
                DetailLogmentRooms(logmentModel: state.data),
                //product adress
                DetailLogmentInfos(reservation: state.data),
                //réservation offers
                DetailDivider(),
                DetailLogmentTitle2(title: 'Ce que propose ce logement'),
                //offer list
                DetailLogmentAmentities(residenceModel: state.data),
                SliverGap(10),
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
                              children: state.data.commodites!
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
                                        title: Text(e.text!),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )),
                        );
                      },
                      child: Text(
                          "Voir tout les ${state.data.commodites!.length} commodités"),
                    ),
                  ),
                ),
                DetailDivider(),
                //vidéo section
                DetailLogmentVideo(logmentModel: state.data),
                //description next
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Colors.white,
                    height: 100,
                    child: Markdown(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      data: state.data.description ??
                          '', //state.finishData.data!.description!,
                      //styleSheet: MarkdownStyleSheet(),
                    ),
                  ),
                ),
                SeeMoreButton(
                  text: state.data.description!,
                ),

                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     childCount: 4,
                //     (context, index) => SizedBox(
                //       height: 30,
                //       child: ListTile(
                //         horizontalTitleGap: 0,
                //         leading: Icon(Icons.child_care_outlined),
                //         title: Text('Convient aux bébés (moins de 2 ans)'),
                //       ),
                //     ),
                //   ),
                // ),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10),
                //     child: OutlinedButton(
                //       onPressed: () {},
                //       child: Text("Voir toutes les informations"),
                //     ),
                //   ),
                // ),
                DetailDivider(),
                DetailLogmentTitle2(title: 'Jours disponibles'),
                DetailLogmentAvailableDay(
                  reservation: state.data,
                ),

                //indformation supplementaire
                SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverToBoxAdapter(child: Gap(20)),
                DetailDivider(),
                DetailLogmentTitle2(title: 'Où se situe le logement'),
                DetailLogmentMap(residence: state.data),
                DetailDivider(),
                SliverGap(10),
                DetailLogmentTitle2(title: 'Règles de la maison'),
                DetailLogmentRules(logmentModel: state.data),

                //DetailLogmentTitle2(title: 'Voir aussi'),
                //SliverToBoxAdapter(child: SimilarProductSection()),
                SliverToBoxAdapter(child: Gap(15)),
              ],
            ),
            bottomNavigationBar: LogmentBottomBar(
              logmentModel: state.data,
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
