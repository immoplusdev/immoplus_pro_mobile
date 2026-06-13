import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/features/authentification/custom_page_immo.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/verify_email_otp_page.dart';
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
  String phoneNumber = '';

  void onInputValidated(bool isValid) {
    setState(() {
      isPhoneNumberValid = isValid;
    });
  }

  Future<void> _sendOtpCode() async {
    if (!isPhoneNumberValid || phoneNumber.isEmpty) return;
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
      context.pushNamed(VerifyEmailOtpPage.name, extra: {
        "phoneNumber": formattedPhone,
        "isWhatsapp": useWhatsapp,
        "onSuccess": widget.onSuccess
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageImmo(
      title: "Vérification",
      content: BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
        builder: (context, state) {
          final isLoading = state is REGISTRATION_LOADING;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(appPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Saisissez votre numéro de téléphone",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        "Un code de vérification vous sera envoyé.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(28),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.E6F5FF,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Icon(
                                Icons.phone_iphone,
                                size: 45,
                                color: AppColors.primary,
                              ),
                            ),
                            Gap(14),
                            Text("Numéro de téléphone",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Gap(13),
                            // Champ téléphone
                            SizedBox(
                              height: 80,
                              child: InternationalPhoneInput(
                                fillColor: Colors.white,
                                suffixIcon: SizedBox(),
                                onValidPhoneNumber: (value) {
                                  phoneNumber = value;
                                },
                                onInputValidated: onInputValidated,
                                validator: (t) {
                                  return null;
                                },
                              ),
                            ),
                            const Gap(8),

                            // Bouton
                            CustomLoadingButtom(
                              text: "Envoyer le code",
                              onClick: _sendOtpCode,
                              isLoading: isLoading,
                              clickable:
                                  isPhoneNumberValid && phoneNumber.isNotEmpty,
                              color: isPhoneNumberValid
                                  ? AppColors.primary
                                  : Colors.blueGrey.shade200,
                            ),
                            const Gap(24),
                            Text(
                              "Votre numéro est uniquement utilisé pour cette vérification.",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
