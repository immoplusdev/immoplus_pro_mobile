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
import 'package:immoplus_pro/features/payments/components/withdrawal_request_item_tile.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/utils/payments_utils.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

PagingController<int, WithdrawalRequestModel> pagingControllerWidrawalList =
    PagingController(firstPageKey: 1);

class WithdrawalRequestList extends StatefulWidget {
  const WithdrawalRequestList({super.key});

  @override
  State<WithdrawalRequestList> createState() => _WithdrawalRequestListState();
}

class _WithdrawalRequestListState extends State<WithdrawalRequestList> {
  Future<void> loadPage(int page) async {
    WalletRepository.getWithdrawalRequest(
      page: page,
      perPage: 10,
      orderBy: OrderByField.updatedAt.value,
      orderDir: OrderDir.desc.value,
    ).then((value) {
      if (value.hasNext == true) {
        pagingControllerWidrawalList.appendPage(
            value.data ?? [], (value.currentPage)! + 1);
      } else {
        pagingControllerWidrawalList.appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      pagingControllerWidrawalList.error = error.toString();
    });
  }

  @override
  void initState() {
    pagingControllerWidrawalList = PagingController(firstPageKey: 1);
    pagingControllerWidrawalList.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pagingControllerWidrawalList.dispose();
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
            pagingControllerWidrawalList.refresh();
            if (context.read<WalletCubit>().state is! REQUEST_INITIAL) {
              context.read<WalletCubit>().onGetWallet();
            }
          },
        ),
        const SliverGap(10),
        PagedSliverList<int, WithdrawalRequestModel>(
            pagingController: pagingControllerWidrawalList,
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
                                      OrderPaymentController
                                          .selectedOperator.logo),
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
                            "Aucune Demande de Retrait Pour le Moment",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Gap(20),
                          const Text(
                            "Votre tableau de bord est prêt à afficher les demandes de retrait. Assurez-vous que votre solde est suffisant pour initier un retrait.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                itemBuilder: (context, item, index) {
                  return WithdrawalRequestItemTile(item: item);
                  return Padding(
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
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
                          child: FaIcon(FontAwesomeIcons.coins,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText("Retrait par ${item.operator}"),
                            const Gap(3),
                            AutoSizeText(
                                PhoneNumberHandler.formatPhoneNumber(
                                    item.phoneNumber.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    )),
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
                          "- ${CurrencyFormatter.format(item.amount!.toInt().toString())} F",
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
                                child: AutoSizeText(Utils.formatDate(
                                    dateTime: item.updatedAt!)),
                              ),
                              Flexible(
                                child: Chip(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 0),
                                  avatar: getIconStatus(
                                      status: item.status.toString()),
                                  avatarBoxConstraints: BoxConstraints(),
                                  backgroundColor: getColorStatus(
                                      status: item.status.toString()),
                                  label: Text(
                                    getPaymentStatusName(
                                      status: item.status.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                })),
      ],
    );
  }
}
