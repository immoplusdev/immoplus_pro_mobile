import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingNotificationPage extends StatelessWidget {
  const OnboardingNotificationPage({super.key});

  static const String name = 'ONBOARDING_NOTIFICATION';

  Future<void> _activateAndContinue(BuildContext context) async {
   
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {

      await openAppSettings();
    } else if (status.isGranted) {
      await OneSignal.User.pushSubscription.optIn();
    }
    
    if (context.mounted) await _markAndNavigate(context);
  }

  Future<void> _markAndNavigate(BuildContext context) async {
    await getIt<SessionManager>().markOnboardingAsRead();
    if (context.mounted) {
      context.goNamed(AuthenticationPage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.E6F5FF,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  size: 64,
                  color: AppColors.customBlue,
                ),
              ),
              const Gap(40),
              Text(
                "Restez\ninformé !",
                textAlign: TextAlign.center,
                style: GoogleFonts.sen(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF001B3D),
                  height: 1.1,
                ),
              ),
              const Gap(20),
              const Text(
                "Activez les notifications pour être alerté dès qu'une réservation est effectuée, confirmée ou annulée.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              CustomButtom(
                text: "Activer les notifications",
                color: AppColors.customBlue,
                borderRadius: BorderRadius.circular(25),
                fontSize: 18,
                onClick: () => _activateAndContinue(context),
              ),
              const Gap(16),
              TextButton(
                onPressed: () => _markAndNavigate(context),
                child: const Text(
                  "Pas maintenant",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}
