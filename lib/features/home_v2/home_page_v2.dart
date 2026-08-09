import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/features/home_v2/pages/booking_page_v2.dart';
import 'package:immoplus_pro/features/home_v2/pages/visit_page_v2.dart';
import 'package:immoplus_pro/features/notification/notification_page.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/features/notification/widgets/notification_actif_sheet.dart';
import 'package:immoplus_pro/features/reservations/pending/qr_scan_deposit_sheet.dart';
import 'package:immoplus_pro/features/reservations/pending/withdrawal_recap_sheet.dart';
import 'package:immoplus_pro/services/notification_actif_service.dart';
import 'package:dio/dio.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/services/qr_scan_announcement_service.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/services/notification_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:immoplus_pro/services/remote_config_service.dart';
import 'package:immoplus_pro/services/version_update_service.dart';
import 'package:immoplus_pro/widgets/config_env.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/estates/estates_page_v2.dart';
// import 'package:immoplus_pro/features/furnitures/furnitures_page_v2.dart';
import 'package:immoplus_pro/features/residence/residences_page_v2.dart';
import 'package:immoplus_pro/features/certification/pages/certification_page.dart';
import 'package:immoplus_pro/features/certification/widgets/certification_announce_sheet.dart';
import 'package:immoplus_pro/features/certification/models/certification_model.dart';
import 'package:immoplus_pro/features/certification/repositories/certification_repository.dart';
import 'package:immoplus_pro/services/certification_announcement_service.dart';
import 'package:immoplus_pro/utils/contact_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_code_page_v2.dart';
import 'package:immoplus_pro/features/payments/payments_page_v2.dart';
import 'package:immoplus_pro/features/payments/screen/withdraw_form_screen_v2.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/enums/account_source.dart';
import 'package:immoplus_pro/cubits/banners/banners_cubit.dart';
import 'package:immoplus_pro/features/home_v2/widgets/banner_card.dart';
import 'package:immoplus_pro/features/reservations/pending/qr_scanner_page.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';

class HomePageV2 extends StatefulWidget {
  final String? paiementId;
  const HomePageV2({super.key, this.paiementId});
  static String name = 'HOME_PAGE';
  static const String routePath = '/home';

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _remoteConfig = getIt<RemoteConfigService>();
  late TabController _tabController;

  UserModelSchema? currentUser;
  bool _isUnlocked = false;

  // final GlobalKey _scannerTutorialKey = GlobalKey(); // voir tuile commentée plus bas
  // final GlobalKey _certificationTutorialKey = GlobalKey(); // voir tuile commentée plus bas

  final ValueNotifier<BookingFilterV2> _bookingFilterNotifier =
      ValueNotifier(BookingFilterV2.nouvelle);
  final ValueNotifier<VisitFilterV2> _visitFilterNotifier =
      ValueNotifier(VisitFilterV2.all);

  late BannersCubit _bannersCubit;
  int _totalReservations = 0;
  int _totalVisits = 0;
  CertificationModel? _certificationData;
  Timer? _certifBadgeTimer;
  bool _showScorePercentInBadge = false;

