import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/widgets/otp_input_dialog.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/international_phone_number_input.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';

class SendEmailOptPage extends StatefulWidget {
  final Function(DataRouterRegistration dataRouterRegistration) onSuccess;
  const SendEmailOptPage({super.key, required this.onSuccess});
  static const String name = "SendEmailOptPage";

  @override
  State<SendEmailOptPage> createState() => _SendEmailOptPageState();
}

class _SendEmailOptPageState extends State<SendEmailOptPage> {
  final _formKey = GlobalKey<FormState>();
  bool isPhoneNumberValid = false;
  bool _submitAttempted = false;
  String phoneNumber = '';

  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  Future<void> _sendOtpCode() async {
    if (!isPhoneNumberValid || phoneNumber.isEmpty) {
      setState(() => _submitAttempted = true);
      return;
    }
    await AppDialog.show(
      title: 'Envoyer le code par',
      description:
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
      primaryButtonText: 'WhatsApp',
      secondButtonText: 'SMS',
      onPrimary: () => _doSendOtp(useWhatsapp: true),
      onSecond: () => _doSendOtp(useWhatsapp: false),
    );
  }

  Future<void> _doSendOtp({required bool useWhatsapp}) async {
    FocusScope.of(context).unfocus();
    if (!isPhoneNumberValid || phoneNumber.isEmpty) return;

    final formattedPhone = PhoneNumberHandler.formatPhoneNumber(phoneNumber);

    final cubit = context.read<RgistrationCubitCubit>();
    final success = await cubit.userSendOTP(
      phoneNumber: formattedPhone,
      is_whatssap: useWhatsapp,
    );
    if (!mounted) return;

    if (success) {
      await _verifyOtpLoop(phoneNumber: formattedPhone, isWhatsapp: useWhatsapp);
    }
  }

  Future<void> _verifyOtpLoop({
    required String phoneNumber,
    required bool isWhatsapp,
    String? errorText,
  }) async {
    final code = await showOtpInputDialog(
      context,
      phoneNumber: phoneNumber,
      isWhatsapp: isWhatsapp,
      errorText: errorText,
      onResend: () => _resendOtp(phoneNumber: phoneNumber, isWhatsapp: isWhatsapp),
    );
    if (code == null || !mounted) return;

    final cubit = context.read<RgistrationCubitCubit>();
    final resp = await cubit.verifyOtp(phoneNumber: phoneNumber, otp: code);
    if (!mounted) return;

    if (resp != null) {
      widget.onSuccess(DataRouterRegistration(
        phoneNumber: resp.data.phoneNumber.toString(),
        email: resp.data.email.toString(),
        token: resp.data.token.toString(),
      ));
    } else {
      await _verifyOtpLoop(
        phoneNumber: phoneNumber,
        isWhatsapp: isWhatsapp,
        errorText: 'Code invalide ou expiré. Veuillez réessayer.',
      );
    }
  }

  Future<void> _resendOtp({
    required String phoneNumber,
    required bool isWhatsapp,
  }) async {
    final cubit = context.read<RgistrationCubitCubit>();
    final ok = await cubit.userSendOTP(
      phoneNumber: phoneNumber,
      is_whatssap: isWhatsapp,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Un nouveau code a été envoyé.'
              : "Échec de l'envoi du code. Réessayez.",
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Iconsax.arrow_left_2,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
          builder: (context, state) {
            final isLoading = state is REGISTRATION_LOADING;

            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Gap(24),
                          Text(
                            "Saisissez votre numéro de téléphone",
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1F1F1F),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Gap(16),
                          Text(
                            "Un code de vérification vous sera envoyé.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFA3A3A3),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Gap(30),
                          SizedBox(
                            height: 80,
                            child: InternationalPhoneInput(
                              fillColor: Colors.white,
                              showBorder: true,
                              autofocus: true,
                              showErrorImmediately: false,
                              forceShowError: _submitAttempted,
                              suffixIcon: const Icon(
                                Iconsax.close_circle,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onValidPhoneNumber: (value) {
                                phoneNumber = value;
                              },
                              onInputValidated: onInputValidated,
                              validator: (t) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: CustomLoadingButtom(
                      text: "Envoyer le code",
                      onClick: _sendOtpCode,
                      isLoading: isLoading,
                      clickable: true,
                      color: isPhoneNumberValid
                          ? AppColors.primary
                          : Colors.blueGrey.shade200,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
