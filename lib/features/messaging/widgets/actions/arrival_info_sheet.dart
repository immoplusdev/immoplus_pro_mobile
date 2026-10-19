import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

class ArrivalInfoSheet extends StatefulWidget {
  const ArrivalInfoSheet({
    super.key,
    required this.residenceId,
    required this.onUpdated,
  });

  final String residenceId;
  final VoidCallback onUpdated;

  static Future<void> show(
    BuildContext context, {
    required String residenceId,
    required VoidCallback onUpdated,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => ArrivalInfoSheet(
        residenceId: residenceId,
        onUpdated: onUpdated,
      ),
    );
  }

  @override
  State<ArrivalInfoSheet> createState() => _ArrivalInfoSheetState();
}

class _ArrivalInfoSheetState extends State<ArrivalInfoSheet> {
  final _instructionsController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _instructionsController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    final instructions = _instructionsController.text.trim().isEmpty
        ? null
        : _instructionsController.text.trim();
    final code = _codeController.text.trim().isEmpty
        ? null
        : _codeController.text.trim();

    try {
      await MessagingRepository.updateArrivalInfo(
        widget.residenceId,
        accessInstructions: instructions,
        accessCode: code,
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Fiche d\'arrivée mise à jour.');
      widget.onUpdated();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      EasyLoading.showError('Erreur de mise à jour de la fiche d\'arrivée.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.key, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Fiche d\'arrivée & Consignes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Renseignez les instructions d\'accès et/ou le code de la boîte à clés. Ces informations seront automatiquement transmises au client.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions d\'accès (facultatif)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _instructionsController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Ex: Portet principal à droite, 2ème étage, digicode au portail...',
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Code d\'accès / Boîte à clés (facultatif, chiffré)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _codeController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ex: 1234A',
                prefixIcon: const Icon(Iconsax.lock, size: 18),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                        'Enregistrer la fiche d\'arrivée',
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
