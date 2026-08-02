import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/payment/operator_model.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/screen/withdrawal_success_page.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:toastification/toastification.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/utils/utils.dart';

class WithdrawFormScreenV2 extends StatefulWidget {
  static const String name = 'withdraw_form_v2';

  /// Non-null quand on arrive depuis le flux "scan QR → présence validée" :
  /// le montant n'est plus demandé (calculé côté backend depuis la
  /// réservation) et la soumission utilise
  /// POST /wallet/withdrawal-request/create-from-qr.
  final String? reservationId;

  const WithdrawFormScreenV2({super.key, this.reservationId});

  @override
  State<WithdrawFormScreenV2> createState() => _WithdrawFormScreenV2State();
}

class _WithdrawFormScreenV2State extends State<WithdrawFormScreenV2> {
  final _formKey = GlobalKey<FormState>();
  OperatorModel? selectedOperator;

  late TextEditingController _phoneController;
  late TextEditingController _amountController;

  bool _isLoading = false;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '## ## ## ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _amountController = TextEditingController();

    // Default to first operator if available
    if (OrderPaymentController.retraitOperatorsItems.isNotEmpty) {
      selectedOperator = OrderPaymentController.retraitOperatorsItems.first;
    }

    // Log withdrawal form opened event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletState = context.read<WalletCubit>().state;
      double balance = 0.0;
      if (walletState is WALLET) {
        balance = walletState.data.availableBalance.toDouble();
      }
      getIt<AnalyticsService>().logWithdrawalFormOpened(soldeDisponible: balance);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Soumission dédiée au flux "scan QR → présence validée" : pas de montant
  /// à saisir, POST /wallet/withdrawal-request/create-from-qr avec le
  /// reservationId déjà connu.
  Future<void> _submitFromQrRequest(String rawPhone) async {
    setState(() => _isLoading = true);
    bool isSuccess = false;
    getIt<AnalyticsService>().logWithdrawalSubmitted(
      montantRetrait: 0,
      paymentMethod: selectedOperator?.value ?? 'unknown',
    );
    try {
      EasyLoadingHandler.showLoadingToast(text: "Envoi de la demande...");

      isSuccess = await context.read<WalletCubit>().onCreateWithdrawalRequestFromQr(
            reservationId: widget.reservationId!,
            phoneNumber: rawPhone,
            operator: selectedOperator!.value,
          );

      EasyLoadingHandler.hideLoadingToast();
      if (isSuccess) {
        getIt<AnalyticsService>().logWithdrawalSuccess(
          montantRetrait: 0,
          paymentMethod: selectedOperator?.value ?? 'unknown',
        );
      } else {
        getIt<AnalyticsService>().logWithdrawalFailed(
          montantRetrait: 0,
          paymentMethod: selectedOperator?.value,
        );
        if (mounted) {
          toastification.show(
            type: ToastificationType.error,
            context: context,
            title: const Text("Échec de la demande"),
            description: const Text(
                "La demande de retrait a échoué. Veuillez réessayer."),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
      getIt<AnalyticsService>().logWithdrawalFailed(
        montantRetrait: 0,
        paymentMethod: selectedOperator?.value,
      );
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          context: context,
          title: const Text("Échec de la demande"),
          description: const Text(
              "La demande de retrait a échoué. Veuillez réessayer."),
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        await context.read<WalletCubit>().onGetWallet();

        if (isSuccess && mounted) {
          context.pushReplacementNamed(WithdrawalSuccessPage.name);
        }
      }
    }
  }

  Future<void> _submitRequest() async {
    if (selectedOperator == null) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Opérateur requis"),
        description: const Text("Veuillez sélectionner un opérateur."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final rawPhone = _phoneController.text.replaceAll(' ', '');
    if (rawPhone.length != 10) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Numéro invalide"),
        description:
            const Text("Le numéro de téléphone doit comporter 10 chiffres."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final validationErr = PaymentUtils.numberValidator(
      number: rawPhone,
      operatorName: selectedOperator!.value,
    );

    if (validationErr != null) {
      toastification.show(
        type: ToastificationType.error,
        context: context,
        title: const Text("Format de numéro incorrect"),
        description: Text(validationErr),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    if (widget.reservationId != null) {
      await _submitFromQrRequest(rawPhone);
      return;
    }

    final rawAmount = _amountController.text.replaceAll('.', '');
    final parsedAmount = int.tryParse(rawAmount) ?? 0;
    if (parsedAmount <= 0) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Montant invalide"),
        description:
            const Text("Veuillez saisir un montant supérieur à 0 XOF."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isLoading = true);
    bool isSuccess = false;
    getIt<AnalyticsService>().logWithdrawalSubmitted(
      montantRetrait: parsedAmount.toDouble(),
      paymentMethod: selectedOperator?.value ?? 'unknown',
    );
    try {
      EasyLoadingHandler.showLoadingToast(text: "Envoi de la demande...");

      final data = await context.read<WalletCubit>().onCreateWithdrawalRequest(
            withdrawalRequestDto: WithdrawalRequestDto(
              currency: 'XOF',
              amount: parsedAmount,
              operator: selectedOperator!.value,
              phoneNumber: rawPhone,
              status: 'PENDING',
            ),
          );

      EasyLoadingHandler.hideLoadingToast();
      if (data != null) {
        isSuccess = true;
        getIt<AnalyticsService>().logWithdrawalSuccess(
          montantRetrait: parsedAmount.toDouble(),
          paymentMethod: selectedOperator?.value ?? 'unknown',
        );
      } else {
        getIt<AnalyticsService>().logWithdrawalFailed(
          montantRetrait: parsedAmount.toDouble(),
          paymentMethod: selectedOperator?.value,
        );
        if (mounted) {
          toastification.show(
            type: ToastificationType.error,
            context: context,
            title: const Text("Échec de la demande"),
            description: const Text(
                "La demande de retrait a échoué. Veuillez réessayer."),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
      getIt<AnalyticsService>().logWithdrawalFailed(
        montantRetrait: parsedAmount.toDouble(),
        paymentMethod: selectedOperator?.value,
      );
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          context: context,
          title: const Text("Échec de la demande"),
          description: const Text(
              "La demande de retrait a échoué. Veuillez réessayer."),
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        // Rafraîchir le portefeuille pour actualiser le solde disponible et le solde en cours
        // dans le bloc finally pour s'assurer que c'est fait en cas de succès comme d'échec.
        await context.read<WalletCubit>().onGetWallet();

        if (isSuccess && mounted) {
          // Rediriger vers la page de succès en toute sécurité
          context.pushReplacementNamed(
            WithdrawalSuccessPage.name,
          );
        }
      }
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
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Nouveau retrait",
          style: GoogleFonts.sen(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selectioner un opérateur :",
                          style: GoogleFonts.sen(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(12),

                        // Horizontal operator selector row
                        _buildOperatorSelectorRow(),

                        const Gap(24),

                        Text(
                          "Numero de téléphone valide :",
                          style: GoogleFonts.sen(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),

                        // Telephone Custom Input Box (Standard TextFormField styled)
                        _buildPhoneInputField(),

                        const Gap(24),

                        if (widget.reservationId == null) ...[
                          Text(
                            "Montant à retirer :",
                            style: GoogleFonts.sen(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(8),

                          // Amount Custom Input Box (Standard TextFormField styled)
                          _buildAmountInputField(),
                          const Gap(8),
                          _buildAvailableBalanceHint(),
                        ],

                        const Gap(40),
                      ],
                    ),
                  ),
                ),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary ?? const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _submitRequest,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            "Faire le retrait",
                            style: GoogleFonts.sen(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorSelectorRow() {
    return Row(
      spacing: 10,
      children: OrderPaymentController.retraitOperatorsItems
          .asMap()
          .entries
          .map((entry) {
        final operator = entry.value;
        final isSelected = selectedOperator == operator;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedOperator = operator;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? (AppColors.primary) : Colors.transparent,
                  width: isSelected ? 2.0 : 0.0,
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(operator.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhoneInputField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.sen(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      inputFormatters: [_phoneFormatter],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: const Icon(
          CupertinoIcons.phone,
          color: Color(0xFF2563EB),
          size: 20,
        ),
        hintText: "07 00 00 00 00",
        hintStyle: GoogleFonts.sen(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary ?? const Color(0xFF2563EB),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInputField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: GoogleFonts.sen(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsSeparatorInputFormatter(),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: "50.000",
        hintStyle: GoogleFonts.sen(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "fcfa",
                style: GoogleFonts.sen(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary ?? const Color(0xFF2563EB),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableBalanceHint() {
    return BlocBuilder<WalletCubit, RequestState>(
      builder: (context, state) {
        if (state is! WALLET) return const SizedBox.shrink();
        final balance = state.data.availableBalance.toDouble();
        return Text(
          "NB : votre solde disponible est de ${Utils.formatCurrency(balance)}, vous pouvez retirer ce montant.",
          style: GoogleFonts.sen(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        );
      },
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String cleanString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanString.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    int? parsed = int.tryParse(cleanString);
    if (parsed == null) return oldValue;

    final String formatted = _formatNumberWithDots(parsed);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumberWithDots(int value) {
    String str = value.toString();
    StringBuffer buffer = StringBuffer();
    int len = str.length;
    for (int i = 0; i < len; i++) {
      buffer.write(str[i]);
      int remaining = len - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }
}
