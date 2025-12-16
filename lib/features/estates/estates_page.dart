import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page.dart';
import 'package:immoplus_pro/features/estates/widgets/bien_immobilier_list_card.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/residence/widgets/loading_logment_list_card.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';

class EstatesPage extends StatefulWidget {
  const EstatesPage({super.key});
  static String name = 'estate_page';
  @override
  State<EstatesPage> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage> {
  final sessionManager = getIt<SessionManager>();
  final PagingController<int, BienImmobilierModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> loadPage(int page) async {
    BienImmobilierRepository.getBiensImmobiliers(
      page: page,
      perPage: 5,
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            context.goNamed(HomePage.name);
          },
        ),
        title: const Text('Mes biens immobiliers'),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        actions: [
          IconButton(
            onPressed: () {
              // Code for the placeholder:
              final String shareUrl =
                  'https://app.immoplus.ci/user_estates/${sessionManager.currentUser?.userId}  ';
              Share.share(
                'Découvrez mes biens immobiliers sur ImmoPlus\n$shareUrl',
                subject: 'Partager mes biens immobiliers',
              );
            },
            icon: FaIcon(
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
          PagedSliverList<int, BienImmobilierModel>(
            addAutomaticKeepAlives: false,
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
                      "Aucune bien immobilier trouvés",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(30),
                    const Text(
                      "Vous n’avez pas encore ajouté de biens immobiliers sur ImmoPlus. Commencez dès maintenant en ajoutant vos biens selon les critères requis.",
                      textAlign: TextAlign.center,
                    ),
                    Gap(20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: _tapCreateEstate,
                      child: Text('Ajouter un bien immobilier'),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context, item, index) => BienImmoblierListCard(
                bienImmobilierModel: item,
                onTap: () async {
                  await context.push('/${EstateDetailsPage.name}/${item.id}');
                  _pagingController.refresh();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: (_pagingController.itemList?.isNotEmpty == true)
          ? FloatingActionButton.extended(
              onPressed: _tapCreateEstate,
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

  _tapCreateEstate() async {
    EstateCreationModelBuilder().reset();
    final result = await context.pushNamed(CreateEstatePage.name);
    if (result == true && mounted) {
      _pagingController.refresh();
    }
  }
}
