import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

class RateGuestSheet extends StatefulWidget {
  const RateGuestSheet({
    super.key,
    required this.reservationId,
    required this.onRated,
  });

  final String reservationId;
  final VoidCallback onRated;

  static Future<void> show(
    BuildContext context, {
    required String reservationId,
    required VoidCallback onRated,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => RateGuestSheet(
        reservationId: reservationId,
        onRated: onRated,
      ),
    );
  }

  @override
  State<RateGuestSheet> createState() => _RateGuestSheetState();
}

class _RateGuestSheetState extends State<RateGuestSheet> {
  int _rating = 5;
  String _behavior = 'Respectueux';
  String _condition = 'Excellente';
  bool _wouldRecommend = true;
  final _feedbackController = TextEditingController();
  final _issuesController = TextEditingController();
  bool _isSubmitting = false;

  final _behaviors = const ['Respectueux', 'Acceptable', 'Problématique'];
  final _conditions = const ['Excellente', 'Bonne', 'À nettoyer', 'Dégradée'];

  @override
  void dispose() {
    _feedbackController.dispose();
    _issuesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await MessagingRepository.rateGuest(
        reservationId: widget.reservationId,
        clientRating: _rating,
        guestBehavior: _behavior,
        propertyCondition: _condition,
        wouldRecommend: _wouldRecommend,
        clientFeedback: _feedbackController.text.trim().isEmpty
            ? null
            : _feedbackController.text.trim(),
        anyIssues: _issuesController.text.trim().isEmpty
            ? null
            : _issuesController.text.trim(),
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Évaluation envoyée avec succès !');
      widget.onRated();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      EasyLoading.showError('Impossible d\'envoyer l\'évaluation.');
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
                Icon(Iconsax.star1, color: Colors.amber.shade700, size: 26),
                const SizedBox(width: 10),
                const Text(
                  'Évaluer le client',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Donnez votre avis sur le séjour du voyageur.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Text('Note globale',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = starIndex),
                  icon: Icon(
                    starIndex <= _rating ? Iconsax.star1 : Iconsax.star,
                    color: Colors.amber.shade600,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text('Comportement du client',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _behaviors.map((item) {
                final isSelected = _behavior == item;
                return ChoiceChip(
                  label: Text(item),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey.shade800,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _behavior = item),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('État du logement à la sortie',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _conditions.map((item) {
                final isSelected = _condition == item;
                return ChoiceChip(
                  label: Text(item),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey.shade800,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _condition = item),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: ZeroPadding.zero,
              title: const Text('Recommanderiez-vous ce client ?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              value: _wouldRecommend,
              activeTrackColor: AppColors.primary,
              onChanged: (val) => setState(() => _wouldRecommend = val),
            ),
            const SizedBox(height: 12),
            Text('Commentaire (facultatif, 500 car. max)',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            TextField(
              controller: _feedbackController,
              maxLength: 500,
              maxLines: 2,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Avis sur la communication, le respect des règles...',
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
                  backgroundColor: AppColors.primary,
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
                        'Soumettre l\'évaluation',
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

class ZeroPadding {
  static const EdgeInsets zero = EdgeInsets.zero;
}
