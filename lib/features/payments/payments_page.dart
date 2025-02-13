import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/data/models/payment/payment_itent_data.dart';
import 'package:immoplus_pro/data/repositories/payment_repository.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/booking/booking_detail_page.dart';
import 'package:immoplus_pro/features/payments/components/wallet_indicator.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdrawable_booking_page.dart';
import 'package:immoplus_pro/features/visits/visit_detail_page.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});
  static String name = 'PaymentsPage';

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

Widget getIconStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    );
  } else if (status == PaymentStatus.pending.name) {
    return const Icon(
      Icons.access_time_filled,
      color: Colors.grey,
    );
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return const Icon(
      Icons.access_time_filled,
      color: Colors.grey,
    );
  } else if (status == PaymentStatus.action_required.name) {
    return const Icon(
      Icons.timer,
      color: Colors.orange,
    );
  } else if (status == PaymentStatus.payment_required.name) {
    return const Icon(
      Icons.payments_outlined,
      color: Colors.purple,
    );
  } else if (status == PaymentStatus.failed.name) {
    return const Icon(
      Icons.close,
      color: Colors.red,
    );
  } else if (status == PaymentStatus.processing.name) {
    return const Icon(
      Icons.rocket_launch_outlined,
      color: Colors.blue,
    );
  } else if (status == PaymentStatus.paye.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  }
  return const Icon(Icons.close, color: Colors.red);
}

Color getColorStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return Colors.green.shade100;
  } else if (status == PaymentStatus.pending.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.action_required.name) {
    return Colors.orange.shade100;
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.payment_required.name) {
    return Colors.purple.shade100;
  } else if (status == PaymentStatus.failed.name) {
    return Colors.red.shade100;
  } else if (status == PaymentStatus.processing.name) {
    return Colors.blue.shade100;
  } else if (status == PaymentStatus.paye.name) {
    return Colors.green.shade100;
  }
  return Colors.red.shade200;
}

String getPaymentStatusName({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return "Effectué";
  } else if (status == PaymentStatus.pending.name) {
    return "En attente";
  } else if (status == PaymentStatus.waiting_for_validation.name) {
    return "En attente";
  } else if (status == PaymentStatus.action_required.name) {
    return "Action requise";
  } else if (status == PaymentStatus.payment_required.name) {
    return "Paiement requis";
  } else if (status == PaymentStatus.failed.name) {
    return "Échoué";
  } else if (status == PaymentStatus.processing.name) {
    return "En cours";
  } else if (status == PaymentStatus.paye.name) {
    return "Payé";
  }
  return "Échoué";
}

late PagingController<int, PaymentItentData> _pagingController;
Future<void> loadPage(int page) async {
  PaymentRepository.getPayments(
    page: page,
    perPage: 10,
    orderBy: 'updatedAt',
    orderDir: 'desc',
    // where: {
    //   '_where': [
    //     '{"_field": "paymentType", "_op": "eq", "_val": retrait}',
    //   ],
    // },
  ).then((value) {
    if (value.hasNext == true) {
      _pagingController.appendPage(value.data ?? [], (value.currentPage)! + 1);
    } else {
      _pagingController.appendLastPage(value.data ?? []);
    }
    //change(value, status: RxStatus.success());
  }).onError((error, stackTrace) {
    _pagingController.error = error.toString();
  });
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const AutoSizeText(
              'Paiements réservation',
              maxLines: 1,
            ),
            centerTitle: false,
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            backgroundColor: AppColors.whiteBackground,
            pinned: true,
            floating: true,
            snap: true,
            actions: const [
              Icon(
                FontAwesomeIcons.moneyBills,
                color: Colors.green,
              ),
              Gap(20),
            ],
          ),
          CupertinoSliverRefreshControl(
            //      backgroundColor: Colors.white,
            // color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              _pagingController.refresh();
              if (context.read<WalletCubit>().state is! REQUEST_INITIAL) {
                context.read<WalletCubit>().onGetBookingPaymentHistory();
              }
            },
          ),
          const WalletIndicator(),
          const SliverGap(10),
          PagedSliverList<int, PaymentItentData>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        period: const Duration(milliseconds: 500),
                        child: ListTile(
                            tileColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29)),
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(
                                  OrderPaymentController.selectedOperator.logo),
                            ),
                            title: const Text(
                              '•••••••••••••••',
                            ),
                            subtitle: const Text(
                              "••••• F",
                            ),
                            titleTextStyle:
                                Theme.of(context).textTheme.bodyLarge,
                            subtitleTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                            trailing: Chip(
                              avatar: getIconStatus(
                                  status: PaymentStatus.failed.name),
                              backgroundColor: getColorStatus(
                                  status: PaymentStatus.failed.name),
                              label: const Text('En attente'),
                            )),
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
                      const Gap(20),
                      SvgPicture.asset(
                        "assets/svgs/undraw/6.svg",
                        width: 200,
                      ),
                      const Gap(30),
                      Text(
                        "Aucun Paiement Disponible Pour le Moment",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Gap(20),
                      const Text(
                        "Votre tableau de bord est prêt à afficher les paiements de vos réservations. Assurez-vous que vos résidences sont correctement ajoutées pour commencer à recevoir des paiements !",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8)
                      .copyWith(bottom: 10),
                  child: ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.scafold,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: (item.collection ==
                                    ServicesCollection.reservations.name)
                                ? BookingDetailPage(
                                    id: item.itemId,
                                  )
                                : VisitDetailPage(
                                    id: item.itemId,
                                  ),
                          ),
                        );
                      },
                      tileColor: AppColors.scafold,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29)),
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                            OrderPaymentController.getLogoURL(
                                item.paymentMethod)),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(Utils.getServiceName(item.collection)),
                          const Gap(3),
                          AutoSizeText(item.paymentAddress.toString()),
                          // SelectableText(
                          //   style:
                          //       Theme.of(context).textTheme.bodySmall!.copyWith(
                          //             color: Colors.purple,
                          //           ),
                          //   onTap: () {
                          //     Clipboard.setData(ClipboardData(text: item.id))
                          //         .then((value) {
                          //       Vibrate.feedback(FeedbackType.impact);
                          //       EasyLoading.showToast('Identifiant copié');
                          //     }).catchError((err) {
                          //       EasyLoading.showToast(err.toString());
                          //     });
                          //   },
                          //   item.itemId,
                          // ),
                        ],
                      ),
                      subtitle: Text(
                        "- ${CurrencyFormatter.format(item.amountNoFees.toInt().toString())} F",
                      ),
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                      subtitleTextStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.red),
                      trailing: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: AutoSizeText(
                                  Utils.formatDate(dateTime: item.updatedAt!)),
                            ),
                            Flexible(
                              child: Chip(
                                avatar:
                                    getIconStatus(status: item.paymentStatus),
                                backgroundColor:
                                    getColorStatus(status: item.paymentStatus),
                                label: Text(getPaymentStatusName(
                                    status: item.paymentStatus)),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
