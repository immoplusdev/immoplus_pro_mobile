import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_card.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum BookingSection { in_progress, visit, withdrew }

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});
  static String name = 'BOOKING_PAEG';
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final PagingController<int, ReservationModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> loadPage(int page) async {
    LogmentRepository.getReservationsOwner(
      id: SessionManager().currentUser!.userId.toString(),
      page: page,
      perPage: 5,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
      where: {
        '_where': [
          //'{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
          '{"_field": "statusFacture", "_op": "eq", "_val": "paye"}',
          //'{"_field": "dateReservation", "_op": "gt", "_val": "${DateTime.now().toIso8601String()}"}',
        ],
      },
    ).then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data, (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data);
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

  // @override
  // void initState() {
  //   context.read<BookingCubit>().getBookings();
  //   super.initState();
  // }

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
          PagedSliverList<int, ReservationModel>(
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
              noItemsFoundIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(80),
                    SvgPicture.asset(
                      "assets/svgs/undraw/4.svg",
                      width: 200,
                    ),
                    const Gap(30),
                    Text(
                      "Aucune Réservation Pour le Moment",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(20),
                    const Text(
                      "Votre tableau de bord est prêt à accueillir vos prochaines réservations. Ajoutez vos résidences dès maintenant pour commencer à recevoir des demandes !",
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
              itemBuilder: (context, item, index) => BookingCard(
                reservationModel: item,
              ),
            ),
          ),
        ],
      )),
    );
  }

  _tapCreateResidence() async {
    final result = await AppRouter.router.pushNamed(CreateLodgmentPage.name);
    if (result == true && mounted) {
      AppRouter.router.pushNamed(ResidencesPage.name);
    }
  }
}
