import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/features/residence/widgets/loading_logment_list_card.dart';
import 'package:immoplus_pro/features/residence/widgets/residence_list_card.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResidencesPage extends StatefulWidget {
  const ResidencesPage({super.key});
  static String name = 'logment_page';

  static String routePath() => '/logment_page';

  static String route() {
    return '/logment_page';
  }

  @override
  State<ResidencesPage> createState() => _ResidencesPageState();
}

class _ResidencesPageState extends State<ResidencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);
  final sessionManager = getIt<SessionManager>();
  final GlobalKey _shareButtonKey = GlobalKey();
  Future<void> loadPage(int page) async {
    LogmentRepository.getResidences(
      page: page,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
    ).then((value) {
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

  bool _hasItems = false;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });

    _pagingController.addListener(() {
      final hasItems = _pagingController.itemList?.isNotEmpty == true;
      if (_hasItems != hasItems) {
        setState(() {
          _hasItems = hasItems;
        });
      }
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            context.goNamed(HomePageV2.name);
          },
        ),
        backgroundColor: AppColors.whiteBackground,
        title: const Text('Mes résidences'),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        actions: [
          // InputChip(
          //   backgroundColor: AppColors.primary.withOpacity(0.8),
          //   label: const Text('Ajouter résidence'),
          //   labelStyle: Theme.of(context)
          //       .textTheme
          //       .bodySmall!
          //       .copyWith(color: Colors.white),
          //   avatar: const Icon(
          //     FontAwesomeIcons.buildingUser,
          //     size: 15,
          //     color: Colors.white,
          //   ),
          //   deleteIcon: const Icon(
          //     CupertinoIcons.chevron_right_circle_fill,
          //     size: 15,
          //     color: Colors.white,
          //   ),
          //   labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          //   onDeleted: () {},
          //   onPressed: _tapCreateResidence,
          // ),
          IconButton(
            onPressed: () async {
              // Code for the placeholder:
              final String shareUrl =
                  'https://app.immoplus.ci/user_residences/${sessionManager.currentUser?.userId}  ';

              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareText(
                  text: 'Découvrez mes résidences sur ImmoPlus\n$shareUrl',
                  subject: 'Partager mes résidences ImmoPlus',
                  sharePositionOrigin: origin);
            },
            icon: FaIcon(
              key: _shareButtonKey,
              FontAwesomeIcons.shareNodes,
              color: AppColors.primary,
            ),
          ),
          const Gap(7),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          const SliverGap(10),
          PagedSliverList<int, ResidenceModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  //height: 600,
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => const LoadingLogmentListCard(),
                    ),
                  ),
                ),
              ),
              noItemsFoundIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(100),
                    SvgPicture.asset(
                      "assets/svgs/undraw/house.svg",
                      width: 200,
                    ),
                    const Gap(30),
                    Text(
                      "Aucune résidence trouvée",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(30),
                    const Text(
                      "Vous n’avez pas encore ajouté de résidence sur ImmoPlus. Co  mmencez dès maintenant en ajoutant vos biens selon les critères requis.",
                      textAlign: TextAlign.center,
                    ),
                    Gap(20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: _tapCreateResidence,
                      child: Text('Ajouter une résidence'),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context, item, index) => ResidenceListCard(
                residence: item,
                onTap: () async {
                  await context
                      .push('/${ResidenceDetailsPage.name}/${item.id}');
                  _pagingController.refresh();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: (_hasItems)
          ? FloatingActionButton.extended(
              onPressed: _tapCreateResidence,
              backgroundColor: AppColors.primary,
              icon: const Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              label: const Text('Ajouter une résidence'),
            )
          : null,
    );
  }

  _tapCreateResidence() async {
    ResidenceCreationModelBuilder().reset();
    final result = await context.pushNamed(CreateLodgmentPage.name);
    if (result == true && mounted) {
      _pagingController.refresh();
    }
  }
}
