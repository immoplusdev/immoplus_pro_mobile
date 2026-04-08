import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/features/otp_login/otp_login_page.dart';
import 'package:immoplus_pro/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus_pro/features/shared_widgets/international_phone_number_input.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart'; // ✅ Ajoutez cet import
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';
import 'package:immoplus_pro/utils/status_code_handler.dart';
import 'package:immoplus_pro/widgets/social_button_widget.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({
    super.key,
    required this.pageController,
    required this.onSwitchMode,
  });

  final PageController pageController;
  final VoidCallback onSwitchMode;

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  bool isPhoneNumberValid = false;
  String phoneNumber = '';
  bool _isLoading = false; // ✅ Ajoutez cet état

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
    try {
      final body = SendOptModel(
        phoneNumber: PhoneNumberHandler.formatPhoneNumber(phoneNumber),
      );
      final response = useWhatsapp
          ? await AuthRepository.sendWhatsappOtp(body: body)
          : await AuthRepository.sendOtp(body: body);

      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        FocusScope.of(context).unfocus();
        OTPState.phoneNumber = phoneNumber;
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        CustomPopup.showErrorToast(
          text: 'Envoi du code échoué, veuillez ressayer',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomPopup.toast(
        color: Colors.red,
        toastPosition: EasyLoadingToastPosition.bottom,
        text: "Envoi de OTP code échoué, veuillez réessayer",
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(50),
            SizedBox(
              height: 80,
              child: InternationalPhoneInput(
                onValidPhoneNumber: (value) {
                  phoneNumber = value;
                  OTPState.phoneNumber = phoneNumber;
                },
                onInputValidated: onInputValidated,
              ),
            ),
            const Gap(10),
            CustomLoadingButtom(
              text: "Envoyer le code",
              onClick: _sendOtpCode,
              isLoading: _isLoading,
              clickable: isPhoneNumberValid && phoneNumber.isNotEmpty,
              color: isPhoneNumberValid
                  ? AppColors.primary
                  : Colors.blueGrey.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context.pushNamed(ResetPasswordPage.name);
                  },
                  child: Text(
                    'Mot de passe oublié',
                    style: GoogleFonts.inter(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: Divider(thickness: 1),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ou'),
                ),
                Flexible(
                  child: SizedBox(
                    child: Divider(thickness: 1),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SocialLoginButtons(
                mode: LoginMode.phone,
                onSwitchMode: widget.onSwitchMode,
              ),
            )
          ],
        ),
      ),
    );
  }
}

