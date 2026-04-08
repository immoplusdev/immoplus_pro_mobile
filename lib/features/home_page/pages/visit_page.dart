import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/features/home_page/widgets/visit_card.dart';
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
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
      // where: {
      //   '_where': [
      //     '{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
      //   ],
      // },
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
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
              context.read<WalletCubit>().onGetWallet();
            },
          ),
          const SliverGap(15),
          PagedSliverList<int, DemandeVisiteModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10),
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
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(80),
                  SvgPicture.asset(
                    "assets/svgs/undraw/5.svg",
                    width: 200,
                  ),
                  const Gap(30),
                  Text(
                    "Aucune demande de visite pour le Moment",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(20),
                  const Text(
                    "Votre tableau de bord est prêt à accueillir vos prochaines demandes de visites. Ajoutez vos bien dès maintenant pour commencer à recevoir des demandes !",
                    textAlign: TextAlign.center,
                  ),
                  Gap(20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: _tapCreateEstate,
                    child: Text('Ajouter un bien'),
                  ),
                ],
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

  _tapCreateEstate() async {
    EstateCreationModelBuilder().reset();
    final result = await AppRouter.router.pushNamed(CreateEstatePage.name);
    if (result == true && mounted) {
      AppRouter.router.pushNamed(EstatesPage.name);
    }
  }
}
