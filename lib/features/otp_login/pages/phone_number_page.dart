import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/common/account_source.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/data/models/auth/login_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/features/registration/widgets/otp_input_dialog.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/features/otp_login/otp_login_page.dart';
import 'package:immoplus_pro/features/shared_widgets/international_phone_number_input.dart';
import 'package:immoplus_pro/utils/api_error_dialog.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';
import 'package:immoplus_pro/utils/status_code_handler.dart';
// import 'package:immoplus_pro/widgets/social_button_widget.dart'; // connexion sociale désactivée

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({
    super.key,
    required this.onSwitchMode,
  });

  final VoidCallback onSwitchMode;

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  bool isPhoneNumberValid = false;
  String phoneNumber = '';
  bool _isLoading = false;

  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  Future<void> _sendOtpCode() async {
    if (_isLoading || !mounted) return;
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
    setState(() => _isLoading = true);
    final formattedPhone = PhoneNumberHandler.formatPhoneNumber(phoneNumber);
    try {
      final body = SendOptModel(phoneNumber: formattedPhone);
      final response = useWhatsapp
          ? await AuthRepository.sendWhatsappOtp(body: body)
          : await AuthRepository.sendOtp(body: body);

      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        FocusScope.of(context).unfocus();
        OTPState.phoneNumber = formattedPhone;
        setState(() => _isLoading = false);
        await _verifyOtpLoop(
          phoneNumber: formattedPhone,
          isWhatsapp: useWhatsapp,
        );
        return;
      } else {
        EasyLoadingHandler.showErrorToast(
          text: 'Envoi du code échoué, veuillez ressayer',
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Certaines erreurs (ex: USER_NOT_FOUND) affichent déjà leur propre
      // dialog via ErrorInterceptor : pas besoin d'un toast en plus.
      if (ApiErrorDialog.codeFrom(e)?.hasDedicatedDialog == true) return;
      EasyLoadingHandler.toast(
        toastPosition: EasyLoadingToastPosition.bottom,
        text: "Envoi de OTP code échoué, veuillez réessayer",
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtpLoop({
    required String phoneNumber,
    required bool isWhatsapp,
  }) async {
    await showOtpInputDialog(
      context,
      phoneNumber: phoneNumber,
      isWhatsapp: isWhatsapp,
      onResend: () =>
          _resendOtp(phoneNumber: phoneNumber, isWhatsapp: isWhatsapp),
      onVerify: (code) => context.read<LoginCubit>().onSendOtpData(
            body: LoginOtpBody(
              phoneNumber: phoneNumber,
              otp: code,
              source: AccountSource.proApp.value,
            ),
          ),
    );
  }

  Future<void> _resendOtp({
    required String phoneNumber,
    required bool isWhatsapp,
  }) async {
    try {
      final body = SendOptModel(phoneNumber: phoneNumber);
      final response = isWhatsapp
          ? await AuthRepository.sendWhatsappOtp(body: body)
          : await AuthRepository.sendOtp(body: body);
      if (!mounted) return;
      final ok = StatusCodeHandler.isSuccess(response.response.statusCode);
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
    } catch (e) {
      if (!mounted) return;
      if (ApiErrorDialog.codeFrom(e)?.hasDedicatedDialog == true) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Échec de l'envoi du code. Réessayez."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(24),
                Text(
                  "Connectez-vous avec votre numéro",
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
                    suffixIcon: const Icon(
                      Iconsax.close_circle,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onValidPhoneNumber: (value) {
                      phoneNumber = value;
                      OTPState.phoneNumber = phoneNumber;
                    },
                    onInputValidated: onInputValidated,
                  ),
                ),
                // Connexion sociale désactivée : seul le numéro reste actif.
                // const Gap(10),
                // const Row(
                //   children: [
                //     Flexible(
                //       child: SizedBox(
                //         width: 200,
                //         child: Divider(thickness: 1),
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.all(8.0),
                //       child: Text('ou'),
                //     ),
                //     Flexible(
                //       child: SizedBox(
                //         child: Divider(thickness: 1),
                //       ),
                //     ),
                //   ],
                // ),
                // const Gap(10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30),
                //   child: SocialLoginButtons(
                //     mode: LoginMode.phone,
                //     onSwitchMode: widget.onSwitchMode,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        CustomLoadingButtom(
          text: "Envoyer le code",
          onClick: _sendOtpCode,
          isLoading: _isLoading,
          clickable: isPhoneNumberValid && phoneNumber.isNotEmpty,
          color: isPhoneNumberValid
              ? AppColors.primary
              : Colors.blueGrey.shade200,
        ),
        const Gap(20),
      ],
    );
  }
}
