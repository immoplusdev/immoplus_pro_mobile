import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/features/pin_code/data/repositories/pin_code_repository.dart';
import 'package:immoplus_pro/widgets/numeric_keypad.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:toastification/toastification.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});
  static const String name = 'CHANGE_PIN';

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  String _oldPin = '';
  String _newPin = '';
  String _confirmPin = '';

  final int _pinLength = 4;
  int _currentPage = 0;
  bool _isLoading = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeOffsetAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _shakeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    HapticFeedback.vibrate();
    _shakeController.forward(from: 0.0);
  }

  void _onKeyPressed(String value) {
    if (_isLoading) return;

    if (_currentPage == 0) {
      if (_oldPin.length < _pinLength) {
        setState(() {
          _oldPin += value;
        });
        if (_oldPin.length == _pinLength) {
          // Slide to next step
          Future.delayed(const Duration(milliseconds: 200), () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              _currentPage = 1;
            });
          });
        }
      }
    } else if (_currentPage == 1) {
      if (_newPin.length < _pinLength) {
        setState(() {
          _newPin += value;
        });
        if (_newPin.length == _pinLength) {
          // Slide to next step
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
          // Auto submit!
          Future.delayed(const Duration(milliseconds: 200), _submitChange);
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;

    if (_currentPage == 0) {
      if (_oldPin.isNotEmpty) {
        setState(() {
          _oldPin = _oldPin.substring(0, _oldPin.length - 1);
        });
      }
    } else if (_currentPage == 1) {
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

  Future<void> _submitChange() async {
    if (_newPin != _confirmPin) {
      _triggerShake();
      toastification.show(
        type: ToastificationType.error,
        context: context,
        title: const Text("Erreur de confirmation"),
        description: const Text("Les nouveaux codes PIN ne correspondent pas."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      setState(() {
        _confirmPin = '';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      EasyLoadingHandler.showLoadingToast(text: "Mise à jour du code PIN...");

      // Perform API call
      await WalletRepository.changePin(_oldPin, _newPin);

      // Save PIN in local secure storage to keep biometrics in sync
      final repo = PinCodeRepository();
      await repo.saveLocalPin(_newPin);

      EasyLoadingHandler.hideLoadingToast();
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          context: context,
          title: const Text("Succès"),
          description: const Text("Votre code PIN a été modifié avec succès !"),
          autoCloseDuration: const Duration(seconds: 3),
        );
        context.pop();
      }
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
      _triggerShake();
      // Reset confirmations on failure to let them retry
      setState(() {
        _currentPage = 0;
        _oldPin = '';
        _newPin = '';
        _confirmPin = '';
      });
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      setState(() => _isLoading = false);
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
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentPage--;
                if (_currentPage == 0) _newPin = '';
                if (_currentPage == 1) _confirmPin = '';
              });
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          "Modifier mon code PIN",
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
            // Custom step indicator progress bar
            _buildProgressBar(),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStepView(
                    title: "Ancien code PIN",
                    subtitle:
                        "Saisissez votre code PIN actuel pour des raisons de sécurité.",
                    pin: _oldPin,
                  ),
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

            // Numeric Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 4,
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: _currentPage + 1,
            child: Container(
              color: AppColors.primary,
            ),
          ),
          Expanded(
            flex: 3 - (_currentPage + 1),
            child: const SizedBox.shrink(),
          ),
        ],
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
