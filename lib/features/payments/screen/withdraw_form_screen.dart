import 'package:auto_size_text/auto_size_text.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/payment/operator_model.dart';
import 'package:immoplus_pro/features/payment_module/utils/currency_input_formatter.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus_pro/features/payments/components/operator_selector.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:toastification/toastification.dart';

class WithdrawFormScreen extends StatefulWidget {
  const WithdrawFormScreen({super.key});

  @override
  State<WithdrawFormScreen> createState() => _WithdrawFormScreenState();
}

class _WithdrawFormScreenState extends State<WithdrawFormScreen> {
  OperatorModel? selectedOperator;
  TextEditingController? amountController;
  TextEditingController? phoneNumberController;
  final currencyController = CurrencyTextFieldController(
      currencySymbol: '', // ou 'XOF' si tu veux un préfixe
      decimalSymbol:
          ',', // Pour fr_FR (facultatif si tu veux éviter les décimales)
      thousandSymbol: ' ',
      initDoubleValue: 0,
      numberOfDecimals: 0);
  @override
  void initState() {
    amountController = TextEditingController();
    phoneNumberController = TextEditingController();
    // selectedOperator = OrderPaymentController.items.first;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, RequestState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scafold,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                      padding: EdgeInsets.only(top: 20),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Demande de retrait de fonds',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      )),
                  SliverGap(10),
                  SliverToBoxAdapter(
                    child: AutoSizeText(
                      'Veuillez renseigner les informations pour effectuer votre demande de retrait.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    ),
                  ),
                  SliverGap(30),
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
                  SliverGap(10),
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
                      controller: currencyController,
                      validator: (value) {
                        if (currencyController.doubleValue == 0.0) {
                          return 'Veuillez entrer un montant';
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
                      validator: (String? value) =>
                          PaymentUtils.numberValidator(
                              number: value!.replaceAll(' ', ''),
                              operatorName: OrderPaymentController
                                      .selectedOperator.value ??
                                  ''),
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '## ## ## ## ##',
                            filter: {'#': RegExp(r'[0-9]')})
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: state is REQUEST_LOADING
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() == true) {
                        if (selectedOperator == null ||
                            phoneNumberController?.text.trim().isEmpty ==
                                true ||
                            currencyController.intValue == 0) {
                          ToastUtils.showError(
                              title: "Oops, Impossible de continuer",
                              description:
                                  "Verifier que tous les champs sont remplis");

                          return;
                        }
                        await context
                            .read<WalletCubit>()
                            .onCreateWithdrawalRequest(
                              withdrawalRequestDto: WithdrawalRequestDto(
                                currency: 'XOF',
                                amount: currencyController.intValue,
                                operator: selectedOperator!.value,
                                phoneNumber: phoneNumberController!.text
                                    .replaceAll(' ', '')
                                    .trim(),
                                status: "PENDING",
                              ),
                            );
                      }
                    },
              child: state is REQUEST_LOADING
                  ? CircularProgressIndicator()
                  : Text('Faire le retrait'),
            ),
          ),
        );
      },
    );
  }
}
