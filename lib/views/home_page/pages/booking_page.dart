import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/home_page/widgets/booking_card.dart';
import 'package:immoplus_pro/views/home_page/widgets/booking_loading_card.dart';
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
      orderBy: 'createdAt',
      orderDir: 'desc',
      where: '{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
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
      backgroundColor: AppColors.scafold,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          // SliverPadding(
          //   padding: EdgeInsets.symmetric(horizontal: 8),
          //   sliver: SliverToBoxAdapter(
          //     child: ListTile(
          //       leading: const CircleAvatar(
          //         backgroundColor: Colors.transparent,
          //         radius: 20,
          //         child: Icon(FontAwesomeIcons.coins),
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       horizontalTitleGap: 3,
          //       tileColor: Colors.white,
          //       title: const Text('Total des gains'),
          //       subtitle: Text(
          //         Utils.formatCurrency(500000000),
          //       ),
          //       subtitleTextStyle: Theme.of(context)
          //           .textTheme
          //           .headlineSmall!
          //           .copyWith(color: AppColors.primary),
          //       titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          //       trailing: IconButton(
          //         icon: const Icon(
          //           FontAwesomeIcons.eye,
          //         ),
          //         onPressed: () {},
          //       ),
          //     ),
          //   ),
          // ),
          // const SliverToBoxAdapter(
          //   child: Divider(),
          // ),
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
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                "Aucune réservation",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              itemBuilder: (context, item, index) => BookingCard(
                reservationModel: item,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
