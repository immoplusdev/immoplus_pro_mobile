import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/views/residence/widgets/loading_logment_list_card.dart';
import 'package:immoplus_pro/views/residence/widgets/logment_list_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class residencesPage extends StatefulWidget {
  const residencesPage({super.key});
  static String name = 'logment_page';
  @override
  State<residencesPage> createState() => _residencesPageState();
}

class _residencesPageState extends State<residencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);

  void _launchURL() async {
    final Uri url = Uri.parse("${RequestPath.baseUrl}/admin/content/logements");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> loadPage(int page) async {
    LogmentRepository.getResidences(page: page).then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(
            value.data ?? [], (value.currentPage)! + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      _pagingController.error = error.toString();
    });
  }

  // Future<void> loadPage(int page) async {
  //   List<LogmentModel> newDatas =
  //       await Repository<LogmentModel>(LogmentModel()).fetchListData(
  //           requestInfo: galleryAdapter.getLogments(
  //             path: RequestPath.logments,
  //             limit: 3,
  //             page: page,
  //           ),
  //           context: context) as List<LogmentModel>;
  //   inspect(newDatas);
  //   final isLastPage = newDatas.length < _limit;
  //   if (isLastPage) {
  //     _pagingController.appendLastPage(newDatas);
  //   } else {
  //     int nextPageKey = page + newDatas.length;
  //     _pagingController.appendPage(newDatas, nextPageKey);
  //   }
  // }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
        title: Text('Mes logements'),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        actions: [
          InputChip(
            backgroundColor: AppColors.primary.withOpacity(0.8),
            label: Text('Ajouter logement'),
            labelStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
            avatar: const Icon(
              FontAwesomeIcons.buildingUser,
              size: 15,
              color: Colors.white,
            ),
            deleteIcon: const Icon(
              CupertinoIcons.chevron_right_circle_fill,
              size: 15,
              color: Colors.white,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 2),
            onDeleted: () {},
            onPressed: () {
              // _launchURL();
              context.pushNamed(CreateLodgmentPage.name);
            },
          ),
          Gap(7),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          PagedSliverList<int, ResidenceModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                    //height: 600,
                    child: Column(
                  children: [
                    for (int _i = 0; _i < 5; _i++) LoadingLogmentListCard(),
                  ],
                )),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                "Aucun élément trouvé",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              itemBuilder: (context, item, index) => ResidenceListCard(
                residence: item,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
