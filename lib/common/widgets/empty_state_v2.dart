import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

class EmptyStateV2 extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const EmptyStateV2({
    super.key,
    required this.title,
    required this.description,
    this.icon = Iconsax.document_text,
    this.iconColor = const Color(0xFF12B76A),
    this.iconBackgroundColor = const Color(0xFFECFDF3),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Gap(20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 36,
              color: iconColor,
            ),
          ),
          const Gap(24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
          ),
          const Gap(8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667085),
                  height: 1.5,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
