import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_recap.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/field_heading.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/pill_button.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/thousands_formatter.dart';

/// Confirmation affichée après la création : la résidence est en attente de
/// validation par l'équipe.
class ResidenceCreationSuccessView extends StatelessWidget {
  const ResidenceCreationSuccessView({
    super.key,
    required this.recap,
    required this.onEdit,
    required this.onHome,
  });

  final ResidenceRecap recap;
  final VoidCallback onEdit;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: CreationStyle.pagePadding,
                children: [
                  AppSpacing.gap24,
                  const _SuccessSeal(),
                  AppSpacing.gap12,
                  Text('Résidence créée !',
                      textAlign: TextAlign.center,
                      style:
                          AppTypography.h2.copyWith(color: AppColors.gray950)),
                  AppSpacing.gap8,
                  Text(
                    'Félicitations ! Rejoignez les propriétaires qui développent '
                    'leur activité avec Immo Plus.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.gray400),
                  ),
                  AppSpacing.gap20,
                  _RecapCard(recap: recap),
                  AppSpacing.gap24,
                  const FieldHeading(
                      title: 'Pour recevoir vos premières réservations'),
                  AppSpacing.gap12,
                  const _InfoTile(
                    asset: 'assets/svgs/shield-tick.svg',
                    title: 'Vérifier votre logement',
                    subtitle: 'Validation sous 24 heures si votre résidence '
                        'respecte nos conditions.',
                  ),
                  AppSpacing.gap20,
                  const _InfoTile(
                    asset: 'assets/svgs/percentage-circle.svg',
                    tint: Color(0xFFF5B400),
                    title: 'Commission',
                    subtitle: '7% de commission uniquement sur vos '
                        'réservations finalisées.',
                  ),
                  AppSpacing.gap20,
                  const _InfoTile(
                    asset: 'assets/svgs/calendar.svg',
                    title: 'Première réservation',
                    subtitle: 'Première réservation potentiellement en moins '
                        'de 14 jours en maintenant votre calendrier à jour et '
                        'vos notifications activées.',
                  ),
                  AppSpacing.gap24,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: PillButton(
                      label: 'Modifier',
                      variant: PillButtonVariant.secondary,
                      onPressed: onEdit,
                    ),
                  ),
                  AppSpacing.gap12,
                  Expanded(
                    flex: 2,
                    child: PillButton(label: 'Accueil', onPressed: onHome),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessSeal extends StatelessWidget {
  const _SuccessSeal();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/svgs/verify.svg',
        width: 64,
        height: 64,
        colorFilter: ColorFilter.mode(AppColors.green500, BlendMode.srcIn),
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.recap});

  final ResidenceRecap recap;

  String get _details => [
        if (recap.propertyTypeLabel.isNotEmpty) recap.propertyTypeLabel,
        '${recap.bedrooms} chambre(s)',
        '${ThousandsFormatter.format(recap.nightlyPrice, separator: ' ')} FCFA/nuit',
      ].join(' · ');

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CreationStyle.tileRadius),
        border: Border.all(color: CreationStyle.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: recap.coverPhoto == null
                ? ColoredBox(
                    color: AppColors.gray100,
                    child: Icon(Icons.home_work_outlined,
                        size: 40, color: AppColors.gray400),
                  )
                : Image.file(recap.coverPhoto!, fit: BoxFit.cover),
          ),
          Padding(
            padding: AppSpacing.edgeAll12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recap.name,
                    style: AppTypography.bodyMediumSemiBold
                        .copyWith(color: AppColors.gray950)),
                AppSpacing.gap4,
                Text(_details,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.gray700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.asset,
    this.tint,
    required this.title,
    required this.subtitle,
  });

  /// Icône SVG ; `tint` la recolore (sinon les couleurs du fichier sont gardées).
  final String asset;
  final Color? tint;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 8),
          child: SvgPicture.asset(
            asset,
            width: 24,
            height: 24,
            colorFilter:
                tint == null ? null : ColorFilter.mode(tint!, BlendMode.srcIn),
          ),
        ),
        AppSpacing.gap20,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.bodyMediumSemiBold
                      .copyWith(color: AppColors.gray950)),
              AppSpacing.gap4,
              Text(subtitle,
                  style:
                      AppTypography.caption.copyWith(color: AppColors.gray400)),
            ],
          ),
        ),
      ],
    );
  }
}
