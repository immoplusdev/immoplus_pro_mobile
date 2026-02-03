import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/otp_login/pages/otp_page.dart';
import 'package:immoplus_pro/features/otp_login/pages/phone_number_page.dart';

class OTPState {
  static String phoneNumber = '';
}

class OTPLoginPage extends StatefulWidget {
  const OTPLoginPage({
    super.key,
    required this.onSwitchMode,
  });

  static String name = 'OTP_LOGIN';
  final VoidCallback onSwitchMode;

  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PhoneNumberPage(
          onSwitchMode: widget.onSwitchMode, // Passer le callback
          pageController: _pageController,
        ),
        OTPPage(
          pageController: _pageController,
        ),
      ],
    );
  }
}
