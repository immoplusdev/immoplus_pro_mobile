import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

/// Sheet d'annonce de la certification — mirror exact du format flottant de
/// [NotificationActifSheet]/[QrScanDepositSheet]/[WithdrawalRecapSheet] :
/// marge + coins arrondis sur les 4 côtés, pas collé au bord de l'écran.
class CertificationAnnounceSheet extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onMaybeLater;

  const CertificationAnnounceSheet({
    super.key,
    required this.onAccept,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icône de certification
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svgs/verify.svg",
                        width: 50,
                      ),
                    ),
                  ),
                  const Gap(20),

                  // Titre
                  Text(
                    "Devenez un Pro Certifié",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),

                  // Description
                  Text(
                    "La certification renforce la confiance des locataires et vous fait gagner des bonus.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),

                  // Bonus cards
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _BonusCard(
                          color: const Color(0xFF1CA53F),
                          label: "Bonus à l'acceptation",
                          amount: "250 F CFA",
                          description:
                              "À chaque réservation acceptée, une fois confirmée.",
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _BonusCard(
                          color: AppColors.primary,
                          label: "Bonus de performance",
                          amount: "20 000 F CFA",
                          description:
                              "Dès votre premier palier de 2 000 000 F CFA de CA validé.",
                        ),
                      ),
                    ],
                  ),
                  const Gap(28),

                  // Bouton d'action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Voir ma certification",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Gap(4),
                ],
              ),
            ),

            // Bouton de fermeture (haut-droite)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onMaybeLater,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusCard extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String description;

  const _BonusCard({
    required this.color,
    required this.label,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const Gap(6),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Gap(6),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
