import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

class WithdrawalRequestSheet extends StatefulWidget {
  const WithdrawalRequestSheet({
    super.key,
    required this.reservationId,
    required this.onRequested,
  });

  final String reservationId;
  final VoidCallback onRequested;

  static Future<void> show(
    BuildContext context, {
    required String reservationId,
    required VoidCallback onRequested,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => WithdrawalRequestSheet(
        reservationId: reservationId,
        onRequested: onRequested,
      ),
    );
  }

  @override
  State<WithdrawalRequestSheet> createState() => _WithdrawalRequestSheetState();
}

class _WithdrawalRequestSheetState extends State<WithdrawalRequestSheet> {
  String _paymentMethod = 'wave';
  final _addressController = TextEditingController();
  bool _isSubmitting = false;

  final _methods = const [
    ('wave', 'Wave', Iconsax.wallet_3),
    ('orange', 'Orange Money', Iconsax.mobile),
    ('mtn', 'MTN Mobile Money', Iconsax.mobile),
    ('moov', 'Moov Money', Iconsax.mobile),
    ('ecobank', 'Ecobank', Iconsax.card),
    ('visa_card', 'Carte Visa (Retrait)', Iconsax.card),
    ('cash', 'Espèces (Agence)', Iconsax.money_change),
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      EasyLoading.showError('Veuillez saisir le numéro ou compte de paiement.');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await MessagingRepository.requestWithdrawal(
        reservationId: widget.reservationId,
        paymentMethod: _paymentMethod,
        paymentAddress: address,
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Demande de retrait enregistrée avec succès !');
      widget.onRequested();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      EasyLoading.showError('Erreur lors de la demande de retrait.');
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
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.money_send, color: Color(0xFF0F6E56), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Demander le retrait des fonds',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Le montant net à percevoir est calculé automatiquement par ImmoPlus à la fin du séjour.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Moyen de retrait',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _paymentMethod,
                  isExpanded: true,
                  onChanged: (val) {
                    if (val != null) setState(() => _paymentMethod = val);
                  },
                  items: _methods.map((method) {
                    final (code, label, icon) = method;
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Row(
                        children: [
                          Icon(icon, size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(label, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Numéro de téléphone / Compte de réception',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ex: 0701020304',
                prefixIcon: const Icon(Iconsax.call, size: 18),
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
                  backgroundColor: const Color(0xFF0F6E56),
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
                        'Valider la demande de retrait',
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
