import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/utils/utils.dart';

/// Récap du montant à retirer pour une réservation dont la présence vient
/// d'être validée (scan QR) — mirror exact du format de
/// [NotificationActifSheet]/[QrScanDepositSheet].
class WithdrawalRecapSheet extends StatelessWidget {
  const WithdrawalRecapSheet({
    super.key,
    required this.propertyName,
    required this.montantTotal,
    required this.montantCommission,
    required this.onContinue,
    required this.onMaybeLater,
  });

  final String propertyName;
  final double montantTotal;
  final double montantCommission;
  final VoidCallback onContinue;
  final VoidCallback onMaybeLater;

  double get _montantAPercevoir => montantTotal - montantCommission;

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
                  Iconsax.wallet_money,
                  size: 32,
                  color: AppColors.customBlue,
                ),
              ),
              const Gap(20),
              const Text(
                "Présence validée !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001B3D),
                  height: 1.5,
                ),
              ),
              const Gap(8),
              Text(
                propertyName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const Gap(20),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.E6F5FF,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _AmountRow(
                      label: "Montant total",
                      value: Utils.formatCurrency(montantTotal),
                    ),
                    const Gap(8),
                    _AmountRow(
                      label: "Commission",
                      value: "- ${Utils.formatCurrency(montantCommission)}",
                    ),
                    const Gap(10),
                    const Divider(height: 1, color: Color(0x1F001B3D)),
                    const Gap(10),
                    _AmountRow(
                      label: "Montant à retirer",
                      value: Utils.formatCurrency(_montantAPercevoir),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const Gap(24),
              CustomButtom(
                text: "Continuer la demande",
                color: AppColors.customBlue,
                borderRadius: BorderRadius.circular(25),
                fontSize: 16,
                onClick: onContinue,
              ),
              const Gap(8),
              TextButton(
                onPressed: onMaybeLater,
                child: const Text(
                  "Plus tard",
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

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 14 : 12,
            color: emphasize ? const Color(0xFF001B3D) : Colors.black54,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 20 : 13,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            color: emphasize ? AppColors.customBlue : Colors.black87,
          ),
        ),
      ],
    );
  }
}
