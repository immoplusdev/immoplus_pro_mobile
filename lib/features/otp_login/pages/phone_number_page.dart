import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/features/otp_login/otp_login_page.dart';
import 'package:immoplus_pro/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus_pro/features/shared_widgets/international_phone_number_input.dart';
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

  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
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
            BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                return EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: Text(
                    'Envoyer Code'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  loadingStateWidget: const CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  useWidthAnimation: true,
                  useEqualLoadingStateWidgetDimension: true,
                  width: double.infinity,
                  height: 55.0,
                  borderRadius: 20.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: isPhoneNumberValid
                      ? AppColors.primary
                      : Colors.blueGrey.shade200,
                  onPressed: phoneNumber.isNotEmpty
                      ? () async {
                          try {
                            final response = await AuthRepository.sendOtp(
                              body: SendOptModel(
                                phoneNumber:
                                    PhoneNumberHandler.formatPhoneNumber(
                                  phoneNumber,
                                ),
                              ),
                            );

                            if (StatusCodeHandler.isSuccess(
                                response.response.statusCode)) {
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
                            CustomPopup.toast(
                              color: Colors.red,
                              toastPosition: EasyLoadingToastPosition.bottom,
                              text:
                                  "Envoi de OTP code échoué, veuillez réessayer",
                            );
                          }
                        }
                      : null,
                );
              },
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
