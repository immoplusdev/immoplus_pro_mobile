import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

class RejectReservationSheet extends StatefulWidget {
  const RejectReservationSheet({
    super.key,
    required this.reservationId,
    required this.onRejected,
  });

  final String reservationId;
  final VoidCallback onRejected;

  static Future<void> show(
    BuildContext context, {
    required String reservationId,
    required VoidCallback onRejected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => RejectReservationSheet(
        reservationId: reservationId,
        onRejected: onRejected,
      ),
    );
  }

  @override
  State<RejectReservationSheet> createState() => _RejectReservationSheetState();
}

class _RejectReservationSheetState extends State<RejectReservationSheet> {
  String _selectedReason = 'dates_indisponibles';
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  final _reasons = const [
    ('dates_indisponibles', 'Dates indisponibles', 'Le logement est déjà réservé à ces dates.'),
    ('travaux', 'Logement indisponible / travaux', 'Des travaux ou une maintenance sont prévus.'),
    ('logement_retire', 'Logement retiré', 'La résidence n\'est plus disponible à la location.'),
    ('autre', 'Autre motif', 'Un autre motif empêche l\'accueil.'),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await MessagingRepository.rejectReservation(
        widget.reservationId,
        reasonCode: _selectedReason,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Réservation refusée.');
      widget.onRejected();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      EasyLoading.showError('Le refus a échoué. Réessayez.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + bottomInset,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redFF0000.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Iconsax.close_circle, color: AppColors.redFF0000, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Refuser la réservation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Veuillez indiquer le motif du refus. Un message neutre sera transmis au client.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ..._reasons.map((item) {
              final (code, label, desc) = item;
              final isSelected = _selectedReason == code;
              return GestureDetector(
                onTap: () => setState(() => _selectedReason = code),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: code,
                        groupValue: _selectedReason,
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedReason = val);
                        },
                        activeColor: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            Text(
                              desc,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Text(
              'Notes internes (facultatif - jamais transmises au client)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Note confidentielle pour votre suivi...',
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: !_isSubmitting ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redFF0000,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
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
                        'Confirmer le refus',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
