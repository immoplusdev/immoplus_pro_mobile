import 'package:flutter/material.dart';

class ProgressOverlayIcon extends StatelessWidget {
  final double? value;
  final String label;
  const ProgressOverlayIcon(
      {super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
