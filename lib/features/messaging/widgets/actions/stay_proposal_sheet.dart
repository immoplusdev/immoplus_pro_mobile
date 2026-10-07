import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:intl/intl.dart';

class StayProposalSheet extends StatefulWidget {
  const StayProposalSheet({
    super.key,
    required this.residenceId,
    required this.onSendProposal,
  });

  final String residenceId;
  final Future<void> Function({
    required String checkIn,
    required String checkOut,
    required int guests,
  }) onSendProposal;

  static Future<void> show(
    BuildContext context, {
    required String residenceId,
    required Future<void> Function({
      required String checkIn,
      required String checkOut,
      required int guests,
    }) onSendProposal,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => StayProposalSheet(
        residenceId: residenceId,
        onSendProposal: onSendProposal,
      ),
    );
  }

  @override
  State<StayProposalSheet> createState() => _StayProposalSheetState();
}

class _StayProposalSheetState extends State<StayProposalSheet> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 2;
  bool _isSubmitting = false;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  final DateFormat _displayFormatter = DateFormat('dd/MM/yyyy');

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _checkInDate != null && _checkOutDate != null
          ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
          : DateTimeRange(
              start: now.add(const Duration(days: 1)),
              end: now.add(const Duration(days: 4)),
            ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
  }

  Future<void> _submit() async {
    if (_checkInDate == null || _checkOutDate == null) {
      EasyLoading.showError('Veuillez sélectionner les dates du séjour.');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await widget.onSendProposal(
        checkIn: _formatter.format(_checkInDate!),
        checkOut: _formatter.format(_checkOutDate!),
        guests: _guests,
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Proposition de séjour envoyée !');
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      EasyLoading.showError('Erreur lors de l\'envoi de la proposition.');
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
                Icon(Iconsax.house_2, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Proposer un séjour',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Le montant exact est calculé automatiquement par le serveur selon les tarifs de votre résidence et la durée.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dates de séjour',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDateRange,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar_1, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _checkInDate != null && _checkOutDate != null
                            ? '${_displayFormatter.format(_checkInDate!)} → ${_displayFormatter.format(_checkOutDate!)}'
                            : 'Sélectionner les dates d\'arrivée et départ',
                        style: TextStyle(
                          fontSize: 14,
                          color: _checkInDate != null
                              ? const Color(0xFF1E293B)
                              : Colors.grey.shade500,
                          fontWeight: _checkInDate != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre de voyageurs',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                    icon: const Icon(Iconsax.minus),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$_guests pers.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _guests < 20 ? () => setState(() => _guests++) : null,
                    icon: const Icon(Iconsax.add),
                  ),
                ),
              ],
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
                        'Envoyer la proposition (valide 48h)',
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
