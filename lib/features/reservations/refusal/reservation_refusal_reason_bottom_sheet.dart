import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/motif_echec_reponse_model.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/motif_item.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/calendar/calendar_page_v2.dart';
import 'package:immoplus_pro/features/reservations/refusal/widgets/refusal_reason_recap_card.dart';
import 'package:immoplus_pro/features/reservations/refusal/widgets/residence_mini_card.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';

enum ProFailureReasonCode {
  autre('AUTRE');

  final String value;
  const ProFailureReasonCode(this.value);

  static bool isAutre(String? code) =>
      code?.trim().toUpperCase() == ProFailureReasonCode.autre.value;
}

abstract class _Constants {
  static const double sheetTopRadius = 24.0;
  static const double itemRadius = 12.0;
  static const double buttonRadius = 12.0;
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;
  static const double dragHandleRadius = 2.0;

  static const Duration animDuration = Duration(milliseconds: 300);
  static const Curve animCurve = Curves.easeInOutCubic;

  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(20, 12, 20, 24);
  static const EdgeInsets itemPadding =
      EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0);

  static const Color sheetBgColor = Colors.white;
  static const Color dragHandleColor = Color(0xFFCBD5E1);
  static const Color itemBorderColor = Color(0xFFE2E8F0);
  static const Color itemSelectedBorderColor = Color(0xFF2744DE);
  static const Color itemSelectedBgColor = Color(0xFFF4F6FE);
  static const Color itemUnselectedBgColor = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF2744DE);
  static const Color successGreen = Color(0xFF17A30D);
  static const Color successGreenLight = Color(0xFFEAF8EC);

  static const Color titleColor = Color(0xFF0F172A);
  static const Color subtitleColor = Color(0xFF64748B);
  static const Color textColor = Color(0xFF1E293B);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: titleColor,
    height: 1.25,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: subtitleColor,
    height: 1.4,
  );

  static const TextStyle itemTextStyle = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const TextStyle itemSelectedTextStyle = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: primaryBlue,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class ReservationRefusalReasonBottomSheet extends StatefulWidget {
  final String reservationId;
  final ReservationModel? reservation;

  const ReservationRefusalReasonBottomSheet({
    super.key,
    required this.reservationId,
    this.reservation,
  });

  static Future<void> show(
    BuildContext context, {
    required String reservationId,
    ReservationModel? reservation,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      useRootNavigator: true,
      builder: (context) => ReservationRefusalReasonBottomSheet(
        reservationId: reservationId,
        reservation: reservation,
      ),
    );
  }

  @override
  State<ReservationRefusalReasonBottomSheet> createState() =>
      _ReservationRefusalReasonBottomSheetState();
}

