import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/features/pin_code/data/repositories/pin_code_repository.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';
import 'package:immoplus_pro/widgets/numeric_keypad.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:toastification/toastification.dart';

class PinResetPage extends StatefulWidget {
  const PinResetPage({super.key});
  static const String name = 'PIN_RESET';

  @override
  State<PinResetPage> createState() => _PinResetPageState();
}

class _PinResetPageState extends State<PinResetPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _otpCtrl = TextEditingController();

  String _newPin = '';
  String _confirmPin = '';

  final int _pinLength = 4;
  final _formKeyOtp = GlobalKey<FormState>();

  int _resendCountdown = 30;
  Timer? _timer;
  bool _isLoading = false;
  int _currentPage = 0;

  late AnimationController _shakeController;
  late Animation<double> _shakeOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeOffsetAnimation = Tween<double>(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  void _startCountdown() {
    _resendCountdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;
    setState(() => _isLoading = true);
    try {
      EasyLoadingHandler.showLoadingToast(text: "Renvoy de l'OTP...");
      await WalletRepository.requestPinReset();
      EasyLoadingHandler.hideLoadingToast();
      _startCountdown();
      toastification.show(
        type: ToastificationType.success,
        context: context,
        title: const Text("Succès"),
        description: const Text("Un nouveau code OTP a été envoyé par SMS."),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _triggerShake() {
    HapticFeedback.vibrate();
    _shakeController.forward(from: 0.0);
  }

  void _validateOtpStep() {
    if (_otpCtrl.text.length != 6) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Code incomplet"),
        description: const Text("Veuillez entrer le code OTP à 6 chiffres."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = 1;
    });
  }

  void _onKeyPressed(String value) {
    if (_isLoading) return;

    if (_currentPage == 1) {
      if (_newPin.length < _pinLength) {
        setState(() {
          _newPin += value;
        });
        if (_newPin.length == _pinLength) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              _currentPage = 2;
            });
          });
        }
      }
    } else if (_currentPage == 2) {
      if (_confirmPin.length < _pinLength) {
        setState(() {
          _confirmPin += value;
        });
        if (_confirmPin.length == _pinLength) {
          Future.delayed(const Duration(milliseconds: 200), _submitReset);
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;

    if (_currentPage == 1) {
      if (_newPin.isNotEmpty) {
        setState(() {
          _newPin = _newPin.substring(0, _newPin.length - 1);
        });
      }
    } else if (_currentPage == 2) {
      if (_confirmPin.isNotEmpty) {
        setState(() {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        });
      }
    }
  }

  Future<void> _submitReset() async {
    if (_newPin != _confirmPin) {
      _triggerShake();
      toastification.show(
        type: ToastificationType.error,
        context: context,
        title: const Text("Erreur de confirmation"),
        description: const Text("Les codes PIN ne correspondent pas."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      setState(() {
        _confirmPin = '';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      EasyLoadingHandler.showLoadingToast(
          text: "Réinitialisation du code PIN...");

      // Perform API call
      await WalletRepository.resetPin(
        _otpCtrl.text.trim(),
        _newPin.trim(),
      );

      // Save PIN in local secure storage to keep biometrics in sync
      final repo = PinCodeRepository();
      await repo.saveLocalPin(_newPin.trim());

      EasyLoadingHandler.hideLoadingToast();
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          context: context,
          title: const Text("Succès"),
          description:
              const Text("Votre code PIN a été réinitialisé avec succès !"),
          autoCloseDuration: const Duration(seconds: 3),
        );
        context.pop();
      }
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
      _triggerShake();
      // On network or API error, let them re-verify new PIN/confirmation
      setState(() {
        _currentPage = 1;
        _newPin = '';
        _confirmPin = '';
      });
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _pageController.dispose();
    _otpCtrl.dispose();
    super.dispose();
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
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentPage--;
                if (_currentPage == 1) _confirmPin = '';
                if (_currentPage == 0) _newPin = '';
              });
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          "Réinitialiser le PIN",
          style: GoogleFonts.sen(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildOtpStep(),
                  _buildStepView(
                    title: "Nouveau code PIN",
                    subtitle: "Saisissez votre nouveau code PIN de 4 chiffres.",
                    pin: _newPin,
                  ),
                  _buildStepView(
                    title: "Confirmer le PIN",
                    subtitle:
                        "Confirmez le nouveau code PIN en le saisissant de nouveau.",
                    pin: _confirmPin,
                  ),
                ],
              ),
            ),

            // Numeric Keypad only shown on step 1 & 2
            if (_currentPage > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: NumericKeypad(
                  onKeyPressed: _onKeyPressed,
                  onDeletePressed: _onDeletePressed,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: _formKeyOtp,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(20),
            Icon(
              Icons.sms_failed_outlined,
              size: 72,
              color: AppColors.primary,
            ),
            const Gap(20),
            Text(
              "Vérification du code OTP",
              style: GoogleFonts.sen(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            Text(
              "Entrez le code de vérification à 6 chiffres reçu par SMS.",
              style: GoogleFonts.sen(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.E6F5FF ?? Colors.blue.shade50,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomPinput(
                    controller: _otpCtrl,
                    length: 6,
                    onCompleted: (val) => _validateOtpStep(),
                    borderColor: AppColors.primary?.withOpacity(0.3),
                    focusedBorderColor: AppColors.primary,
                  ),
                  const Gap(30),
                  SizedBox(
                    width: double.infinity,
                    child: CustomLoadingButtom(
                      text: "Continuer",
                      onClick: _validateOtpStep,
                      isLoading: _isLoading,
                    ),
                  ),
                  const Gap(16),
                  TextButton(
                    onPressed: _resendCountdown == 0 && !_isLoading
                        ? _resendOtp
                        : null,
                    child: Text(
                      _resendCountdown > 0
                          ? "Renvoyer le code dans $_resendCountdown s"
                          : "Renvoyer le code",
                      style: GoogleFonts.sen(
                        color: _resendCountdown > 0
                            ? Colors.grey
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepView({
    required String title,
    required String subtitle,
    required String pin,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(40),
          Text(
            title,
            style: GoogleFonts.sen(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(10),
          Text(
            subtitle,
            style: GoogleFonts.sen(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(40),

          // PIN indicators (visual dots) with shake animation
          AnimatedBuilder(
            animation: _shakeOffsetAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _shakeOffsetAnimation.value *
                      (1 - (_shakeController.value * 2).floor() % 2 * 2),
                  0,
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                final bool isFilled = index < pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? AppColors.primary : Colors.black54,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
