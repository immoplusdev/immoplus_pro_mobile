import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

class NotificationActifSheet extends StatelessWidget {
  const NotificationActifSheet({
    super.key,
    required this.onAccept,
    required this.onMaybeLater,
  });

  final VoidCallback onAccept;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.E6F5FF,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.notification,
                size: 32,
                color: AppColors.customBlue,
              ),
            ),
            const Gap(20),
            const Text(
              "Activez les notifications pour ne manquer aucune réservation.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF001B3D),
                height: 1.5,
              ),
            ),
            const Gap(12),
            // const Text(
            //   "Activez les notifications pour ne manquer aucune réservation, confirmation ou annulation.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.black54,
            //     height: 1.5,
            //   ),
            // ),
            // const Gap(12),
            const _BenefitRow(
              icon: Iconsax.calendar_tick,
              label: "Nouvelles réservations instantanées",
            ),
            const _BenefitRow(
              icon: Iconsax.tick_circle,
              label: "Confirmations et annulations",
            ),
            const _BenefitRow(
              icon: Iconsax.card,
              label: "Alertes de paiement",
            ),
            const Gap(24),
            CustomButtom(
              text: "Recevoir des notifications",
              color: AppColors.customBlue,
              borderRadius: BorderRadius.circular(25),
              fontSize: 16,
              onClick: onAccept,
            ),
            const Gap(8),
            TextButton(
              onPressed: onMaybeLater,
              child: const Text(
                "Peut-être plus tard",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.customBlue),
          const Gap(10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
