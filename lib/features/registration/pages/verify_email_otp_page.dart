import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/cubits/authentification/verify_email_response.dart';
import 'package:immoplus_pro/features/authentification/custom_page_immo.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';

class VerifyEmailOtpPage extends StatefulWidget {
  const VerifyEmailOtpPage({
    super.key,
    this.email,
    this.phoneNumber,
    this.isWhatsapp,
    required this.onSuccess,
  });

  /// L'email à vérifier (déjà saisi à l'étape précédente)
  final String? email;
  final String? phoneNumber;
  final bool? isWhatsapp;

  static const name = 'VERIFY_EMAIL_OTP';

  final Function(DataRouterRegistration dataRouterRegistration) onSuccess;

  @override
  State<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends State<VerifyEmailOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool? _isWhatsapp;

  @override
  void initState() {
    super.initState();
    _isWhatsapp = widget.isWhatsapp;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _otpValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Le code est requis';
    if (v.length != 6) return 'Le code doit contenir 6 chiffres';
    if (!RegExp(r'^\d{6}$').hasMatch(v)) return 'Le code doit être numérique';
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final resp = await cubit.verifyOtp(
      email: widget.email?.trim(),
      phoneNumber: widget.phoneNumber?.trim(),
      otp: _otpController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (resp is VerifyEmailResponse) {
      widget.onSuccess(DataRouterRegistration(
        phoneNumber: resp.data.phoneNumber.toString(),
        email: resp.data.email.toString(),
        token: resp.data.token.toString(),
      ));
    } else {
      // Échec : feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code invalide ou expiré. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resend() async {
    if (widget.email != null) {
      await _doResend(useWhatsapp: null);
      return;
    }

    await AppDialog.show(
      title: 'Envoyer le code par',
      description:
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
      primaryButtonText: 'WhatsApp',
      secondButtonText: 'SMS',
      onPrimary: () => _doResend(useWhatsapp: true),
      onSecond: () => _doResend(useWhatsapp: false),
    );
  }

  Future<void> _doResend({required bool? useWhatsapp}) async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final ok = await cubit.userSendOTP(
      email: widget.email?.trim(),
      phoneNumber: widget.phoneNumber?.trim(),
      is_whatssap: useWhatsapp,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok && useWhatsapp != null) {
      setState(() {
        _isWhatsapp = useWhatsapp;
      });
    }

    final destination = useWhatsapp == true
        ? 'WhatsApp'
        : useWhatsapp == false
            ? 'SMS'
            : (widget.email ?? widget.phoneNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Un nouveau code a été envoyé par $destination.'
              : 'Échec de l\'envoi du code. Réessayez.',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageImmo(
      title: 'Vérification du code',
      content: BlocListener<RgistrationCubitCubit, RegistrationCubitState>(
        listener: (context, state) {
          setState(() => _isLoading = state is REGISTRATION_LOADING);
        },
        child: SingleChildScrollView(
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
                      'Entrez le code reçu',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      _isWhatsapp == true
                          ? 'Un code à 6 chiffres a été envoyé par WhatsApp au ${widget.phoneNumber}'
                          : _isWhatsapp == false
                              ? 'Un code à 6 chiffres a été envoyé par SMS au ${widget.phoneNumber}'
                              : 'Un code à 6 chiffres a été envoyé à ${widget.email ?? widget.phoneNumber}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
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
                            child: Image.asset(
                              Assets.img.email.path,
                              width: 35,
                            ),
                          ),
                          Gap(14),
                          Text("Code de vérification",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          Gap(13),
                          // Champ OTP (6 cases)
                          CustomPinput(
                            controller: _otpController,
                            onCompleted: (pin) => _submit(context),
                            onChanged: (code) {
                              if (_formKey.currentState?.mounted ?? false) {
                                _formKey.currentState!.validate();
                              }
                            },
                          ),

                          // Message d'erreur animé
                          Builder(
                            builder: (context) {
                              final err = _otpValidator(_otpController.text);
                              return AnimatedOpacity(
                                opacity: (err == null) ? 0 : 1,
                                duration: const Duration(milliseconds: 200),
                                child: (err == null)
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          err,
                                          style: TextStyle(
                                            color: theme.colorScheme.error,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),
                          const Gap(24),

                          // Bouton de validation
                          SizedBox(
                            width: double.infinity,
                            child: CustomLoadingButtom(
                              text: "Valider le code",
                              onClick: () => _submit(context),
                              isLoading: _isLoading,
                            ),
                          ),
                          const Gap(12),

                          // Bouton renvoyer
                          Center(
                            child: TextButton(
                              onPressed: _isLoading ? null : _resend,
                              child: const Text('Renvoyer le code'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
