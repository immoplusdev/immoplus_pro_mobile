import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';

/// Aperçu du montant reversé au propriétaire à partir du tarif saisi.
class PriceCommissionSimulator extends StatelessWidget {
  const PriceCommissionSimulator({super.key, required this.price});

  final num? price;

  static const double _commissionRate = 0.07;
  static final NumberFormat _amountFormat = NumberFormat('#,##0', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final enteredPrice = price?.toDouble();
    if (enteredPrice == null || enteredPrice <= 0) {
      return const SizedBox.shrink();
    }

    final commission = (enteredPrice * _commissionRate).round();
    final ownerAmount = enteredPrice.round() - commission;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Montant à recevoir',
                  style: AppTypography.bodyLargeSemiBold
                      .copyWith(color: AppColors.primary),
                ),
              ),
              Text(
                '${_amountFormat.format(ownerAmount)} FCFA',
                style: AppTypography.bodyLargeSemiBold
                    .copyWith(color: AppColors.gray950),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Commission 7 %',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.gray400),
                ),
              ),
              Text(
                '${_amountFormat.format(commission)} FCFA',
                style:
                    AppTypography.bodyMedium.copyWith(color: AppColors.gray700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
