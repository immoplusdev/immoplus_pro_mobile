import 'package:flutter/material.dart';

class BannerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color color;

  const BannerButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.0,
                decoration: TextDecoration.underline,
                decorationColor: color,
                decorationThickness: 1.5,
              ),
        ),
      ),
    );
  }
}
