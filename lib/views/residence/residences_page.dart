import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/views/home_page/home_page.dart';
import 'package:immoplus_pro/views/residence/widgets/loading_logment_list_card.dart';
import 'package:immoplus_pro/views/residence/widgets/logment_list_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResidencesPage extends StatefulWidget {
  const ResidencesPage({super.key});
  static String name = 'logment_page';
  @override
  State<ResidencesPage> createState() => _ResidencesPageState();
}

class _ResidencesPageState extends State<ResidencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> loadPage(int page) async {
    LogmentRepository.getResidences(
            page: page, orderBy: 'createdAt', orderDir: 'desc')
        .then((value) {
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
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            context.goNamed(HomePage.name);
          },
        ),
        backgroundColor: AppColors.scafold,
        title: const Text('Mes résidences'),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        actions: [
          InputChip(
            backgroundColor: AppColors.primary.withOpacity(0.8),
            label: const Text('Ajouter résidence'),
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
            labelPadding: const EdgeInsets.symmetric(horizontal: 2),
            onDeleted: () {},
            onPressed: () {
              ResidenceCreationModelBuilder().reset();
              context.pushNamed(CreateLodgmentPage.name);
            },
          ),
          const Gap(7),
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
