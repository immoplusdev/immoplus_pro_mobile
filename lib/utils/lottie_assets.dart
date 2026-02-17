import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LottieAssets {
  final LottieBuilder _success = Lottie.asset(
    'assets/lotties/success.json',
    repeat: false,
  );
  final LottieBuilder _furniture = Lottie.asset(
    'assets/lotties/furniture_1.json',
    repeat: true,
  );
  final LottieBuilder _fail = Lottie.asset(
    'assets/lotties/fail.json',
    repeat: false,
  );
  final LottieBuilder _cheking = Lottie.asset(
    'assets/lotties/cheking.json',
    repeat: true,
  );
  final LottieBuilder _orderChecking = Lottie.asset(
    'assets/lotties/orderChecking.json',
    repeat: true,
  );
  final LottieBuilder _deliveryProgress = Lottie.asset(
    'assets/lotties/delivery_progress.json',
    repeat: true,
  );
  final LottieBuilder _house = Lottie.asset(
    'assets/lotties/house.json',
    repeat: true,
  );
  LottieBuilder get furniture => _furniture;
  LottieBuilder get success => _success;
  LottieBuilder get fail => _fail;
  LottieBuilder get cheking => _cheking;
  LottieBuilder get orderChecking => _orderChecking;
  LottieBuilder get deliveryProgress => _deliveryProgress;
  LottieBuilder get house => _house;
  static get vsync => null;
}
