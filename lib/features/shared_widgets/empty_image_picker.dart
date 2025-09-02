import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class EmptyImagePicker extends StatelessWidget {
  const EmptyImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DottedBorder(
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        color: CupertinoColors.systemGrey,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.photoFilm,
              size: 100,
              color: Colors.grey,
            ),
            Gap(10),
            Text(
              "Capturez la beauté de votre bien ! Prenez des photos soigneusement travaillées pour attirer davantage de clients. N'oubliez pas, la première image sélectionnée sera celle affichée en miniature.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
