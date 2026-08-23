import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/account/widgets/edit_identity_documents.dart';
import 'package:immoplus_pro/features/certification/models/certification_model.dart';
import 'package:immoplus_pro/features/certification/pages/certification_page.dart';
import 'package:immoplus_pro/features/contact_change/view/change_address_page.dart';
import 'package:immoplus_pro/features/contact_change/view/request_contact_change_page.dart';
import 'package:immoplus_pro/features/payment_method/pages/change_payment_method_page.dart';

class _ProfileStep {
  final String label;
  final IconData icon;
  final bool completed;

  /// Route vers laquelle rediriger quand l'étape n'est pas complétée.
  /// `null` = pas encore de page dédiée dans l'app → on retombe sur
  /// [CertificationPage].
  final String? routeName;
  final Object? routeExtra;

  const _ProfileStep({
    required this.label,
    required this.icon,
    required this.completed,
    this.routeName,
    this.routeExtra,
  });
}

/// Carte "Compléter le profil" affichée en haut du compte pro : un carrousel
/// auto-défilant des étapes de [ProfileVerifications], avec barre de
/// progression segmentée. Se masque d'elle-même une fois le profil complet.
class ProfileCompletionCard extends StatefulWidget {
  final ProfileVerifications verifications;

  const ProfileCompletionCard({super.key, required this.verifications});

  @override
  State<ProfileCompletionCard> createState() => _ProfileCompletionCardState();
}

class _ProfileCompletionCardState extends State<ProfileCompletionCard> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<_ProfileStep> get _steps {
    final v = widget.verifications;
    return [
      _ProfileStep(
        label: 'Photo & logo professionnel',
        icon: Icons.add_a_photo_outlined,
        completed: v.photoLogo,
        routeName: EditAccount.name,
      ),
      _ProfileStep(
        label: 'Numéros vérifiés',
        icon: Icons.verified_user_outlined,
        completed: v.numerosVerifies,
        routeName: RequestContactChangePage.name,
        routeExtra: ContactChangeType.phone,
      ),
      _ProfileStep(
        label: 'Identité / RCCM',
        icon: Icons.assignment_ind_outlined,
        completed: v.identiteRccm,
        routeName: EditIdentityDocuments.name,
      ),
      _ProfileStep(
        label: 'Email vérifié',
        icon: Icons.alternate_email_rounded,
        completed: v.email,
        routeName: RequestContactChangePage.name,
        routeExtra: ContactChangeType.email,
      ),
      _ProfileStep(
        label: 'Adresse renseignée',
        icon: Icons.location_on_outlined,
        completed: v.adresse,
        routeName: ChangeAddressPage.name,
      ),
      _ProfileStep(
        label: 'Moyen de paiement',
        icon: Icons.payment_outlined,
        completed: v.moyenPaiement,
        routeName: ChangePaymentMethodPage.name,
      ),
      _ProfileStep(
        label: 'Annonce complète',
        icon: Icons.home_work_outlined,
        completed: v.annonceComplete,
        // Quasiment toujours vraie côté backend, pas de cible dédiée.
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verifications.isComplete) return const SizedBox.shrink();

    final steps = _steps;
    final completed = widget.verifications.completedCount;
    final total = widget.verifications.totalCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Compléter le profil',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showWhySheet(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pourquoi ?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(2),
                      Icon(Icons.help_outline_rounded,
                          size: 15, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(14),
          _buildProgressBar(completed, total),
          const Gap(8),
          Text(
            '$completed sur $total étapes',
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(16),
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: steps.length,
            options: CarouselOptions(
              height: 62,
              viewportFraction: 0.82,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              autoPlayCurve: Curves.easeOutCubic,
              padEnds: false,
              onPageChanged: (index, reason) =>
                  setState(() => _currentIndex = index),
            ),
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _StepTile(step: steps[index]),
              );
            },
          ),
          const Gap(12),
          Center(child: _buildDots(steps.length)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int completed, int total) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i < completed;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: filled
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: active ? 18 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  void _showWhySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pourquoi compléter mon profil ?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const Gap(12),
            Text(
              'Un profil complet rassure les locataires, améliore votre visibilité dans les résultats de recherche et augmente vos chances d\'obtenir la certification ImmoPlus Pro.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.pushNamed(CertificationPage.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Voir ma certification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

class _StepTile extends StatelessWidget {
  final _ProfileStep step;

  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final bool isDone = step.completed;
    final Color fg = isDone ? Colors.white : AppColors.primary;

    return Material(
      color: isDone ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => step.routeName != null
            ? context.pushNamed(step.routeName!, extra: step.routeExtra)
            : context.pushNamed(CertificationPage.name),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDone
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.35),
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              Icon(step.icon, size: 18, color: fg),
              const Gap(10),
              Expanded(
                child: Text(
                  step.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
              const Gap(6),
              Icon(
                isDone ? Iconsax.tick_circle : Icons.chevron_right_rounded,
                size: 17,
                color: fg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
