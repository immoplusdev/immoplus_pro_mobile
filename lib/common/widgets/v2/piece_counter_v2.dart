import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class PieceCounterV2 extends StatelessWidget {
  final String title;
  final int value;
  final Function(int) onUpdate;

  const PieceCounterV2({
    super.key,
    required this.title,
    required this.value,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Gap(15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          InkWell(
            onTap: () {
              if (value > 0) {
                onUpdate(-1);
              }
            },
            child:
                Icon(Icons.remove_circle, color: AppColors.primary, size: 28),
          ),
          const Gap(10),
          InkWell(
            onTap: () => onUpdate(1),
            child: Icon(Icons.add_circle, color: AppColors.primary, size: 28),
          ),
        ],
      ),
    );
  }
}
