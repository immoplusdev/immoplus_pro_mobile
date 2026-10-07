import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';

class ChoicePromptWidget extends StatelessWidget {
  const ChoicePromptWidget({
    super.key,
    required this.message,
    required this.onOptionSelected,
    required this.isReadOnly,
  });

  final MessageModel message;
  final Function(String topic, String optionId, String label) onOptionSelected;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final payload = message.payload ?? {};
    final title = message.content.isNotEmpty
        ? message.content
        : 'Sélectionnez le motif de votre demande :';
    final optionsRaw = payload['options'] as List? ?? const [];

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.headphone, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Support ImmoPlus',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 12),
            Column(
              children: optionsRaw.map((opt) {
                final item = Map<String, dynamic>.from(opt is Map ? opt : {});
                final optionId = item['id']?.toString() ?? '';
                final label = item['label']?.toString() ?? '';
                final topic = item['topic']?.toString() ?? optionId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: isReadOnly
                          ? null
                          : () => onOptionSelected(topic, optionId, label),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Iconsax.arrow_right_3, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
