import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/commune_model.dart';
import 'package:immoplus_pro/data/repositories/config_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommuneSelectorPage extends StatefulWidget {
  const CommuneSelectorPage({super.key});

  @override
  State<CommuneSelectorPage> createState() => _CommuneSelectorPageState();
}

class _CommuneSelectorPageState extends State<CommuneSelectorPage> {
  final PagingController<int, CommuneModel> _pagingController =
      PagingController(firstPageKey: 1);
  Future<void> loadPage(int page) async {
    ConfigRepository.getCommunes(page: page, perPage: 5).then((value) {
      if (!mounted) return;
      try {
        if (value.hasNext == true) {
          _pagingController.appendPage(value.data, (value.currentPage) + 1);
        } else {
          _pagingController.appendLastPage(value.data);
        }
      } catch (_) {}
    }).onError((error, stackTrace) {
      if (!mounted) return;
      try {
        _pagingController.error = error.toString();
      } catch (_) {}
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          const SliverAppBar(
            title: Text('Sélectionner une commune'),
            //backgroundColor: AppColors.scafold,
            centerTitle: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              if (!mounted) return;
              _pagingController.refresh();
            },
          ),
          PagedSliverList<int, CommuneModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                "Aucun élément trouvé",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(FontAwesomeIcons.treeCity),
                  tileColor: AppColors.scafold,
                  title: Text(item.name),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  onTap: () {
                    context.pop<CommuneModel>(item);
                  },
                  trailing: Icon(
                    FontAwesomeIcons.circleArrowRight,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
