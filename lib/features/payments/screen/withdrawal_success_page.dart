import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/features/payments/payments_page_v2.dart';

class WithdrawalSuccessPage extends StatelessWidget {
  const WithdrawalSuccessPage({super.key});
  static const String name = 'withdrawal_success_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Wavy, flower-like green badge icon matching the mockup perfectly
              _buildSuccessIcon(),
              const Gap(40),
              Text(
                'Votre demande a été envoyée avec succès',
                textAlign: TextAlign.center,
                style: GoogleFonts.sen(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const Gap(16),
              Text(
                'Nous vous proposerons des biens correspondant à vos critères dans les plus brefs délais.',
                textAlign: TextAlign.center,
                style: GoogleFonts.sen(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Primary home button
              CustomLoadingButtom(
                text: 'Retourner à l\'accueil',
                isLoading: false,
                onClick: () {
                  context.goNamed(HomePageV2.name);
                },
              ),
              const Gap(12),
              // Secondary outline button to view transactions
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    context.goNamed(HomePageV2.name);
                    context.pushNamed(PaymentsPageV2.name);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.primary ?? const Color(0xFF2563EB),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    'Voir les transactions',
                    style: GoogleFonts.sen(
                      color: AppColors.primary ?? const Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotated square 1 (0 deg)
        Transform.rotate(
          angle: 0.0,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFA1D9A7).withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        // Rotated square 2 (30 deg)
        Transform.rotate(
          angle: 0.523599, // 30 degrees in radians
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFA1D9A7).withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        // Rotated square 3 (60 deg)
        Transform.rotate(
          angle: 1.047198, // 60 degrees in radians
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFA1D9A7).withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        // Thick bright green checkmark in the center
        const Icon(
          Icons.check_rounded,
          size: 68,
          color: Color(0xFF16A34A),
        ),
      ],
    );
  }
}
