import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/features/pin_code/logic/cubit/pin_code_cubit.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_reset_page.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/widgets/numeric_keypad.dart';
import 'package:toastification/toastification.dart';

class PinCodePageV2 extends StatefulWidget {
  final VoidCallback onSuccess;

  const PinCodePageV2({super.key, required this.onSuccess});
  static String name = 'pin_code_v2';

  @override
  State<PinCodePageV2> createState() => _PinCodePageV2State();
}

class _PinCodePageV2State extends State<PinCodePageV2>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  final int _pinLength = 4;
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<PinCodeCubit>()..checkStatus(),
      child: BlocConsumer<PinCodeCubit, PinCodeState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              toastification.show(
                type: ToastificationType.error,
                context: context,
                title: const Text("Erreur"),
                description: Text(message),
                autoCloseDuration: const Duration(seconds: 3),
              );
              setState(() => _pin = '');
              _controller.forward(from: 0.0);
            },
            pinVerified: () => widget.onSuccess(),
            pinSet: () {
              setState(() => _pin = '');
              widget.onSuccess();
            },
            confirmPin: () => setState(() => _pin = ''),
            biometricAvailable: (biometrics) {
              context.read<PinCodeCubit>().authenticateWithBiometrics();
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          String title = 'Entrez votre mot de passe';
          String subtitle = 'Entrer un mot de passe de 4 chiffres';

          state.maybeWhen(
            createPin: () =>
                title = 'Créer votre mot de passe pour accéder au coffre',
            confirmPin: () => title = 'Confirmez votre mot de passe',
            orElse: () {
              title = 'Entrez votre mot de passe pour accéder au coffre';
            },
          );

          final bool isCreateOrConfirm = state.maybeWhen(
            createPin: () => true,
            confirmPin: () => true,
            orElse: () => false,
          );

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sen(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    subtitle,
                    style: GoogleFonts.sen(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // PIN Indicators
                  AnimatedBuilder(
                    animation: _offsetAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            _offsetAnimation.value *
                                (1 - (_controller.value * 2).floor() % 2 * 2),
                            0),
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (index) {
                        final bool isFilled = index < _pin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFilled
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color:
                                  isFilled ? AppColors.primary : Colors.black,
                              width: 1.5,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),

                  // Numeric Keypad
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: NumericKeypad(
                      onKeyPressed: (value) => _onKeyPressed(context, value),
                      onDeletePressed: _onDeletePressed,
                    ),
                  ),
                  if (!isCreateOrConfirm) ...[
                    TextButton(
                      onPressed: () async {
                        try {
                          EasyLoadingHandler.showLoadingToast(
                              text: "Envoi du code OTP...");
                          await WalletRepository.requestPinReset();
                          EasyLoadingHandler.hideLoadingToast();
                          if (context.mounted) {
                            context.pushNamed(PinResetPage.name);
                          }
                        } catch (e) {
                          EasyLoadingHandler.hideLoadingToast();
                        }
                      },
                      child: Text(
                        "Code PIN oublié ?",
                        style: GoogleFonts.sen(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onKeyPressed(BuildContext context, String value) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += value;
      });
      if (_pin.length == _pinLength) {
        final cubit = context.read<PinCodeCubit>();
        cubit.state.maybeWhen(
          createPin: () => cubit.setPin(_pin),
          confirmPin: () => cubit.setPin(_pin),
          orElse: () => cubit.verifyPin(_pin),
        );
      }
    }
  }
}
