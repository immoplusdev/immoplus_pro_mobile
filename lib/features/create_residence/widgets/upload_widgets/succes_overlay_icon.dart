// import 'package:flutter/material.dart';

// class SuccessOverlayIcon extends StatefulWidget {
//   const SuccessOverlayIcon({super.key});

//   @override
//   State<SuccessOverlayIcon> createState() => SuccessOverlayIconState();
// }

// class SuccessOverlayIconState extends State<SuccessOverlayIcon>
//     with SingleTickerProviderStateMixin {
//   double _opacity = 1.0;

//   @override
//   void initState() {
//     super.initState();

//     // Démarre le fade-out après 1 seconde
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() => _opacity = 0.0);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: _opacity,
//       duration: const Duration(milliseconds: 600),
//       child: const Center(
//         child: Icon(
//           Icons.check_circle,
//           color: Colors.white,
//           size: 40,
//         ),
//       ),
//     );
//   }
// }
