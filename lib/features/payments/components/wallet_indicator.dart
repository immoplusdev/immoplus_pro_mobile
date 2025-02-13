import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdrawable_booking_page.dart';
import 'package:immoplus_pro/utils/currency_formatter.dart';
import 'package:jumping_dot/jumping_dot.dart';

class WalletIndicator extends StatelessWidget {
  const WalletIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400, // Ombre douce
                  spreadRadius: 1, // L'étendue de l'ombre
                  blurRadius: 10, // Flou de l'ombre
                  offset: const Offset(0, 0), // Décalage horizontal et vertical
                ),
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<WalletCubit, RequestState>(
                    builder: (context, state) {
                      return (state is REQUEST_INITIAL)
                          ? AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              "•••••••••",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: AppColors.primary,
                                    wordSpacing: 10,
                                  ),
                            )
                          : Visibility(
                              visible: state is REQUEST_LOADING,
                              replacement: (state is BOOKING_WITHDRAW_HISTORY)
                                  ? AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      "${CurrencyFormatter.format(state.data.montantNonRetire.toString())} F",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(color: AppColors.primary),
                                    )
                                  : JumpingDots(
                                      innerPadding: 6,
                                      color: AppColors.primary,
                                      radius: 10,
                                      numberOfDots: 7,
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                    ),
                              child: JumpingDots(
                                innerPadding: 6,
                                color: AppColors.primary,
                                radius: 10,
                                numberOfDots: 7,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                              ),
                            );
                    },
                  ),
                  BlocBuilder<WalletCubit, RequestState>(
                    builder: (context, state) {
                      return (state is REQUEST_INITIAL)
                          ? IconButton(
                              onPressed: () {
                                context
                                    .read<WalletCubit>()
                                    .onGetBookingPaymentHistory();
                              },
                              icon: const Icon(FontAwesomeIcons.eye))
                          : IconButton(
                              onPressed: () {
                                context.read<WalletCubit>().onSetInitialize();
                              },
                              icon: const Icon(FontAwesomeIcons.eyeSlash));
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputChip(
                    backgroundColor: AppColors.primaryLite,
                    label: const Text("Retirer de l'argent"),
                    avatar: const Icon(Icons.outbound_outlined),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        builder: (context) => const FractionallySizedBox(
                          heightFactor: 0.9,
                          child: WithdrawableBookingPage(),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
