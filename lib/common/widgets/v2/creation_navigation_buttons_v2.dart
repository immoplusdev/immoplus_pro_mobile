import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class CreationNavigationButtonsV2 extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSave;
  final String saveText;
  final bool showNext;

  const CreationNavigationButtonsV2({
    super.key,
    required this.onPrevious,
    this.onNext,
    this.onSave,
    this.saveText = "Enregistrer",
    this.showNext = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      height: 72 + bottomPadding,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Gauche — Bouton icône rond ←
          GestureDetector(
            onTap: onPrevious,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF4B5563),
                size: 20,
              ),
            ),
          ),
          const Gap(8),
          
          // Centre — Bouton Enregistrer (CTA principal)
          Expanded(
            child: GestureDetector(
              onTap: onSave,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: (onSave == null) ? Colors.grey.shade200 : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  saveText,
                  style: TextStyle(
                    color: (onSave == null) ? Colors.grey.shade500 : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          
          if (showNext) ...[
            const Gap(8),
            // Droite — Bouton icône rond →
            GestureDetector(
              onTap: onNext,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (onNext == null) ? Colors.grey.shade200 : AppColors.primary,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: (onNext == null) ? Colors.grey.shade400 : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
