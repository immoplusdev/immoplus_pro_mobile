import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/components/wallet_indicator.dart';
import 'package:immoplus_pro/features/payments/components/wallet_transaction_list.dart';
import 'package:immoplus_pro/features/payments/components/withdrawal_request_list.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_response.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdraw_form_screen.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});
  static String name = 'PaymentsPage';

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final Map<int, Widget> _segments = const <int, Widget>{
    0: Text('Transactions'),
    1: Text('Demandes'),
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSegmentChanged(int? index) {
    if (index != null) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        appBar: AppBar(
          title: CupertinoSlidingSegmentedControl<int>(
            groupValue: _currentIndex,
            children: _segments,
            onValueChanged: _onSegmentChanged,
            backgroundColor: AppColors.scafold,
            thumbColor: Colors.white,
          ),
          leading: Icon(
            FontAwesomeIcons.moneyBills,
            color: Colors.green,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          backgroundColor: AppColors.whiteBackground,
          actions: [
            IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                icon: Icon(
                  FontAwesomeIcons.solidCircleXmark,
                  color: AppColors.primary,
                )),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(100), child: WalletIndicator()),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [WalletTransactionList(), WithdrawalRequestList()],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.outbound_outlined),
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.scafold,
              showDragHandle: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              builder: (context) => const FractionallySizedBox(
                heightFactor: 0.9,
                child: WithdrawFormScreen(),
              ),
            ).then((value) {
              if (value is WithdrawalRequestModel) {
                pagingControllerWidrawalList.refresh();
                context.read<WalletCubit>().onGetWallet();
              }
            });
          },
          backgroundColor: AppColors.primary,
          label: Text(
            "Demande de Retrait",
          ),
          extendedTextStyle: context.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
