import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/components/wallet_indicator.dart';
import 'package:immoplus_pro/features/payments/components/wallet_transaction_list.dart';
import 'package:immoplus_pro/features/payments/components/withdrawal_request_list.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdraw_form_screen_v2.dart';

class PaymentsPageV2 extends StatefulWidget {
  const PaymentsPageV2({super.key});
  static String name = 'PaymentsPageV2';

  @override
  State<PaymentsPageV2> createState() => _PaymentsPageV2State();
}

class _PaymentsPageV2State extends State<PaymentsPageV2> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: CupertinoSlidingSegmentedControl<int>(
          groupValue: _currentIndex,
          children: _segments,
          onValueChanged: _onSegmentChanged,
          backgroundColor: AppColors.scafold,
          thumbColor: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const WalletIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                const WalletTransactionList(),
                const WithdrawalRequestList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.outbound_outlined),
        onPressed: () async {
          final cubit = context.read<WalletCubit>();
          final value = await context
              .pushNamed<WithdrawalRequestModel>(WithdrawFormScreenV2.name);
          if (value is WithdrawalRequestModel && mounted) {
            pagingControllerWidrawalList.refresh();
            cubit.onGetWallet();
          }
        },
        backgroundColor: AppColors.primary,
        label: const Text("Demande de Retrait"),
      ),
    );
  }
}