  @override
  void initState() {
    super.initState();
    _bannersCubit = context.read<BannersCubit>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rafraîchir pour mettre à jour les filtres affichés
      }
    });
    currentUser = SessionManager().currentUser;

    context.read<WalletCubit>().onGetWallet();
    final notificationService = getIt<NotificationService>();
    notificationService.setupNotificationListener();

    _bannersCubit.fetchBanners(source: AccountSource.proApp.value);
    _bannersCubit.startPolling(source: AccountSource.proApp.value);
    _checkNotifActif();
    _loadCertificationBadge();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.paiementId != null) {
        _showPaiementDialog();
      }
      await UpdateService()
          .checkForUpdate(context, forceUpdate: _remoteConfig.forceUpgradeApp);
    });
  }

  void _checkNotifActif() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final shouldShow = await NotificationActifService.shouldShow();
      if (mounted && shouldShow) {
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withValues(alpha: 0.6),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (sheetCtx) => NotificationActifSheet(
            onAccept: () async {
              Navigator.of(sheetCtx).pop();
              await NotificationActifService.setStatus(
                  NotificationActifService.accepted);
              await _requestNotificationPermission();
            },
            onMaybeLater: () async {
              Navigator.of(sheetCtx).pop();
              await NotificationActifService.setStatus(
                  NotificationActifService.maybeLater);
            },
          ),
        );
      }
      // Enchaîné après le sheet notifications (accepté/fermé) pour ne
      // jamais superposer deux bottom sheets.
      await _checkQrScanAnnouncement();
    });
  }

  Future<void> _checkQrScanAnnouncement() async {
    if (!mounted) return;
    final shouldShow = await QrScanAnnouncementService.shouldShow();
    if (mounted && shouldShow) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (sheetCtx) => QrScanDepositSheet(
          onAccept: () async {
            Navigator.of(sheetCtx).pop();
            await QrScanAnnouncementService.markSeen();
          },
        ),
      );
    }
    // Enchaîné après les sheets (vu ou non) pour ne jamais superposer un
    // tooltip showcase par-dessus un bottom sheet encore visible.
    await _checkCertificationAnnouncement();
  }

  Future<void> _checkCertificationAnnouncement() async {
    if (!mounted) return;
    final shouldShow = await CertificationAnnouncementService.shouldShow();
    if (!mounted || !shouldShow) return;
    // Le sheet se contente de renvoyer le choix de l'utilisateur (pop
    // synchrone) : le travail asynchrone (markSeen, navigation) est
    // séquencé ici, après la fermeture du sheet.
    final accepted = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetCtx) => CertificationAnnounceSheet(
        onAccept: () => Navigator.of(sheetCtx).pop(true),
        onMaybeLater: () => Navigator.of(sheetCtx).pop(false),
      ),
    );
    if (!mounted) return;
    await CertificationAnnouncementService.markSeen();
    if (accepted == true) {
      if (!mounted) return;
      _goToCertification();
    }
  }

  /// Point d'entrée unique vers la page Certification, que ce soit via
  /// l'anneau de progression du dashboard ou via le bottom sheet d'annonce.
  void _goToCertification() {
    context.pushNamed(CertificationPage.name);
  }

  /// Charge le score de certification pour alimenter l'anneau de
  /// progression affiché autour de l'avatar. Échec silencieux : l'anneau
  /// reste simplement vide si l'appel échoue.
  Future<void> _loadCertificationBadge() async {
    try {
      final data = await CertificationRepository.getMyCertification();
      if (!mounted) return;
      setState(() => _certificationData = data);
      _startCertifBadgeAnimationIfNeeded();
    } catch (_) {
      // Silencieux : le badge/anneau reste masqué en cas d'échec.
    }
  }

  /// `true` uniquement quand toutes les conditions d'attribution du badge
  /// (`conditionsAttribution`) sont remplies — c'est ce champ, plutôt qu'un
  /// seuil de score, qui reflète fidèlement le statut "certifié" côté API.
  bool get _isCertified {
    final c = _certificationData?.conditionsAttribution;
    if (c == null) return false;
    return c.identiteVerifiee &&
        c.moyenPaiementVerifie &&
        c.avisMinimum &&
        c.reservationsMin10 &&
        c.fiabiliteMin14 &&
        c.aucuneSanctionActive;
  }

  /// Tant que le Pro n'est pas certifié, fait alterner le contenu du badge
  void _startCertifBadgeAnimationIfNeeded() {
    _certifBadgeTimer?.cancel();
    if (_isCertified) return;
    _certifBadgeTimer =
        Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (!mounted) return;
      setState(() => _showScorePercentInBadge = !_showScorePercentInBadge);
    });
  }

  /// Couleur de l'anneau ET de l'icône du badge selon le score de
  Color _certificationColor(int score) {
    if (score >= 85) return const Color(0xFFFFD700); // Or
    if (score >= 70) return const Color(0xFFC0C0C0); // Argent
    if (score >= 50) return const Color(0xFFCD7F32); // Bronze
    if (score > 0) return Colors.orange; // En progression
    return Colors.grey; // Pas commencé
  }

  /// Contenu du badge sur l'avatar : icône verify fixe une fois certifié,
  Widget _buildCertifBadgeContent() {
    final score = _certificationData?.scoreTotal ?? 0;
    final color = _certificationColor(score);
    final icon = SvgPicture.asset(
      "assets/svgs/verify.svg",
      key: const ValueKey('certif_badge_icon'),
      width: 14,
      height: 14,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

    if (_isCertified) return icon;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 0.6),
          end: Offset.zero,
        ).animate(animation);
        return ClipRect(
          child: SlideTransition(
            position: offset,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      child: _showScorePercentInBadge
          ? Padding(
              key: const ValueKey('certif_badge_score'),
              padding: const EdgeInsets.all(2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            )
          : icon,
    );
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {
      // Redirige vers les paramètres de notification si déjà refusé
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    } else if (status.isGranted) {
      await OneSignal.User.pushSubscription.optIn();
    }
  }

  void _showPaiementDialog() {
    context.pushNamed(
      PinCodePageV2.name,
      extra: () {
        setState(() {
          _isUnlocked = true;
        });
        context.pop();
      },
    );
  }

  Future<void> _scanAndValidatePresence() async {
    final qrToken = await QrScannerPage.scan(context);
    if (qrToken != null && qrToken.isNotEmpty) {
      EasyLoadingHandler.showLoadingToast(text: "Validation en cours...");
      try {
        await LogmentRepository.validerPresence(qrToken: qrToken);
        EasyLoadingHandler.hideLoadingToast();
        if (!mounted) return;
        final recapShown = await _showWithdrawalRecap(qrToken);
        if (!recapShown) {
          EasyLoadingHandler.showSuccessToast(text: "Présence validée !");
        }
      } catch (e) {
        EasyLoadingHandler.hideLoadingToast();
        await _showQrScanErrorDialog(e);
      }
    }
  }

  /// Décode la claim `rid` (id de réservation) du QR token sans vérifier sa
  String? _extractReservationIdFromQrToken(String qrToken) {
    try {
      final parts = qrToken.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> claims = jsonDecode(payload);
      return claims['rid'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _showWithdrawalRecap(String qrToken) async {
    final reservationId = _extractReservationIdFromQrToken(qrToken);
    if (reservationId == null) return false;

    final ReservationModel reservation;
    try {
      final response = await LogmentRepository.getReservation(id: reservationId);
      reservation = response.data;
    } catch (_) {
      return false;
    }

    if (!mounted) return false;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetCtx) => WithdrawalRecapSheet(
        propertyName: reservation.residence.nom,
        montantTotal: reservation.montantTotalReservation,
        montantCommission: reservation.montantCommission,
        onContinue: () {
          Navigator.of(sheetCtx).pop();
          _continueToWithdrawal(reservationId);
        },
        onMaybeLater: () => Navigator.of(sheetCtx).pop(),
      ),
    );
    return true;
  }

  /// S'assure que le coffre (code PIN) est déverrouillé avant d'ouvrir la
  void _continueToWithdrawal(String reservationId) {
    if (_isUnlocked) {
      context.pushNamed(WithdrawFormScreenV2.name, extra: reservationId);
      return;
    }
    context.pushNamed(
      PinCodePageV2.name,
      extra: () {
        setState(() => _isUnlocked = true);
        context.pop();
        context.pushNamed(WithdrawFormScreenV2.name, extra: reservationId);
      },
    );
  }

  /// Messages métier renvoyés par POST /reservations/action/valider-presence
  static const _qrScanErrorContent = <String, (String title, String description)>{
    'Le QR code a expiré. Veuillez générer un nouveau QR code.': (
      'QR code expiré',
      'Le QR code a expiré. Demandez au client de générer un nouveau QR code puis réessayez.',
    ),
    'QR code invalide.': (
      'QR code invalide',
      "Ce QR code n'est pas reconnu. Vérifiez qu'il s'agit bien du QR code de réservation du client.",
    ),
    'Accès interdit': (
      'Accès refusé',
      "Vous n'êtes pas autorisé à valider cette réservation.",
    ),
    "La réservation n'est pas encore payée.": (
      'Réservation non payée',
      "La réservation n'est pas encore payée. La présence ne peut pas être validée tant que le paiement n'est pas effectué.",
    ),
    'La présence du client a déjà été validée pour cette réservation.': (
      'Présence déjà validée',
      'La présence du client a déjà été validée pour cette réservation.',
    ),
    'Ce QR code a déjà été utilisé.': (
      'QR code déjà utilisé',
      'Ce QR code a déjà été utilisé et ne peut plus servir à valider une présence.',
    ),
  };

  Future<void> _showQrScanErrorDialog(Object error) async {
    final message = _extractErrorMessage(error);

    // Le backend a renvoyé un message : on l'affiche toujours dans le dialog
    // personnalisé (titre précis si on le reconnaît, sinon titre générique
    // mais le vrai message du backend) — jamais le toast générique tant
    // qu'on a de quoi informer le pro sur la vraie raison de l'échec.
    if (message != null) {
      final content = _qrScanErrorContent[message];
      if (!mounted) return;
      await AppDialog.show(
        title: content?.$1 ?? "Échec de la validation",
        description: content?.$2 ?? message,
        primaryButtonText: 'Fermer',
      );
      return;
    }

    EasyLoadingHandler.showErrorToast(text: "Validation échouée");
  }

  String? _extractErrorMessage(Object error) {
    if (error is! DioException) return null;
    final data = error.response?.data;
    if (data is! Map<String, dynamic>) return null;
    try {
      return ApiErrorResponse.fromJson(data).message;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _bannersCubit.stopPolling();
    _tabController.dispose();
    _pageController.dispose();
    _bookingFilterNotifier.dispose();
    _visitFilterNotifier.dispose();
    _certifBadgeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentsBadge(
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // L'en-tête bleu (fixed au scroll car pinned: true)
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 260,
                flexibleSpace: Stack(
                  children: [
                    FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Fond bleu avec coins arrondis prononcés
                          Container(
                            height: _Constants.blueHeaderHeight,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(_Constants.radiusMedium),
                                bottomRight:
                                    Radius.circular(_Constants.radiusMedium),
                              ),
                            ),
                          ),

                          // Barre de statut et d'infos utilisateur
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _Constants.paddingStandard,
                                vertical: _Constants.paddingMedium,
                              ),
                              child: BlocBuilder<LoginCubit, LoginCubitState>(
                                builder: (context, state) {
                                  currentUser = SessionManager().currentUser;
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _goToCertification,
                                        child: CircularStepProgressIndicator(
                                          totalSteps: 100,
                                          currentStep:
                                              _certificationData?.scoreTotal ??
                                                  0,
                                          stepSize: _Constants.certifRingStroke,
                                          padding: 0,
                                          roundedCap: (_, __) => true,
                                          selectedColor:
                                              _certificationColor(
                                                  _certificationData
                                                          ?.scoreTotal ??
                                                      0),
                                          unselectedColor:
                                              Colors.white.withOpacity(0.3),
                                    
                                          width: _Constants.avatarRadius * 2 +
                                              _Constants.certifRingStroke * 2,
                                          height: _Constants.avatarRadius * 2 +
                                              _Constants.certifRingStroke * 2,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    _Constants.avatarRadius,
                                                backgroundColor: Colors.white,
                                                backgroundImage: (currentUser
                                                            ?.avatar !=
                                                        null)
                                                    ? CachedNetworkImageProvider(
                                                        Utils.getImagePath(
                                                            id: currentUser!
                                                                .avatar!))
                                                    : const NetworkImage(
                                                            _Constants
                                                                .defaultAvatarUrl)
                                                        as ImageProvider,
                                              ),
                                              Positioned(
                                                bottom: -3,
                                                right: -3,
                                                child: Container(
                                                  width: _Constants
                                                      .certifBadgeDiameter,
                                                  height: _Constants
                                                      .certifBadgeDiameter,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.15),
                                                        blurRadius: 3,
                                                        offset:
                                                            const Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: _buildCertifBadgeContent(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Gap(_Constants.gapMedium),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              currentUser!.greetingText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Bienvenue dans votre dashboard",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(_Constants.gapMedium),
                                      IconButton(
                                        onPressed: () => context
                                            .push(NotificationPage.routePath()),
                                        icon: const Icon(
                                          Iconsax.notification,
                                          color: Colors.white,
                                          size: _Constants.iconSizeLarge,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Wallet superposé (bien à l'intérieur du Stack pour le clic)
                    Positioned(
                      left: _Constants.paddingStandard,
                      right: _Constants.paddingStandard,
                      bottom: 12,
                      child: _isUnlocked
                          ? _buildUnlockedWalletBanner()
                          : _buildLockedWalletBanner(),
                    ),
                  ],
                ),
              ),

              // Contenu du haut : Wallet + Tableau de bord
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BannerCard(
                      onDismiss: () {
                        context.read<BannersCubit>().setDismissed(true);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: _Constants.paddingStandard,
                        right: _Constants.paddingStandard,
                        bottom: _Constants.paddingStandard,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tableau de bord",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(_Constants.gapLarge),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              const crossAxisCount = 4;
                              const spacing = 16.0;
                              final itemWidth = (constraints.maxWidth -
                                      spacing * (crossAxisCount - 1)) /
                                  crossAxisCount;
                              return Wrap(
                                spacing: spacing,
                                runSpacing: 20,
                                children: [
                                  SizedBox(
                                    width: itemWidth,
                                    child: _buildDashboardAction(
                                      iconWidget: Center(
                                        child: SvgPicture.asset(
                                          Assets.svgs.buildings,
                                          width: 30,
                                        ),
                                      ),
                                      label: "Bien immobilier",
                                      onTap: () => context
                                          .pushNamed(EstatesPageV2.name),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _buildDashboardAction(
                                      iconWidget: Center(
                                        child: SvgPicture.asset(
                                          Assets.svgs.house,
                                          width: 30,
                                        ),
                                      ),
                                      label: "Résidences",
                                      onTap: () => context
                                          .pushNamed(ResidencesPageV2.name),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _buildDashboardAction(
                                      iconWidget: Center(
                                        child: SvgPicture.asset(
                                          "assets/svgs/send-sqaure-2.svg",
                                          width: 30,
                                        ),
                                      ),
                                      label: "Transactions",
                                      onTap: () => context
                                          .pushNamed(PaymentsPageV2.name),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _buildDashboardAction(
                                      iconWidget: Center(
                                        child: SvgPicture.asset(
                                          Assets.svgs.scan,
                                          width: 30,
                                        ),
                                      ),
                                      label: "Scanner",
                                      onTap: _scanAndValidatePresence,
                                    ),
                                  ),
                                  // Certification retirée du tableau de bord :
                                  // désormais accessible depuis la page Compte.
                                  // SizedBox(
                                  //   width: itemWidth,
                                  //   child: Showcase(
                                  //     key: _certificationTutorialKey,
                                  //     description:
                                  //         "📊 Consultez votre certification et votre niveau de confiance auprès des locataires.",
                                  //     tooltipBackgroundColor: Colors.white,
                                  //     textColor: Colors.black87,
                                  //     descTextStyle: const TextStyle(
                                  //       color: Colors.black87,
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //     targetBorderRadius:
                                  //         BorderRadius.circular(8),
                                  //     child: _buildDashboardAction(
                                  //       iconWidget: Center(
                                  //         child: SvgPicture.asset(
                                  //           "assets/svgs/verify.svg",
                                  //           width: 30,
                                  //         ),
                                  //       ),
                                  //       label: "Certification",
                                  //       onTap: _goToCertification,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _buildDashboardAction(
                                      iconWidget: Center(
                                        child: SvgPicture.asset(
                                          "assets/svgs/information.svg",
                                          width: 30,
                                        ),
                                      ),
                                      label: "Support",
                                      onTap: () => ContactUtils.showContact(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Onglets et Filtres épinglés (pinned)
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: _Constants.paddingStandard,
                                vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade200, width: 2)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _tabController.animateTo(0),
                                    child: Transform.translate(
                                      offset: const Offset(0, 2),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: _tabController.index == 0
                                                  ? AppColors.primary
                                                  : Colors.transparent,
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Réservations",
                                              style: TextStyle(
                                                color: _tabController.index == 0
                                                    ? AppColors.primary
                                                    : Colors.grey.shade600,
                                                fontWeight:
                                                    _tabController.index == 0
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Gap(6),
                                            if (_totalReservations > 0)
                                              Container(
                                                height: 17,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: _tabController.index ==
                                                          0
                                                      ? AppColors.primary
                                                      : Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border:
                                                      _tabController.index == 0
                                                          ? null
                                                          : Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 0.5),
                                                ),
                                                child: Text(
                                                  "$_totalReservations",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: _tabController
                                                                .index ==
                                                            0
                                                        ? Colors.white
                                                        : Colors.grey.shade600,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _tabController.animateTo(1),
                                    child: Transform.translate(
                                      offset: const Offset(0, 2),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: _tabController.index == 1
                                                  ? AppColors.primary
                                                  : Colors.transparent,
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Visites",
                                              style: TextStyle(
                                                color: _tabController.index == 1
                                                    ? AppColors.primary
                                                    : Colors.grey.shade600,
                                                fontWeight:
                                                    _tabController.index == 1
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Gap(6),
                                            if (_totalVisits > 0)
                                              Container(
                                                height: 17,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: _tabController.index ==
                                                          1
                                                      ? AppColors.primary
                                                      : Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border:
                                                      _tabController.index == 1
                                                          ? null
                                                          : Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 0.5),
                                                ),
                                                child: Text(
                                                  "$_totalVisits",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: _tabController
                                                                .index ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.grey.shade600,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Filtres statiques
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 15, bottom: 5),
                            child: Row(
                              children: _buildCurrentFilters(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              BookingPageV2(
                filterNotifier: _bookingFilterNotifier,
                onCountChanged: (count) {
                  if (_totalReservations != count) {
                    Future.microtask(() {
                      if (mounted) setState(() => _totalReservations = count);
                    });
                  }
                },
              ),
              VisitPageV2(
                filterNotifier: _visitFilterNotifier,
                onCountChanged: (count) {
                  if (_totalVisits != count) {
                    Future.microtask(() {
                      if (mounted) setState(() => _totalVisits = count);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildDashboardAction(
      {required Widget iconWidget,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: _Constants.actionCircleSize,
            height: _Constants.actionCircleSize,
            decoration: BoxDecoration(
              color: _Constants.primaryAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const Gap(_Constants.gapSmall),
          SizedBox(
            width: double.infinity,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildCurrentFilters() {
    if (_tabController.index == 0) {
      return [
        _buildFilterChip(
            "Tous",
            _bookingFilterNotifier.value == BookingFilterV2.all,
            () => setState(
                () => _bookingFilterNotifier.value = BookingFilterV2.all)),
        _buildFilterChip(
          "Nouvelle réservation",
          _bookingFilterNotifier.value == BookingFilterV2.nouvelle,
          () => setState(
              () => _bookingFilterNotifier.value = BookingFilterV2.nouvelle),
        ),
        _buildFilterChip(
            "Payées",
            _bookingFilterNotifier.value == BookingFilterV2.paid,
            () => setState(
                () => _bookingFilterNotifier.value = BookingFilterV2.paid)),
      ];
    } else {
      return [
        _buildFilterChip(
            "Tous",
            _visitFilterNotifier.value == VisitFilterV2.all,
            () =>
                setState(() => _visitFilterNotifier.value = VisitFilterV2.all)),
        _buildFilterChip(
            "Demande express",
            _visitFilterNotifier.value == VisitFilterV2.express,
            () => setState(
                () => _visitFilterNotifier.value = VisitFilterV2.express)),
        _buildFilterChip(
            "Demande normale",
            _visitFilterNotifier.value == VisitFilterV2.normal,
            () => setState(
                () => _visitFilterNotifier.value = VisitFilterV2.normal)),
      ];
    }
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
              color: isSelected ? AppColors.primary : Colors.blue.shade100),
          borderRadius: BorderRadius.circular(_Constants.radiusLarge),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedWalletBanner() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _showPaiementDialog,
          child: Container(
            height: _Constants.walletBannerHeight,
            padding: const EdgeInsets.all(_Constants.paddingLarge),
            decoration: _Constants.bannerDecoration,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _Constants.primaryAccent,
                    borderRadius:
                        BorderRadius.circular(_Constants.radiusCircular),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.white, size: 18),
                      Gap(_Constants.gapMedium),
                      Text(
                        "Cliquez ici pour déverrouiller votre coffre",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(15),
      ],
    );
  }

  Widget _buildUnlockedWalletBanner() {
    return BlocBuilder<WalletCubit, RequestState>(
      builder: (context, state) {
        if (state is WALLET) {
          final wallet = state.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: _Constants.walletBannerHeight,
                padding: const EdgeInsets.all(_Constants.paddingStandard),
                decoration: _Constants.bannerDecoration.copyWith(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed(WithdrawFormScreenV2.name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          color: _Constants.primaryAccent,
                          borderRadius:
                              BorderRadius.circular(_Constants.radiusCircular),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(Assets.svgs.retraitDollars),
                            Gap(_Constants.gapSmall),
                            Text(
                              "Retrait",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(_Constants.gapMedium),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBalanceColumnFixed(
                            label: "Solde disponible",
                            amount: wallet.availableBalance.toString(),
                            dotColor: Color(0xff1CA53F).withOpacity(.2),
                            dolarColor: Color(0xff1CA53F),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildBalanceColumnFixed(
                            label: "Solde en cours",
                            amount: wallet.pendingBalance.toString(),
                            dotColor: const Color(0xffF59E0B).withOpacity(.2),
                            dolarColor: Color(0xffF59E0B),
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(5),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xffFF4CD8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(_Constants.gapMedium),
                  const Text(
                    "Seul le solde disponible peut etre retiré.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const Gap(8),
            ],
          );
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  Widget _buildBalanceColumnFixed({
    required String label,
    required String amount,
    required Color dotColor,
    required Color dolarColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (crossAxisAlignment == CrossAxisAlignment.start) ...[
              Container(
                padding: EdgeInsets.all(5),
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  "assets/svgs/dollard.svg",
                  color: dolarColor,
                ),
              ),
              const Gap(_Constants.gapSmall),
            ],
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600)),
            if (crossAxisAlignment == CrossAxisAlignment.end) ...[
              const Gap(_Constants.gapSmall),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/svgs/dollard.svg",
                  color: dolarColor,
                ),
              ),
            ],
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                Utils.formatCurrency(double.parse(amount)),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const Gap(_Constants.gapSmall),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text("fcfa",
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
            ),
          ],
        ),
      ],
    );
  }
}

/// Constants internal to the file to avoid magic values
class _Constants {
  // Heights
  static const double blueHeaderHeight = 180.0;
  static const double walletBannerHeight = 130.0;

  static const double stickyHeaderHeight = 125.0;
  static const double tabHeight = 48.0;
  static const double actionCircleSize = 50.0;

  // Padding & Spacing
  static const double paddingStandard = 20.0;
  static const double paddingMedium = 15.0;
  static const double paddingLarge = 25.0;
  static const double gapSmall = 8.0;
  static const double gapMedium = 10.0;
  static const double gapLarge = 25.0;

  // BorderRadius
  static const double radiusExtraLarge = 40.0;
  static const double radiusLarge = 25.0;
  static const double radiusMedium = 20.0;
  static const double radiusCircular = 30.0;

  // Icons & Avatar
  static const double avatarRadius = 32.0;
  static const double iconSizeLarge = 22.0;
  static const double certifRingStroke = 4.0;
  static const double certifBadgeDiameter = 24.0;

  // Colors
  static const Color primaryAccent = Color(0xFF2744DE);

  // Common UI assets
  static const String defaultAvatarUrl =
      "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg";

  // Reusable Decorations
  static final BoxDecoration bannerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMedium),
    border: Border.all(color: AppColors.customBlue.withOpacity(.2)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 15,
        offset: const Offset(0, 10),
      )
    ],
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child);
  final Widget _child;
  @override
  double get minExtent => _Constants.stickyHeaderHeight;
  @override
  double get maxExtent => _Constants.stickyHeaderHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: _child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}
