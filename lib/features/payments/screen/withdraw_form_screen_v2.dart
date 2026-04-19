import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/payment/operator_model.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus_pro/features/payments/components/operator_selector.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WithdrawFormScreenV2 extends StatefulWidget {
  static const String name = 'withdraw_form_v2';

  const WithdrawFormScreenV2({super.key});

  @override
  State<WithdrawFormScreenV2> createState() => _WithdrawFormScreenV2State();
}

class _WithdrawFormScreenV2State extends State<WithdrawFormScreenV2> {
  OperatorModel? selectedOperator;
  late TextEditingController amountController;
  late TextEditingController phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, RequestState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scafold,
          appBar: AppBar(
            backgroundColor: AppColors.scafold,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: Text(
                      'Demande de retrait de fonds',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: AutoSizeText(
                      'Veuillez renseigner les informations pour effectuer votre demande de retrait.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SliverGap(30),
                  SliverToBoxAdapter(
                    child: OperatorSelector(
                      operators: OrderPaymentController.retraitOperatorsItems,
                      selectedOperator: selectedOperator,
                      onChanged: (value) {
                        setState(() {
                          selectedOperator = value;
                        });
                      },
                    ),
                  ),
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      isEnabled: state is! REQUEST_LOADING,
                      fillColor: Colors.white,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      labelText: 'Montant à retirer',
                      prefixIcon: const Icon(
                        FontAwesomeIcons.moneyBills,
                        size: 17,
                      ),
                      controller: amountController,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Veuillez entrer un montant';
                        }
                        final montant =
                            double.tryParse((value?.trim() ?? ''));
                        if (montant == null) {
                          return 'Veuillez entrer un montant valide';
                        }
                        if (montant == 0) {
                          return 'Le montant doit être supérieur à 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      isEnabled: state is! REQUEST_LOADING,
                      fillColor: Colors.white,
                      autofocus: true,
                      controller: phoneNumberController,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      labelText: 'Numéro de telephone valide',
                      prefixIcon: const Icon(CupertinoIcons.phone),
                      validator: (String? value) {
                        if (selectedOperator?.value == null) {
                          return 'Veuillez choisir un opérateur';
                        }
                        return PaymentUtils.numberValidator(
                          number: value!.replaceAll(' ', ''),
                          operatorName: selectedOperator?.value ?? '',
                        );
                      },
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '## ## ## ## ##',
                          filter: {'#': RegExp(r'[0-9]')},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20)
                .copyWith(bottom: 20),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: state is REQUEST_LOADING
                  ? null
                  : () async {
                      final amount =
                          int.tryParse(amountController.text) ?? 0;
                      if (_formKey.currentState?.validate() == true) {
                        if (selectedOperator == null ||
                            phoneNumberController.text.trim().isEmpty ||
                            amount == 0) {
                          ToastUtils.showError(
                            title: 'Oops, Impossible de continuer',
                            description:
                                'Verifier que tous les champs sont remplis',
                          );
                          return;
                        }
                        await context
                            .read<WalletCubit>()
                            .onCreateWithdrawalRequest(
                              withdrawalRequestDto: WithdrawalRequestDto(
                                currency: 'XOF',
                                amount: amount,
                                operator: selectedOperator!.value,
                                phoneNumber: phoneNumberController.text
                                    .replaceAll(' ', '')
                                    .trim(),
                                status: 'PENDING',
                              ),
                            );
                      }
                    },
              child: state is REQUEST_LOADING
                  ? const CircularProgressIndicator()
                  : const Text('Faire le retrait'),
            ),
          ),
        );
      },
    );
  }
}
