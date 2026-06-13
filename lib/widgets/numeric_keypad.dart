import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;
  final Widget? leftActionButton;

  const NumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
    this.leftActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildKeyRow(context, ['1', '2', '3']),
        const SizedBox(height: 15),
        _buildKeyRow(context, ['4', '5', '6']),
        const SizedBox(height: 15),
        _buildKeyRow(context, ['7', '8', '9']),
        const SizedBox(height: 15),
        _buildLastRow(context),
      ],
    );
  }

  Widget _buildKeyRow(BuildContext context, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys.map((key) => _buildKey(context, key)).toList(),
    );
  }

  Widget _buildLastRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        leftActionButton ?? const SizedBox(width: 80),
        _buildKey(context, '0'),
        _buildDeleteButton(context),
      ],
    );
  }

  Widget _buildKey(BuildContext context, String value) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onKeyPressed(value);
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.05),
        ),
        child: Text(
          value,
          style: GoogleFonts.sen(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onDeletePressed();
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
