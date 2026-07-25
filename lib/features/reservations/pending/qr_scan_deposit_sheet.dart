import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';

/// Sheet d'annonce de la fonctionnalité de scan QR code (client → app Pro)
/// pour valider un dépôt. Purement présentationnel — mirror exact du
/// format de [NotificationActifSheet] (lib/features/notification/widgets/
/// notification_actif_sheet.dart) : c'est l'appelant qui décide quand
/// l'afficher / ne plus l'afficher.
class QrScanDepositSheet extends StatelessWidget {
  const QrScanDepositSheet({
    super.key,
    required this.onAccept,
  });

  /// Appelé au tap sur le bouton principal — l'appelant décide de l'action
  /// (fermer le sheet, ouvrir directement le scanner, etc.).
  final VoidCallback onAccept;

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
                  Iconsax.scan_barcode,
                  size: 32,
                  color: AppColors.customBlue,
                ),
              ),
              const Gap(20),
              const Text(
                "Scannez le QR code dans l'application du client pour valider son dépôt.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001B3D),
                  height: 1.5,
                ),
              ),
              const Gap(12),
              const _BenefitRow(
                icon: Iconsax.flash_1,
                label: "Validation instantanée, sans saisie manuelle",
              ),
              const _BenefitRow(
                icon: Iconsax.shield_tick,
                label: "Moins d'erreurs, dépôt confirmé en un scan",
              ),
              const _BenefitRow(
                icon: Iconsax.tick_circle,
                label: "Disponible dès maintenant sur votre dashboard",
              ),
              const Gap(24),
              CustomButtom(
                text: "J'ai compris",
                color: AppColors.customBlue,
                borderRadius: BorderRadius.circular(25),
                fontSize: 16,
                onClick: onAccept,
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
