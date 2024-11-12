import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/views/home_page/widgets/visit_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});
  static String name = 'VISIT_PAGE';
  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  final PagingController<int, DemandeVisiteModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> loadPage(int page) async {
    BienImmobilierRepository.getVisitesOwner(
      id: SessionManager().currentUser!.userId.toString(),
      page: page,
      perPage: 5,
      where: {
        '_where': [
          '{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
        ],
      },
    ).then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data ?? [], (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
      }
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
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          PagedSliverList<int, DemandeVisiteModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                    //height: 600,
                    child: Column(
                  children: List.generate(
                    20,
                    (index) => const BookingLoadingCard(),
                  ),
                )),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                "Aucune demande de visite",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              itemBuilder: (context, item, index) => VisitCard(
                demandeVisiteModel: item,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
