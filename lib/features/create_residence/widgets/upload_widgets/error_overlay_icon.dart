import 'package:flutter/material.dart';

class ErrorOverlayIcon extends StatelessWidget {
  final String? message;
  const ErrorOverlayIcon({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.35),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 40),
              const SizedBox(height: 6),
              const Text('Échec',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              if (message != null && message!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
