import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/otp_login/pages/phone_number_page.dart';
// import 'package:immoplus_pro/features/otp_login/pages/otp_page.dart'; // remplacé par le dialog OTP (voir showOtpInputDialog)

class OTPState {
  static String phoneNumber = '';
}

class OTPLoginPage extends StatelessWidget {
  const OTPLoginPage({
    super.key,
    required this.onSwitchMode,
  });

  static String name = 'OTP_LOGIN';
  final VoidCallback onSwitchMode;

  @override
  Widget build(BuildContext context) {
    return PhoneNumberPage(onSwitchMode: onSwitchMode);
  }
}
