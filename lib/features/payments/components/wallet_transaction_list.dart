import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_model.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/utils/enums.dart';
import 'package:immoplus_pro/features/payments/utils/payments_utils.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class WalletTransactionList extends StatefulWidget {
  const WalletTransactionList({super.key});

  @override
  State<WalletTransactionList> createState() => _WalletTransactionListState();
}

class _WalletTransactionListState extends State<WalletTransactionList> {
  late PagingController<int, TransactionModel> _pagingController;

  Future<void> loadPage(int page) async {
    WalletRepository.getTransactions(
      page: page,
      perPage: 10,
      orderBy: OrderByField.updatedAt.value,
      orderDir: OrderDir.desc.value,
      // where: {
      // '_where': [
      //   '{"_field": "paymentType", "_op": "eq", "_val": retrait}',
      //   '{"_field": "collection", "_op": "eq", "_val": retrait}',
      // ],
      // },
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
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          //      backgroundColor: Colors.white,
          // color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            _pagingController.refresh();
            if (context.read<WalletCubit>().state is! REQUEST_INITIAL) {
              context.read<WalletCubit>().onGetWallet();
            }
          },
        ),
        const SliverGap(10),
        PagedSliverList<int, TransactionModel>(
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
                          titleTextStyle: Theme.of(context).textTheme.bodyLarge,
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
                      // showModalBottomSheet(
                      //   backgroundColor: AppColors.scafold,
                      //   showDragHandle: true,
                      //   enableDrag: true,
                      //   isScrollControlled: true,
                      //   useRootNavigator: true,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   context: context,
                      //   builder: (context) => SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.85,
                      //     child: (item.collection ==
                      //             ServicesCollection.reservations.name)
                      //         ? BookingDetailPage(
                      //             id: item.itemId,
                      //           )
                      //         : VisitDetailPage(
                      //             id: item.itemId,
                      //           ),
                      //   ),
                      // );
                    },
                    tileColor: AppColors.scafold,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                    leading: CircleAvatar(
                      foregroundImage: (item.operator.toString().isNotEmpty)
                          ? NetworkImage(
                              OrderPaymentController.getLogoURL(
                                item.operator.toString(),
                              ),
                            )
                          : null,
                      child: getIconStatus(status: item.type.toString()),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: item.source.toString() != 'null',
                          child: AutoSizeText(getTransactionTitle(item),
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        const Gap(3),
                        Visibility(
                          visible: item.sourceId.toString() != 'null',
                          child: SelectableText(item.sourceId.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.purple,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold)),
                        ),

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
                        "${CurrencyFormatter.format(item.amount!.toInt().toString())} ${item.currency} "
                        // item.type == WalletPaymentType.CREDIT.name
                        //     ? " + ${CurrencyFormatter.format(item.amount!.toInt().toString())} F"
                        //     : "- ${CurrencyFormatter.format(item.amount!.toInt().toString())} F",
                        ),
                    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                    subtitleTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                getColorStatus(status: item.type.toString())),
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
                          // Flexible(
                          //   child: Chip(
                          //     avatar:
                          //         getIconStatus(status: item.status.toString()),
                          //     backgroundColor: getColorStatus(
                          //         status: item.status.toString()),
                          //     label: Text(getPaymentStatusName(
                          //         status: item.status.toString())),
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              ),
            )),
      ],
    );
  }
}
