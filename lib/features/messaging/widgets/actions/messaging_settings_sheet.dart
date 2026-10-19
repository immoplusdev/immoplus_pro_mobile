import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';
import 'package:intl/intl.dart';

class MessagingSettingsSheet extends StatefulWidget {
  const MessagingSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => const MessagingSettingsSheet(),
    );
  }

  @override
  State<MessagingSettingsSheet> createState() => _MessagingSettingsSheetState();
}

class _MessagingSettingsSheetState extends State<MessagingSettingsSheet> {
  bool _autoAvailabilityReply = false;
  DateTime? _absenceUntil;
  bool _isLoading = true;
  bool _isSaving = false;

  final DateFormat _displayFormatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await MessagingRepository.getMessagingSettings();
      if (mounted) {
        setState(() {
          _autoAvailabilityReply = settings['autoAvailabilityReply'] == true;
          if (settings['absenceUntil'] != null) {
            _absenceUntil = DateTime.tryParse(settings['absenceUntil'].toString());
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAbsenceDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _absenceUntil ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
      );

      if (pickedTime != null) {
        setState(() {
          _absenceUntil = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await MessagingRepository.updateMessagingSettings(
        autoAvailabilityReply: _autoAvailabilityReply,
        absenceUntil: _absenceUntil?.toIso8601String(),
      );
      if (!mounted) return;
      EasyLoading.showSuccess('Réglages enregistrés.');
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      EasyLoading.showError('Erreur de sauvegarde des réglages.');
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
                Icon(Iconsax.setting_2, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Réglages de messagerie',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Réponse automatique de disponibilité',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Répondre automatiquement selon les disponibilités réelles de votre calendrier.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                value: _autoAvailabilityReply,
                activeTrackColor: AppColors.primary,
                onChanged: (val) => setState(() => _autoAvailabilityReply = val),
              ),
              const Divider(height: 24),
              const Text(
                'Mode absence',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'L\'absence suspend les relances non urgentes jusqu\'à la date choisie.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickAbsenceDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.calendar_tick, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _absenceUntil != null
                              ? 'Absent jusqu\'au ${_displayFormatter.format(_absenceUntil!)}'
                              : 'Définir une période d\'absence',
                          style: TextStyle(
                            fontSize: 13,
                            color: _absenceUntil != null
                                ? const Color(0xFF1E293B)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      if (_absenceUntil != null)
                        IconButton(
                          icon: const Icon(Iconsax.close_circle, size: 18),
                          onPressed: () => setState(() => _absenceUntil = null),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: !_isSaving ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Enregistrer les réglages',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