class _ReservationRefusalReasonBottomSheetState
    extends State<ReservationRefusalReasonBottomSheet> {
  int _currentStep = 1;

  bool _isLoadingMotifs = true;
  String? _motifsError;
  List<MotifItem> _motifs = [];

  MotifItem? _selectedMotif;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  bool _isSubmitting = false;

  MotifEchecReponseData? _reponseData;

  @override
  void initState() {
    super.initState();
    _fetchMotifs();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchMotifs() async {
    setState(() {
      _isLoadingMotifs = true;
      _motifsError = null;
    });

    try {
      final response =
          await LogmentRepository.getMotifsEchec(widget.reservationId);
      final data = response.data;

      if (!mounted) return;

      if (data.dejaRepondu) {
        final existingReponse =
            await LogmentRepository.getMotifEchecReponse(widget.reservationId);
        if (existingReponse != null && mounted) {
          setState(() {
            _reponseData = existingReponse.data;
            _currentStep = 2;
            _isLoadingMotifs = false;
          });
          return;
        }
      }

      setState(() {
        _motifs = data.motifs;
        _isLoadingMotifs = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _motifsError = e.toString();
        _isLoadingMotifs = false;
      });
    }
  }

  Future<void> _submitMotif() async {
    if (_selectedMotif == null) {
      EasyLoadingHandler.showErrorToast(
          text: "Veuillez sélectionner un motif de refus.");
      return;
    }

    final isAutre = ProFailureReasonCode.isAutre(_selectedMotif!.code);
    final comment = _commentController.text.trim();

    if (isAutre && comment.isEmpty) {
      EasyLoadingHandler.showErrorToast(
          text: "Veuillez préciser la raison de votre refus.");
      _commentFocusNode.requestFocus();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await LogmentRepository.submitMotifEchec(
        widget.reservationId,
        reasonCode: _selectedMotif!.code,
        comment: comment.isNotEmpty ? comment : null,
      );

      if (!mounted) return;

      setState(() {
        _reponseData = response.data;
        _isSubmitting = false;
        _currentStep = 2;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      EasyLoadingHandler.showErrorToast(
        text: "Impossible d'enregistrer le motif. Veuillez réessayer.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _Constants.sheetBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_Constants.sheetTopRadius),
          topRight: Radius.circular(_Constants.sheetTopRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SingleChildScrollView(
            child: AnimatedSize(
              duration: _Constants.animDuration,
              curve: _Constants.animCurve,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: _Constants.animDuration,
                switchInCurve: _Constants.animCurve,
                switchOutCurve: _Constants.animCurve,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _currentStep == 1
                    ? _buildStepOne(key: const ValueKey('step_1'))
                    : _buildStepTwo(key: const ValueKey('step_2')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: _Constants.dragHandleWidth,
        height: _Constants.dragHandleHeight,
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        decoration: BoxDecoration(
          color: _Constants.dragHandleColor,
          borderRadius: BorderRadius.circular(_Constants.dragHandleRadius),
        ),
      ),
    );
  }

  Widget _buildStepOne({required Key key}) {
    final isAutre = ProFailureReasonCode.isAutre(_selectedMotif?.code);

    return Padding(
      key: key,
      padding: _Constants.sheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const Gap(8),

          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pourquoi avez-vous refusé ?",
                      style: _Constants.titleStyle,
                    ),
                    Gap(4),
                    Text(
                      "Sélectionnez la raison de votre refus pour nous aider à ajuster les disponibilités.",
                      style: _Constants.subtitleStyle,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: _Constants.subtitleColor,
              ),
            ],
          ),
          const Gap(14),

          // Mini Card if reservation is present
          if (widget.reservation != null) ...[
            ResidenceMiniCard(reservation: widget.reservation!),
            const Gap(16),
          ],

          // Motifs Content
          if (_isLoadingMotifs) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _Constants.primaryBlue,
                ),
              ),
            ),
          ] else if (_motifsError != null) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      size: 36,
                      color: Colors.orange,
                    ),
                    const Gap(8),
                    const Text(
                      "Impossible de charger les motifs.",
                      style: _Constants.subtitleStyle,
                    ),
                    const Gap(12),
                    TextButton.icon(
                      onPressed: _fetchMotifs,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text("Réessayer"),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // List of Motifs
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _motifs.length,
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                final motif = _motifs[index];
                final isSelected = _selectedMotif?.code == motif.code;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMotif = motif;
                    });
                  },
                  borderRadius: BorderRadius.circular(_Constants.itemRadius),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: _Constants.itemPadding,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _Constants.itemSelectedBgColor
                          : _Constants.itemUnselectedBgColor,
                      borderRadius:
                          BorderRadius.circular(_Constants.itemRadius),
                      border: Border.all(
                        color: isSelected
                            ? _Constants.itemSelectedBorderColor
                            : _Constants.itemBorderColor,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 18,
                          color: isSelected
                              ? _Constants.primaryBlue
                              : _Constants.subtitleColor,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            motif.label,
                            style: isSelected
                                ? _Constants.itemSelectedTextStyle
                                : _Constants.itemTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // TextField if AUTRE
            if (isAutre) ...[
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Précisions (requis)",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _Constants.titleColor,
                    ),
                  ),
                  const Gap(6),
                  TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    maxLines: 3,
                    minLines: 2,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Veuillez préciser la raison de votre refus...",
                      hintStyle: const TextStyle(
                        fontSize: 13.0,
                        color: _Constants.subtitleColor,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(_Constants.itemRadius),
                        borderSide: const BorderSide(
                          color: _Constants.itemBorderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(_Constants.itemRadius),
                        borderSide: const BorderSide(
                          color: _Constants.itemBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(_Constants.itemRadius),
                        borderSide: const BorderSide(
                          color: _Constants.primaryBlue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Gap(20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_isSubmitting || _selectedMotif == null)
                    ? null
                    : _submitMotif,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Constants.primaryBlue,
                  disabledBackgroundColor:
                      _Constants.primaryBlue.withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_Constants.buttonRadius),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Confirmer le motif",
                        style: _Constants.buttonTextStyle,
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepTwo({required Key key}) {
    final reasonLabel =
        _selectedMotif?.label ?? _reponseData?.reasonCode ?? 'Motif enregistré';
    final comment = _reponseData?.comment ?? _commentController.text.trim();
    final respondedAt = _reponseData?.respondedAt ?? DateTime.now();

    return Padding(
      key: key,
      padding: _Constants.sheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandle(),
          const Gap(16),

          // Validation Badge
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: _Constants.successGreenLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/verify.svg',
                width: 38,
                height: 38,
                colorFilter: const ColorFilter.mode(
                  _Constants.successGreen,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Gap(16),

          const Text(
            "Merci, c'est noté !",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: _Constants.titleColor,
            ),
          ),
          const Gap(6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Votre retour a bien été pris en compte. Il nous aide à améliorer la gestion des disponibilités.",
              textAlign: TextAlign.center,
              style: _Constants.subtitleStyle,
            ),
          ),
          const Gap(20),

          // Recap Card
          Align(
            alignment: Alignment.centerLeft,
            child: RefusalReasonRecapCard(
              reasonLabel: reasonLabel,
              comment: comment.isNotEmpty ? comment : null,
              respondedAt: respondedAt,
            ),
          ),

          if (widget.reservation != null) ...[
            const Gap(12),
            ResidenceMiniCard(reservation: widget.reservation!),
          ],

          const Gap(24),

          // Close Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(
                  CalendarPageV2.routePath,
                  extra: {'showPostRefusalCalendarNotice': true},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _Constants.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_Constants.buttonRadius),
                ),
              ),
              child: const Text(
                "Fermer",
                style: _Constants.buttonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
