import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/pin_code/logic/cubit/pin_code_cubit.dart';
import 'package:toastification/toastification.dart';

class PinCodePageV2 extends StatefulWidget {
  final VoidCallback onSuccess;

  const PinCodePageV2({super.key, required this.onSuccess});
  static String name = 'pin_code_v2';

  @override
  State<PinCodePageV2> createState() => _PinCodePageV2State();
}

class _PinCodePageV2State extends State<PinCodePageV2> with SingleTickerProviderStateMixin {
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
            createPin: () => title = 'Créer votre mot de passe pour accéder au coffre',
            confirmPin: () => title = 'Confirmez votre mot de passe',
            orElse: () {
               title = 'Entrez votre mot de passe pour accéder au coffre';
            },
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
                        offset: Offset(_offsetAnimation.value * (1 - (_controller.value * 2).floor() % 2 * 2), 0),
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
                            color: isFilled ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: isFilled ? AppColors.primary : Colors.black,
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: Column(
                      children: [
                        _buildKeyRow(context, ['1', '2', '3']),
                        const SizedBox(height: 15),
                        _buildKeyRow(context, ['4', '5', '6']),
                        const SizedBox(height: 15),
                        _buildKeyRow(context, ['7', '8', '9']),
                        const SizedBox(height: 15),
                        _buildLastRow(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyRow(BuildContext context, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys.map((key) => _buildKey(context, key)).toList(),
    );
  }

  Widget _buildLastRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 80), // Placeholder for biometrics if needed later
        _buildKey(context, '0'),
        _buildDeleteButton(context),
      ],
    );
  }

  Widget _buildKey(BuildContext context, String value) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _onKeyPressed(context, value);
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.05),
        ),
        child: Text(
          value,
          style: GoogleFonts.sen(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (_pin.isNotEmpty) {
          setState(() {
            _pin = _pin.substring(0, _pin.length - 1);
          });
        }
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
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
