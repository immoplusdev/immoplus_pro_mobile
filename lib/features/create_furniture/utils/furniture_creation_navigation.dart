import 'package:flutter/material.dart';


class FurnitureCreationNavigation {

  static const int totalSteps = 7;


  static late PageController pageController;


  static ValueNotifier<int> currentStepNotifier = ValueNotifier<int>(0);

 
  static int get currentStep => currentStepNotifier.value;

  
  static const Duration _animationDuration = Duration(milliseconds: 300);


  static const Curve _animationCurve = Curves.easeInOut;


  static void setStep(int step) {
    currentStepNotifier.value = step;
  }

  
  static void next() {
    if (currentStep < totalSteps - 1) {
      final nextStep = currentStep + 1;
      setStep(nextStep);
      pageController.animateToPage(
        nextStep,
        duration: _animationDuration,
        curve: _animationCurve,
      );
    }
  }


  static void previous() {
    if (currentStep > 0) {
      final prevStep = currentStep - 1;
      setStep(prevStep);
      pageController.animateToPage(
        prevStep,
        duration: _animationDuration,
        curve: _animationCurve,
      );
    }
  }


  static void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      setStep(step);
      pageController.animateToPage(
        step,
        duration: _animationDuration,
        curve: _animationCurve,
      );
    }
  }

  /// Réinitialise la navigation à l'étape 0.
 
  static void reset() {
    currentStepNotifier.value = 0;
    pageController.jumpToPage(0);
  }
}
