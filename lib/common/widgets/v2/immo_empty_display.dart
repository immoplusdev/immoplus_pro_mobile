import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImmoEmptyDisplay extends StatelessWidget {
  final String text;

  const ImmoEmptyDisplay({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/svgs/empty.png",
              width: 150,
            ),
            const Gap(30),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9E9E9E), // Light grey matching the design
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
