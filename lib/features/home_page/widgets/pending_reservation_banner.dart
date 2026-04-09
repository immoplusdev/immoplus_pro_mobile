import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';

class _Constants {
  static const double borderRadius = 16.0;
  static const double iconStripWidth = 64.0;
  static const double iconBoxSize = 38.0;
  static const double iconBoxRadius = 10.0;
  static const double iconSize = 20.0;
  static const double chevronSize = 18.0;
  static const double titleFontSize = 13.0;
  static const double subtitleFontSize = 11.0;
  static const double timerFontSize = 16.0;
  static const double shadowBlur = 16.0;
  static const double shadowAlpha = 0.12;
  static const double iconBoxAlpha = 0.25;
  static const EdgeInsets margin = EdgeInsets.fromLTRB(12, 8, 12, 0);
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(12, 10, 8, 10);
  static const EdgeInsets timerPadding = EdgeInsets.symmetric(horizontal: 12);
  static const Offset shadowOffset = Offset(0, 4);
  static const Duration pulseDuration = Duration(milliseconds: 1200);
  static const Duration countdownInterval = Duration(seconds: 1);
  static const Duration refetchDelay = Duration(seconds: 50);

  static const Color bgColor = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFAB8DFF);
  static const Color accentLight = Color(0xFFEEE8FF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF888888);

  static const String title = 'Une demande de validation du séjour a été reçu';
  static const String subtitle = 'Cliquer pour valider';
}

class ReservationPendingBanner extends StatefulWidget {
  const ReservationPendingBanner({super.key});

  @override
  State<ReservationPendingBanner> createState() =>
      _ReservationPendingBannerState();
}

class _ReservationPendingBannerState extends State<ReservationPendingBanner> {
  final _service = getIt<PendingReservationOverlayService>();

  ReservationModel? _reservation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservation();
    _service.refreshNotifier.addListener(_onRefresh);
  }

  void _onRefresh() => _fetchReservation();

  Future<void> _fetchReservation() async {
    if (mounted) setState(() => _loading = true);

    final reservation = await _service.fetchLatestPendingReservation();

    if (!mounted) return;

    setState(() {
      _reservation = reservation;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _service.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _reservation == null) {
      return const SizedBox.shrink();
    }

    return _BannerContent(
      reservation: _reservation!,
      onTap: () => AppRouter.router.push(PendingReservationsPage.route()),
      onCountdownEnd: _fetchReservation,
    );
  }
}

class _BannerContent extends StatefulWidget {
  final ReservationModel reservation;
  final VoidCallback onTap;
  final VoidCallback onCountdownEnd;

  const _BannerContent({
    required this.reservation,
    required this.onTap,
    required this.onCountdownEnd,
  });

  @override
  State<_BannerContent> createState() => _BannerContentState();
}

class _BannerContentState extends State<_BannerContent>
    with SingleTickerProviderStateMixin {
  late int _secondsLeft;
  Timer? _countdownTimer;
  Timer? _refetchTimer;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _computeRemaining();

    _pulseController = AnimationController(
      vsync: this,
      duration: _Constants.pulseDuration,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _countdownTimer = Timer.periodic(_Constants.countdownInterval, (_) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _countdownTimer?.cancel();
        _scheduleRefetch();
      }
    });
  }

  void _computeRemaining() {
    final deadline = DateTime.tryParse(
      widget.reservation.delaisProprietaireReponse ?? '',
    );
    if (deadline == null) {
      _secondsLeft = 0;
      return;
    }
    final diff = deadline.difference(DateTime.now());
    _secondsLeft = diff.isNegative ? 0 : diff.inSeconds;
  }

  void _scheduleRefetch() {
    _refetchTimer = Timer(_Constants.refetchDelay, () {
      if (mounted) widget.onCountdownEnd();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _refetchTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: _Constants.margin,
        decoration: BoxDecoration(
          color: _Constants.bgColor,
          borderRadius: BorderRadius.circular(_Constants.borderRadius),
          boxShadow: [
            BoxShadow(
              color:
                  _Constants.accent.withValues(alpha: _Constants.shadowAlpha),
              blurRadius: _Constants.shadowBlur,
              offset: _Constants.shadowOffset,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: _Constants.iconStripWidth,
                color: _Constants.accent,
                child: Center(
                  child: ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: _Constants.iconBoxSize,
                      height: _Constants.iconBoxSize,
                      decoration: BoxDecoration(
                        color: _Constants.accentLight
                            .withValues(alpha: _Constants.iconBoxAlpha),
                        borderRadius:
                            BorderRadius.circular(_Constants.iconBoxRadius),
                      ),
                      child: const Icon(
                        Iconsax.timer_1,
                        color: _Constants.accentLight,
                        size: _Constants.iconSize,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: _Constants.contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        _Constants.title,
                        style: TextStyle(
                          fontSize: _Constants.titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: _Constants.textPrimary,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3),
                      Text(
                        _Constants.subtitle,
                        style: TextStyle(
                          fontSize: _Constants.subtitleFontSize,
                          color: _Constants.textMuted,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: _Constants.timerPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formattedTime,
                      style: const TextStyle(
                        fontSize: _Constants.timerFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: _Constants.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: _Constants.textMuted,
                      size: _Constants.chevronSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
