import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

import '../../logic/pro_guidance_rule.dart';

class ProGuidanceSheet extends StatelessWidget {
  const ProGuidanceSheet({
    super.key,
    required this.rule,
    required this.onAction,
  });

  final ProGuidanceRule rule;
  final VoidCallback onAction;

  static Future<void> show(
    BuildContext context, {
    required ProGuidanceRule rule,
    required VoidCallback onAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990B1720),
      showDragHandle: false,
      builder: (sheetContext) => ProGuidanceSheet(
        rule: rule,
        onAction: () {
          Navigator.of(sheetContext).pop();
          onAction();
        },
      ),
    );
  }

  IconData get _icon => switch (rule.intent) {
        'pro_answer_availability' => Iconsax.calendar,
        'propose_stay' => Iconsax.calendar_add,
        'pro_accept_reservation' => Iconsax.tick_circle,
        'pro_reject_reservation' => Iconsax.close_circle,
        'propose_visit' => Iconsax.location,
        'pro_open_support' => Iconsax.headphone,
        _ => Iconsax.message_question,
      };

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      top: false,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.94, end: 1),
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(22, 14, 22, bottomInset + 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DEE2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_icon, color: AppColors.primary, size: 25),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.title,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF17252D),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          rule.body,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: Color(0xFF627079),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Iconsax.arrow_right_3, size: 18),
                  label: Text(
                    rule.ctaLabel,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Pas maintenant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
