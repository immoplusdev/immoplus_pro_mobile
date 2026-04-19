import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class SelectorTileV2 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool hasValue;
  final VoidCallback onTap;

  const SelectorTileV2({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.hasValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                hasValue ? value! : title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                  color: hasValue ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
