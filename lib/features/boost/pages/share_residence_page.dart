import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/boost/models/residence_share_link_model.dart';
import 'package:immoplus_pro/features/boost/utils/boost_residence_formatter.dart';
import 'package:immoplus_pro/features/boost/widgets/boost_residence_card.dart';

/// Paramètres transmis à [ShareResidencePage] lors de la navigation.
class ShareResidencePageArgs {
  const ShareResidencePageArgs({
    required this.residence,
    required this.shareLink,
  });

  final ResidenceModel residence;
  final ResidenceShareLinkModel shareLink;
}

/// Page « Partager la résidence » inspirée de la maquette Figma (Boost),
/// utilisant le partage natif [ShareService] sans lister les réseaux sociaux.
class ShareResidencePage extends StatefulWidget {
  const ShareResidencePage({
    super.key,
    required this.residence,
    required this.shareLink,
  });

  final ResidenceModel residence;
  final ResidenceShareLinkModel shareLink;

  static const String name = 'SHARE_RESIDENCE_PAGE';
  static const String routePath = '/boost_residences/share';

  @override
  State<ShareResidencePage> createState() => _ShareResidencePageState();
}

class _ShareResidencePageState extends State<ShareResidencePage> {
  late final TextEditingController _messageController;
  final FocusNode _messageFocusNode = FocusNode();
  final GlobalKey _shareButtonKey = GlobalKey();
  bool _isEditingMessage = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: BoostResidenceFormatter.buildDefaultInvitationMessage(
        widget.residence,
        widget.shareLink.url,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: widget.shareLink.url));
    EasyLoadingHandler.showSuccessToast(
      text: 'Lien copié dans le presse-papiers',
    );
  }

  void _toggleEditMessage() {
    setState(() {
      _isEditingMessage = !_isEditingMessage;
    });
    if (_isEditingMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _messageFocusNode.requestFocus();
      });
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _shareLink() async {
    final textToShare = _messageController.text.trim().isNotEmpty
        ? _messageController.text.trim()
        : widget.shareLink.url;

    final origin = ShareService.getSharePositionFromKey(_shareButtonKey);
    await ShareService.shareText(
      text: textToShare,
      subject: widget.residence.nom.isNotEmpty
          ? widget.residence.nom
          : 'Partager la résidence',
      context: context,
      sharePositionOrigin: origin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final residence = widget.residence;
    final imageUrl = BoostResidenceFormatter.resolveImageUrl(residence);
    final subtitle = BoostResidenceFormatter.formatSubtitle(residence);
    final nightlyPrice =
        BoostResidenceFormatter.formatNightlyPrice(residence.prixReservation);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête personnalisé : bouton retour circulaire + titre centré
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(AppRadii.rFull),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            size: 24,
                            color: AppColors.gray950,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Partager la résidence',
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray950,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sous-titre centré
                    Center(
                      child: Text(
                        'Faites découvrir votre logement à vos proches et à vos contacts pour recevoir plus de réservations.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13.5,
                          color: AppColors.gray400,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const Gap(20),

                    // Carte récapitulative de la résidence
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadii.r16),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Row(
                        children: [
                          BoostResidenceThumbnail(
                            imageUrl: imageUrl,
                            size: 80,
                            borderRadius: AppRadii.r12,
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  residence.nom.isNotEmpty
                                      ? residence.nom
                                      : 'Résidence',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gray950,
                                  ),
                                ),
                                if (subtitle.isNotEmpty) ...[
                                  const Gap(4),
                                  Text(
                                    subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 12,
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ],
                                const Gap(6),
                                Text(
                                  nightlyPrice,
                                  style: AppTypography.bodyMediumSemiBold.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Section : Lien de la résidence
                    Text(
                      'Lien de la résidence',
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray950,
                      ),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                      decoration: BoxDecoration(
                        color: AppColors.immoBgBrandSubtle,
                        borderRadius: BorderRadius.circular(AppRadii.r16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.link_21,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              widget.shareLink.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMediumMedium.copyWith(
                                fontSize: 13.5,
                                color: AppColors.gray700,
                              ),
                            ),
                          ),
                          const Gap(8),
                          ElevatedButton.icon(
                            onPressed: _copyLink,
                            icon: const Icon(
                              Iconsax.copy,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Copier',
                              style: AppTypography.labelMedium.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              minimumSize: const Size(0, 40),
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Section : Message d'invitation
                    Text(
                      'Message d’invitation',
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray950,
                      ),
                    ),
                    const Gap(12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadii.r16),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isEditingMessage)
                            TextField(
                              controller: _messageController,
                              focusNode: _messageFocusNode,
                              maxLines: null,
                              minLines: 3,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 13.5,
                                color: AppColors.gray700,
                                height: 1.45,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.all(10),
                                filled: true,
                                fillColor: AppColors.immoBgSurfaceMuted,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.r12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          else
                            Text(
                              _messageController.text,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 13.5,
                                color: AppColors.gray700,
                                height: 1.45,
                              ),
                            ),
                          const Gap(12),
                          GestureDetector(
                            onTap: _toggleEditMessage,
                            child: Text(
                              _isEditingMessage
                                  ? 'Terminer'
                                  : 'Modifier le message',
                              style: AppTypography.bodyMediumSemiBold.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),

                    // Bannière verte : Bonus de visibilité
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.green50,
                        borderRadius: BorderRadius.circular(AppRadii.r16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.emerald700.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.emerald700,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bonus de visibilité, jusqu’à +15%',
                                  style: AppTypography.titleSmall.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.emerald700,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Les visites qualifiées et actions utiles sont prises en compte. Les clics répétés ne gonflent pas votre score.',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 12,
                                    color: AppColors.gray500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bouton principal en bas de page : Partager le lien via ShareService
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                key: _shareButtonKey,
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _shareLink,
                  icon: const Icon(
                    Iconsax.send_2,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Partager le lien',
                    style: AppTypography.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
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
