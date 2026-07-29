import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/data/models/rating/guest_behavior.dart';
import 'package:immoplus_pro/data/models/rating/host_rating_request_dto.dart';
import 'package:immoplus_pro/data/models/rating/property_condition.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/ratings/logic/ratings_cubit.dart';
import 'package:immoplus_pro/features/ratings/logic/ratings_state.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:intl/intl.dart';

class CreateRatingPage extends StatelessWidget {
  static const name = 'create_rating_page';
  static String routePath() => '/rating/create/:id';
  static String route({required String id}) => '/rating/create/$id';

  final String reservationId;

  const CreateRatingPage({super.key, required this.reservationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Évaluer le séjour"),
      ),
      body: BlocProvider(
        create: (_) => RatingsCubit(),
        child: RatingBottomSheet(
          reservation: ReservationModel(id: reservationId),
        ),
      ),
    );
  }
}

class RatingBottomSheet extends StatefulWidget {
  final ReservationModel reservation;

  const RatingBottomSheet({super.key, required this.reservation});

  static Future<bool?> show(BuildContext context,
      {required ReservationModel reservation}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => RatingsCubit(),
        child: RatingBottomSheet(reservation: reservation),
      ),
    );
  }

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int _rating = 0;
  GuestBehavior? _behaviorTag;
  PropertyCondition? _stateTag;
  bool? _recommendClient = true;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ToastUtils.showError(title: 'Veuillez attribuer une note au client');
      return;
    }

    final dto = HostRatingRequestDto(
      reservationId: widget.reservation.id,
      clientRating: _rating,
      clientFeedback: _feedbackController.text.trim(),
      guestBehavior: _behaviorTag,
      propertyCondition: _stateTag,
      wouldRecommend: _recommendClient ?? true,
    );

    context.read<RatingsCubit>().submitRating(dto);
  }

  Widget _buildPillButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2548E5) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? const Color(0xFF2548E5) : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTogglePill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2548E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    final clientFirstName = widget.reservation.client.firstName;
    final clientLastName = widget.reservation.client.lastName;
    final displayName =
        [clientFirstName, clientLastName].where((s) => s.isNotEmpty).join(' ');
    final initialLetter =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '';

    String dateLabel = '';
    try {
      if (widget.reservation.dateDebut.isNotEmpty &&
          widget.reservation.dateFin.isNotEmpty) {
        final inDate = Utils.toDateTime(widget.reservation.dateDebut);
        final outDate = Utils.toDateTime(widget.reservation.dateFin);
        final fmt = DateFormat('d MMM');
        dateLabel = '${fmt.format(inDate)} - ${fmt.format(outDate)}';
      }
    } catch (_) {}

    return BlocListener<RatingsCubit, RatingsState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ToastUtils.showSuccess(title: 'Merci pour votre avis !');
            Navigator.pop(context, true);
          },
          failure: (msg) => ToastUtils.showError(title: msg),
          orElse: () {},
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Le client a quitté la résidence',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (displayName.isNotEmpty) ...[
                const Gap(4),
                Text(
                  'Laissez un avis sur $displayName',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              const Gap(20),

              // Carte Client
              if (displayName.isNotEmpty || dateLabel.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      if (initialLetter.isNotEmpty) ...[
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF2548E5),
                          child: Text(
                            initialLetter,
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Gap(14),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayName.isNotEmpty)
                            Text(
                              displayName,
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          if (displayName.isNotEmpty && dateLabel.isNotEmpty)
                            const Gap(2),
                          if (dateLabel.isNotEmpty)
                            Text(
                              'Séjour du $dateLabel',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(24),
              ],

              // Note du client
              Text(
                'Note du client',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Gap(8),
              RatingBar.builder(
                initialRating: _rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 32,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFBB00),
                ),
                onRatingUpdate: (rating) {
                  setState(() => _rating = rating.toInt());
                },
              ),
              const Gap(24),

              // Qu'avez-vous apprécié ? (Comportement)
              Text(
                'Qu’avez-vous apprécié ?',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Gap(12),
              Row(
                children: GuestBehavior.values.map((behavior) {
                  final isSelected = _behaviorTag == behavior;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _behaviorTag = isSelected ? null : behavior;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2548E5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2548E5)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            behavior.label,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Gap(24),

              // Qu'avez-vous apprécié ? (État du logement)
              Text(
                'Qu’avez-vous apprécié ?',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Gap(12),
              Row(
                children: [
                  _buildConditionPill(PropertyCondition.excellent),
                  const Gap(8),
                  _buildConditionPill(PropertyCondition.good),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  _buildConditionPill(PropertyCondition.toClean),
                  const Gap(8),
                  _buildConditionPill(PropertyCondition.degraded),
                ],
              ),
              const Gap(24),

              // Recommanderiez-vous ce client ?
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recommanderiez-vous ce client ?',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMiniTogglePill(
                          label: 'Oui',
                          isSelected: _recommendClient == true,
                          onTap: () => setState(() => _recommendClient = true),
                        ),
                        _buildMiniTogglePill(
                          label: 'Non',
                          isSelected: _recommendClient == false,
                          onTap: () => setState(() => _recommendClient = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(24),

              // Commentaire ( optionnel )
              Text(
                'Commentaire ( optionnel )',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Gap(12),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                maxLength: 500,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFAFAFA),
                  filled: true,
                  hintText: 'Découvrez votre expérience...',
                  hintStyle:
                      GoogleFonts.dmSans(color: Colors.grey.shade400, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF2548E5)),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '${_feedbackController.text.length} / 500',
                  counterStyle:
                      GoogleFonts.dmSans(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
              const Gap(24),

              // Bouton d'envoi
              BlocBuilder<RatingsCubit, RatingsState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                  return SizedBox(
                    width: double.infinity,
                    child: CustomLoadingButtom(
                      text: 'Envoyer mon avis',
                      isLoading: isLoading,
                      color: const Color(0xFF2548E5),
                      onClick: _submit,
                    ),
                  );
                },
              ),
              Gap(MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionPill(PropertyCondition condition) {
    final isSelected = _stateTag == condition;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _stateTag = isSelected ? null : condition;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2548E5) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? const Color(0xFF2548E5) : Colors.grey.shade300,
            ),
          ),
          child: Text(
            condition.label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
